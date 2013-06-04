package org.gbif.portal.action.node;

import org.gbif.api.model.common.paging.PagingRequest;
import org.gbif.api.model.common.paging.PagingResponse;
import org.gbif.api.model.registry2.Node;
import org.gbif.api.model.registry2.Organization;
import org.gbif.api.service.registry2.NodeService;
import org.gbif.portal.action.member.MemberBaseAction;

import com.google.inject.Inject;

public class DetailAction extends MemberBaseAction<Node> {

  private final NodeService nodeService;

  private PagingResponse<Organization> page;
  private long offset = 0;

  @Inject
  public DetailAction(NodeService nodeService) {
    super(nodeService);
    this.nodeService = nodeService;
  }

  @Override
  public String execute() throws Exception {
    super.execute();
    // redirect to country page if this node is a country node
    if (member.getCountry() != null) {
      id = null;
      return "country";
    }

    page = nodeService.endorsedOrganizations(id, new PagingRequest(0, 10));
    return SUCCESS;
  }

  public String organizations() throws Exception {
    super.execute();

    page = nodeService.endorsedOrganizations(id, new PagingRequest(offset, 25));
    return SUCCESS;
  }

  public PagingResponse<Organization> getPage() {
    return page;
  }

  public void setOffset(long offset) {
    if (offset >= 0) {
      this.offset = offset;
    }
  }
}
