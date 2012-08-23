package org.gbif.portal.action.organization;

import org.gbif.api.paging.PagingRequest;
import org.gbif.api.paging.PagingResponse;
import org.gbif.portal.action.member.MemberBaseAction;
import org.gbif.registry.api.model.Dataset;
import org.gbif.registry.api.model.Node;
import org.gbif.registry.api.model.Organization;
import org.gbif.registry.api.service.DatasetService;
import org.gbif.registry.api.service.NodeService;
import org.gbif.registry.api.service.OrganizationService;

import java.util.List;

import com.google.inject.Inject;

public class DetailAction extends MemberBaseAction<Organization> {

  @Inject
  private NodeService nodeService;
  @Inject
  private DatasetService datasetService;

  private Node node;
  private List<Dataset> datasets;
  private boolean more;

  @Inject
  public DetailAction(OrganizationService organizationService) {
    super(organizationService);
  }

  @Override
  public String execute() throws Exception {
    super.execute();
    // load endorsing node
    if (member.getEndorsingNodeKey() != null) {
      node = nodeService.get(member.getEndorsingNodeKey());
    }
    // load first 10 datasets
    PagingResponse<Dataset> resp = datasetService.listOwnedBy(id, new PagingRequest(0, 10));
    datasets = resp.getResults();
    more = !resp.isEndOfRecords();

    return SUCCESS;
  }

  public Node getNode() {
    return node;
  }

  public List<Dataset> getDatasets() {
    return datasets;
  }

  public boolean isMore() {
    return more;
  }
}
