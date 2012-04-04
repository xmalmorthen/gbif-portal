package org.gbif.portal.action.admin;

import org.gbif.api.model.vocabulary.Country;
import org.gbif.api.paging.PagingResponse;
import org.gbif.portal.action.organization.OrganizationBaseAction;
import org.gbif.registry.api.model.Node;
import org.gbif.registry.api.model.vocabulary.ContactType;
import org.gbif.registry.api.service.NodeService;

import java.util.List;

import com.google.inject.Inject;

public class OrganizationAction extends OrganizationBaseAction {

  @Inject
  NodeService nodeService;

  /**
   * @return the officialCountries.
   */
  public List<Country> getOfficialCountries() {
    return Country.OFFICIAL_COUNTRIES;
  }

  public List<ContactType> getContactTypes() {
    return ContactType.TYPES;
  }

  public List<Node> getNodes() {
    PagingResponse<Node> response = nodeService.list(null);
    if (response != null) {
      return response.getResults();
    }
    return null;
  }

  public String addOrganization() {
    return SUCCESS;
  }
}
