package org.gbif.portal.action.publisher;

import org.gbif.api.model.common.paging.PagingRequest;
import org.gbif.api.model.common.paging.PagingResponse;
import org.gbif.api.model.registry.Dataset;
import org.gbif.api.model.registry.Node;
import org.gbif.api.model.registry.Organization;
import org.gbif.api.service.registry.NodeService;
import org.gbif.api.service.registry.OrganizationService;
import org.gbif.portal.action.member.MemberBaseAction;
import org.gbif.portal.action.member.MemberType;

import com.google.inject.Inject;

public class DetailAction extends MemberBaseAction<Organization> {

  @Inject
  private NodeService nodeService;
  private final OrganizationService organizationService;

  private Node node;
  private PagingResponse<Dataset> page;
  private long offset = 0;

  @Inject
  public DetailAction(OrganizationService organizationService) {
    super(MemberType.PUBLISHER, organizationService);
    this.organizationService = organizationService;
  }

  @Override
  public String execute() throws Exception {
    super.execute();
    // load endorsing node
    if (member.getEndorsingNodeKey() != null) {
      node = nodeService.get(member.getEndorsingNodeKey());
    }
    // load first 10 datasets
    page = organizationService.ownedDatasets(id, new PagingRequest(0, 10));

    return SUCCESS;
  }

  public String datasets() throws Exception {
    super.execute();
    page = organizationService.ownedDatasets(id, new PagingRequest(offset, 25));
    return SUCCESS;
  }

  public void setOffset(long offset) {
    if (offset >= 0) {
      this.offset = offset;
    }
  }

  public Node getNode() {
    return node;
  }

  public PagingResponse<Dataset> getPage() {
    return page;
  }
}
