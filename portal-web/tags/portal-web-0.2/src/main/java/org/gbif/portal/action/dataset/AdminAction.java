package org.gbif.portal.action.dataset;

import org.gbif.api.model.common.paging.PagingResponse;
import org.gbif.api.model.registry.Dataset;
import org.gbif.api.model.registry.Organization;
import org.gbif.api.model.registry.TechnicalInstallation;
import org.gbif.api.service.registry.DatasetService;
import org.gbif.api.service.registry.OrganizationService;
import org.gbif.api.service.registry.TechnicalInstallationService;
import org.gbif.portal.action.AdminBaseAction;

import java.util.List;
import java.util.UUID;

import javax.validation.Valid;

import com.google.inject.Inject;

public class AdminAction extends AdminBaseAction<DatasetService, Dataset> {

  @Inject
  OrganizationService organizationWsClient;

  @Inject
  TechnicalInstallationService technicalInstallationWsClient;

  @Valid
  Dataset member;

  /**
   * @return the dataset.
   */
  public Dataset getMember() {
    if (id != null && member == null) {
      member = loadMember(id);
    }
    return member;
  }

  protected Dataset loadMember(UUID id) {
    return wsClient.get(id);
  }

  /**
   * @param dataset the dataset to set.
   */
  public void setMember(Dataset member) {
    this.member = member;
  }

  /**
   * @return the hostingOrganization
   */
  public Organization getHostingOrganization() {
    if (member.getTechnicalInstallationKey() != null) {
      TechnicalInstallation technicalInstallation =
        technicalInstallationWsClient.get(member.getTechnicalInstallationKey());
      if (!technicalInstallation.getHostingOrganizationKey().equals(member.getOwningOrganizationKey())) {
        return organizationWsClient.get(technicalInstallation.getHostingOrganizationKey());
      }
    }
    return null;
  }

  public List<Organization> getOrganizations() {
    PagingResponse<Organization> response = organizationWsClient.list(null);

    if (response != null) {
      return response.getResults();
    }
    return null;
  }

  public String editEntity() {
    // TODO: add logic required to edit the dataset fields (calling WS client)
    return SUCCESS;
  }

  public String addEntity() {
    // first persist the WritableDataset entity
    UUID dataseKey = wsClient.create(member);
    createMembers(dataseKey);
    return SUCCESS;
  }

  @Override
  public Dataset getEntity() {
    return getMember();
  }
}
