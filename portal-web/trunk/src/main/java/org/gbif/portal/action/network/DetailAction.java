package org.gbif.portal.action.network;

import org.gbif.api.model.common.paging.PagingRequest;
import org.gbif.api.model.common.paging.PagingResponse;
import org.gbif.api.model.registry.Dataset;
import org.gbif.api.model.registry.Network;
import org.gbif.api.model.registry.Organization;
import org.gbif.api.service.registry.NetworkService;
import org.gbif.api.service.registry.OrganizationService;
import org.gbif.portal.action.member.MemberBaseAction;
import org.gbif.portal.action.member.MemberType;

import java.util.Map;
import java.util.UUID;

import com.google.common.collect.Maps;
import com.google.inject.Inject;

public class DetailAction extends MemberBaseAction<Network> {

  private final NetworkService networkService;
  private final OrganizationService organizationService;
  private PagingResponse<Dataset> page;
  private long offset = 0;
  private Map<UUID, Organization> orgMap = Maps.newHashMap();

  @Inject
  public DetailAction(NetworkService networkService, OrganizationService organizationService) {
    super(MemberType.NETWORK, networkService);
    this.networkService = networkService;
    this.organizationService = organizationService;
  }

  @Override
  public String execute() throws Exception {
    super.execute();
    // load first 10 datasets
   page = networkService.listConstituents(id, new PagingRequest(0, 10));

    return SUCCESS;
  }

  public String datasets() throws Exception {
    super.execute();
    page = networkService.listConstituents(id, new PagingRequest(offset, 25));
    return SUCCESS;
  }

  public PagingResponse<Dataset> getPage() {
    return page;
  }

  public void setOffset(long offset) {
    if (offset >= 0) {
      this.offset = offset;
    }
  }

  /**
   * Utility method to access node infos using a small map cache.
   * Used in templates to show the publisher for datasets.
   */
  public Organization getOrganization(UUID key) {
    if (orgMap.containsKey(key)) {
      return orgMap.get(key);
    }
    Organization o = organizationService.get(key);
    orgMap.put(key, o);
    return o;
  }
}
