package org.gbif.portal.action.dataset;

import org.gbif.api.paging.PagingResponse;
import org.gbif.portal.action.AdminBaseAction;
import org.gbif.registry.api.model.Dataset;
import org.gbif.registry.api.model.Organization;
import org.gbif.registry.api.service.DatasetService;
import org.gbif.registry.api.service.OrganizationService;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import javax.validation.Valid;

import com.google.inject.Inject;

public class AdminAction extends AdminBaseAction<DatasetService, Dataset> {

  @Inject
  OrganizationService organizationWsClient;

  @Valid
  Dataset member;

  /**
   * @return the dataset.
   */
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
    Organization o1 = Organization.builder().title("Organization 1").key(UUID.randomUUID()).build();
    Organization o2 = Organization.builder().title("Organization 2").key(UUID.randomUUID()).build();
    Organization o3 = Organization.builder().title("Organization 3").key(UUID.randomUUID()).build();
    List<Organization> orgs = new ArrayList<Organization>();
    orgs.add(o1);
    orgs.add(o2);
    orgs.add(o3);
    PagingResponse<Organization> response = new PagingResponse<Organization>();
    response.setResults(orgs);
    // PagingResponse<Organization> response = organizationWsClient.list(null);

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
  public Dataset getSessionDataset() {
    return (Dataset) session.get("dataset");
  }

  @Override
  public Dataset getEntity() {
    return getMember();
  }
}
