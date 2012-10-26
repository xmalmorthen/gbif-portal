package org.gbif.portal.action.organization;

import org.gbif.api.model.common.paging.PagingRequest;
import org.gbif.api.model.common.paging.PagingResponse;
import org.gbif.api.model.registry.Dataset;
import org.gbif.api.model.registry.Organization;
import org.gbif.api.service.registry.DatasetService;
import org.gbif.api.service.registry.OrganizationService;
import org.gbif.portal.action.member.MemberBaseAction;

import com.google.inject.Inject;

/**
 * This action builds everything needed for displaying the published (owned) datasets
 * for a single Organization. Uses the {@link DatasetService} to get back the list of
 * owned datasets.
 */
public class OwnedDatasetAction extends MemberBaseAction<Organization> {

  private PagingResponse<Dataset> page;
  private final DatasetService datasetService;
  private long offset = 0;

  @Inject
  public OwnedDatasetAction(OrganizationService organizationService, DatasetService datasetService) {
    super(organizationService);
    this.datasetService = datasetService;
  }

  @Override
  public String execute() throws Exception {
    super.execute();
    PagingRequest p = new PagingRequest(offset, 25);
    page = datasetService.listOwnedBy(id, p);
    return SUCCESS;
  }

  public PagingResponse<Dataset> getPage() {
    return page;
  }

  public void setOffset(long offset) {
    this.offset = offset;
  }
}