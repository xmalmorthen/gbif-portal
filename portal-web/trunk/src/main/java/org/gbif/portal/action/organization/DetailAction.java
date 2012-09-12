package org.gbif.portal.action.organization;

import org.gbif.api.model.registry.Dataset;
import org.gbif.api.model.registry.Node;
import org.gbif.api.model.registry.Organization;
import org.gbif.api.paging.PagingRequest;
import org.gbif.api.paging.PagingResponse;
import org.gbif.api.service.registry.DatasetService;
import org.gbif.api.service.registry.NodeService;
import org.gbif.api.service.registry.OrganizationService;
import org.gbif.portal.action.member.MemberBaseAction;

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

  public List<Dataset> getDatasets() {
    return datasets;
  }

  public Node getNode() {
    return node;
  }

  public boolean isMore() {
    return more;
  }
}
