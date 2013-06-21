package org.gbif.portal.action.node;

import org.gbif.api.model.common.paging.PagingRequest;
import org.gbif.api.model.common.paging.PagingResponse;
import org.gbif.api.model.metrics.cube.OccurrenceCube;
import org.gbif.api.model.metrics.cube.ReadBuilder;
import org.gbif.api.model.registry2.Contact;
import org.gbif.api.model.registry2.Dataset;
import org.gbif.api.model.registry2.Endpoint;
import org.gbif.api.model.registry2.Node;
import org.gbif.api.model.registry2.Organization;
import org.gbif.api.service.metrics.CubeService;
import org.gbif.api.service.registry2.NodeService;
import org.gbif.api.vocabulary.registry2.ContactType;
import org.gbif.api.vocabulary.registry2.EndpointType;
import org.gbif.portal.action.member.MemberBaseAction;
import org.gbif.portal.model.CountWrapper;

import java.util.List;

import com.google.common.collect.Lists;
import com.google.inject.Inject;

public class DetailAction extends MemberBaseAction<Node> {

  protected final NodeService nodeService;
  protected CubeService cubeService;

  private PagingResponse<Organization> page;
  private long offset = 0;

  protected List<CountWrapper<Dataset>> datasets = Lists.newArrayList();

  @Inject
  public DetailAction(NodeService nodeService, CubeService cubeService) {
    super(nodeService);
    this.nodeService = nodeService;
    this.cubeService = cubeService;
  }

  @Override
  public String execute() throws Exception {
    super.execute();
    // redirect to country page if this node is a country node
    if (member.getCountry() != null) {
      id = null;
      return "country";
    }

    loadLatestDatasetsPublished(10);
    loadOrganizations(10);

    return SUCCESS;
  }

  /**
   * Page through endorsed organizations main method used in struts.xml
   */
  public String organizations() throws Exception {
    super.execute();
    loadOrganizations(25);
    return SUCCESS;
  }

  protected void loadLatestDatasetsPublished(int limit) {
    PagingResponse<Dataset> ds = nodeService.endorsedDatasets(id, new PagingRequest(0, limit));
    for (Dataset d : ds.getResults()) {
      long cnt = cubeService.get(new ReadBuilder()
        .at(OccurrenceCube.DATASET_KEY, d.getKey()));

      long geoCnt = cubeService.get(new ReadBuilder()
        .at(OccurrenceCube.DATASET_KEY, d.getKey())
        .at(OccurrenceCube.IS_GEOREFERENCED, true));

      datasets.add(new CountWrapper(d, cnt, geoCnt));
    }
  }

  protected void loadOrganizations(int limit) {
    page = nodeService.endorsedOrganizations(id, new PagingRequest(offset, limit));
  }


  public PagingResponse<Organization> getPage() {
    return page;
  }

  public void setOffset(long offset) {
    if (offset >= 0) {
      this.offset = offset;
    }
  }

  public List<CountWrapper<Dataset>> getDatasets() {
    return datasets;
  }

  public String getFeed() {
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


}
