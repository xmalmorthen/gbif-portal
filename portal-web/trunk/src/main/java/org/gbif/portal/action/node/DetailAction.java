package org.gbif.portal.action.node;

import org.gbif.api.paging.PagingRequest;
import org.gbif.api.paging.PagingResponse;
import org.gbif.portal.action.member.MemberBaseAction;
import org.gbif.registry.api.model.Node;
import org.gbif.registry.api.model.Organization;
import org.gbif.registry.api.service.NodeService;

import java.util.List;

import com.google.inject.Inject;

public class DetailAction extends MemberBaseAction<Node> {

  private NodeService nodeService;

  private List<Organization> organizations;
  private boolean more;

  @Inject
  public DetailAction(NodeService nodeService) {
    super(nodeService);
    this.nodeService = nodeService;
  }

  @Override
  public String execute() throws Exception {
    super.execute();
    // load first 10 orgs
    PagingResponse<Organization> resp = nodeService.listEndorsedBy(id, new PagingRequest(0, 10));
    organizations = resp.getResults();
    more = !resp.isEndOfRecords();

    return SUCCESS;
  }

  public List<Organization> getOrganizations() {
    return organizations;
  }

  public boolean isMore() {
    return more;
  }
}
