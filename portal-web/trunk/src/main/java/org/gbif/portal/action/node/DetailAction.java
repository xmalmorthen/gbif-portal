package org.gbif.portal.action.node;

import org.gbif.api.paging.PagingRequest;
import org.gbif.portal.action.member.MemberBaseAction;
import org.gbif.registry.api.model.Node;
import org.gbif.registry.api.model.Organization;
import org.gbif.registry.api.service.NodeService;

import java.util.List;

import com.google.inject.Inject;

public class DetailAction extends MemberBaseAction<Node> {

  private NodeService nodeService;

  private List<Organization> organizations;

  @Inject
  public DetailAction(NodeService nodeService) {
    super(nodeService);
    this.nodeService = nodeService;
  }

  @Override
  public String execute() throws Exception {
    super.execute();
    // load first 10 orgs
    organizations = nodeService.listEndorsedBy(id, new PagingRequest(0,10)).getResults();

    return SUCCESS;
  }

  public List<Organization> getOrganizations() {
    return organizations;
  }
}
