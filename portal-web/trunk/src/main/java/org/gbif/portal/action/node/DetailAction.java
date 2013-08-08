package org.gbif.portal.action.node;

import org.gbif.api.model.common.paging.PagingRequest;
import org.gbif.api.model.common.paging.PagingResponse;
import org.gbif.api.model.metrics.cube.OccurrenceCube;
import org.gbif.api.model.metrics.cube.ReadBuilder;
import org.gbif.api.model.registry.Contact;
import org.gbif.api.model.registry.Dataset;
import org.gbif.api.model.registry.Endpoint;
import org.gbif.api.model.registry.Node;
import org.gbif.api.model.registry.Organization;
import org.gbif.api.service.metrics.CubeService;
import org.gbif.api.service.registry.NodeService;
import org.gbif.api.vocabulary.ContactType;
import org.gbif.api.vocabulary.EndpointType;
import org.gbif.api.vocabulary.NodeType;
import org.gbif.portal.action.member.MemberBaseAction;
import org.gbif.portal.action.member.MemberType;
import org.gbif.portal.model.CountWrapper;

import java.net.URI;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

import com.google.common.collect.ComparisonChain;
import com.google.common.collect.Lists;
import com.google.common.collect.Ordering;
import com.google.inject.Inject;

public class DetailAction extends MemberBaseAction<Node> {

  protected final NodeService nodeService;
  protected CubeService cubeService;

  private PagingResponse<Organization> publisherPage;
  protected PagingResponse<Dataset> datasetPage;
  private long offset = 0;

  protected List<CountWrapper<Dataset>> datasets = Lists.newArrayList();
  private Long datasetsCount;

  private static List<ContactType> contactTypeOrder = Lists.newArrayList(
    ContactType.HEAD_OF_DELEGATION,
    ContactType.REGIONAL_NODE_REPRESENTATIVE,
    ContactType.NODE_MANAGER,
    ContactType.NODE_STAFF
  );

  static {
    for (ContactType ct : ContactType.values()) {
      if (!contactTypeOrder.contains(ct)) {
        contactTypeOrder.add(ct);
      }
    }
  }

  private static Comparator<Contact> nodeContactOrder = new NodeContactOrder ();

  /**
   * Ordering based on contact types with head of delegation and node managers coming first.
   */
  public static class NodeContactOrder implements Comparator<Contact> {

    @Override
    public int compare(Contact o1, Contact o2) {
      if (o1.getType() != null && o2.getType() != null && o1.getType() != o2.getType()) {
        return contactTypeOrder.indexOf(o1.getType()) - contactTypeOrder.indexOf(o2.getType());
      }
      return ComparisonChain.start()
        .compare(o1.isPrimary(), o2.isPrimary(), Ordering.natural().nullsLast())
        .compare(o1.getType(), o2.getType(), Ordering.natural().nullsLast())
        .compare(o1.getFirstName(), o2.getFirstName(), Ordering.natural().nullsLast())
        .compare(o1.getLastName(), o2.getLastName(), Ordering.natural().nullsLast())
        .compare(o1.getKey(), o2.getKey())
        .result();
    }
  }

  @Inject
  public DetailAction(NodeService nodeService, CubeService cubeService) {
    super(MemberType.NODE, nodeService);
    this.nodeService = nodeService;
    this.cubeService = cubeService;
  }

  @Override
  public String execute() throws Exception {
    super.execute();
    // redirect to country page if this node is a country node
    if (NodeType.COUNTRY ==  member.getType()) {
      id = null;
      return "country";
    }

    loadLatestDatasetsPublished(10);
    loadPublishers(10);
    sortContacts();
    return SUCCESS;
  }

  protected void sortContacts() {
    if (member != null) {
      Collections.sort(member.getContacts(), nodeContactOrder);
    }
  }

  /**
   * Page through endorsed organizations main method used in struts.xml
   */
  public String publishers() throws Exception {
    super.execute();
    loadPublishers(25);
    return SUCCESS;
  }

  protected void loadLatestDatasetsPublished(int limit) {
    datasetPage = nodeService.endorsedDatasets(member.getKey(), new PagingRequest(offset, limit));
    datasetsCount = datasetPage.getCount();
    for (Dataset d : datasetPage.getResults()) {
      long cnt = cubeService.get(new ReadBuilder()
        .at(OccurrenceCube.DATASET_KEY, d.getKey()));

      long geoCnt = cubeService.get(new ReadBuilder()
        .at(OccurrenceCube.DATASET_KEY, d.getKey())
        .at(OccurrenceCube.IS_GEOREFERENCED, true));

      datasets.add(new CountWrapper(d, cnt, geoCnt));
    }
  }

  protected void loadPublishers(int limit) {
    publisherPage = nodeService.endorsedOrganizations(member.getKey(), new PagingRequest(offset, limit));
  }


  public PagingResponse<Organization> getPublisherPage() {
    return publisherPage;
  }

  public PagingResponse<Dataset> getDatasetPage() {
    return datasetPage;
  }

  public void setOffset(long offset) {
    if (offset >= 0) {
      this.offset = offset;
    }
  }

  public List<CountWrapper<Dataset>> getDatasets() {
    return datasets;
  }

  public URI getFeed() {
    if (member != null && !member.getEndpoints().isEmpty()) {
      for (Endpoint e : member.getEndpoints()) {
        if (EndpointType.FEED == e.getType()) {
          return e.getUrl();
        }
      }
    }
    return null;
  }

  /**
   * Used in freemaker to just show the head of delegation.
   */
  public Contact getHeadOfDelegation() {
    if (member != null && !member.getContacts().isEmpty()) {
      for (Contact c : member.getContacts()) {
        if (ContactType.HEAD_OF_DELEGATION == c.getType()) {
          return c;
        }
      }
    }
    return null;
  }

  /**
   * Used in freemaker to just show the node managers.
   */
  public List<Contact> getNodeManagers() {
    return getContacts(ContactType.NODE_MANAGER);
  }

  public List<Contact> getContacts(ContactType type) {
    List<Contact> contacts = Lists.newArrayList();
    if (member != null && !member.getContacts().isEmpty()) {
      for (Contact c : member.getContacts()) {
        if (type == c.getType()) {
          contacts.add(c);
        }
      }
    }
    return contacts;
  }

  public Long getDatasetsCount() {
    return datasetsCount;
  }

  public long getOffset() {
    return offset;
  }

  public Node getNode() {
    return member;
  }

}
