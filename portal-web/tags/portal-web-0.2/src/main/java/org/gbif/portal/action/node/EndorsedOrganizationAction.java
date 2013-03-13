package org.gbif.portal.action.node;

import org.gbif.api.model.common.paging.PagingRequest;
import org.gbif.api.model.common.paging.PagingResponse;
import org.gbif.api.model.registry.Node;
import org.gbif.api.model.registry.Organization;
import org.gbif.api.service.registry.NodeService;
import org.gbif.portal.action.member.MemberBaseAction;

import com.google.inject.Inject;

/**
 * This action builds everything needed for displaying the endorsed organizations
 * for a single Node. Uses the {@link NodeService} to get back the list of endorsed
 * organizations. 
 */
public class EndorsedOrganizationAction extends MemberBaseAction<Node> {

  private PagingResponse<Organization> page;
  private final NodeService nodeService;
  private long offset = 0;

  @Inject
  public EndorsedOrganizationAction(NodeService nodeService) {
    super(nodeService);
    this.nodeService = nodeService;
  }

  @Override
  public String execute() throws Exception {
    super.execute();
    PagingRequest p = new PagingRequest(offset, 25);
    page = nodeService.listEndorsedBy(id, p);
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