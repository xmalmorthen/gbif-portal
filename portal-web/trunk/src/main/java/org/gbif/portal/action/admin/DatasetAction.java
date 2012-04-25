package org.gbif.portal.action.admin;

import org.gbif.api.paging.PagingResponse;
import org.gbif.registry.api.model.Dataset;
import org.gbif.registry.api.model.Organization;
import org.gbif.registry.api.service.DatasetService;
import org.gbif.registry.api.service.OrganizationService;

import java.util.List;
import java.util.UUID;

import javax.validation.Valid;

import com.google.inject.Inject;

public class DatasetAction extends AdminBaseAction<DatasetService, Dataset> {

  @Inject
  OrganizationService organizationWsClient;

  @Valid
  Dataset member;

  /**
   * @return the dataset.
   */
  @Override
  public Dataset getMember() {
    if (member == null) {
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


  public List<Organization> getOrganizations() {
    PagingResponse<Organization> response = organizationWsClient.list(null);

    if (response != null) {
      return response.getResults();
    }
    return null;
  }

  public String editDataset() {
    // TODO: add logic required to edit the dataset fields (calling WS client)
    return SUCCESS;
  }

  public String addDataset() {
    // first persist the WritableDataset entity
    UUID dataseKey = wsClient.create(member);
    createMembers(dataseKey);
    return SUCCESS;
  }

  @Override
  public Dataset getSessionDataset() {
    return (Dataset) session.get("dataset");
  }
}
