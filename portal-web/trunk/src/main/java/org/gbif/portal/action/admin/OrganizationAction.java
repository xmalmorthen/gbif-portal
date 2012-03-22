package org.gbif.portal.action.admin;

import org.gbif.api.model.vocabulary.Country;
import org.gbif.portal.action.organization.OrganizationBaseAction;
import org.gbif.registry.api.model.vocabulary.ContactType;

import java.util.List;

public class OrganizationAction extends OrganizationBaseAction {

  /**
   * @return the officialCountries.
   */
  public List<Country> getOfficialCountries() {
    return Country.OFFICIAL_COUNTRIES;
  }

  public List<ContactType> getContactTypes() {
    return ContactType.TYPES;
  }
}
