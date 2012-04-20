package org.gbif.portal.action.admin;

import org.gbif.api.model.vocabulary.Country;
import org.gbif.api.paging.PagingResponse;
import org.gbif.portal.action.organization.OrganizationBaseAction;
import org.gbif.registry.api.model.Contact;
import org.gbif.registry.api.model.Endpoint;
import org.gbif.registry.api.model.Identifier;
import org.gbif.registry.api.model.Node;
import org.gbif.registry.api.model.Organization;
import org.gbif.registry.api.model.Tag;
import org.gbif.registry.api.model.vocabulary.ContactType;
import org.gbif.registry.api.service.NodeService;
import org.gbif.registry.api.service.OrganizationService;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.validation.Valid;

import com.google.inject.Inject;

public class OrganizationAction extends OrganizationBaseAction {

  @Inject
  NodeService nodeService;

  @Valid
  Organization organization;

  @Valid
  Contact contact;

  @Valid
  Endpoint endpoint;

  @Valid
  Tag tag;

  @Valid
  Identifier identifier;

  @Inject
  OrganizationService wsClient;

  /**
   * @return the organization.
   */
  public Organization getOrganization() {
    if (organization == null) {
      organization = loadMember(id);
    }
    return organization;
  }

  /**
   * @param organization the organization to set.
   */
  public void setOrganization(Organization organization) {
    this.organization = organization;
  }


  /**
   * @return the endpoint.
   */
  public Endpoint getEndpoint() {
    return endpoint;
  }


  /**
   * @param endpoint the endpoint to set.
   */
  public void setEndpoint(Endpoint endpoint) {
    this.endpoint = endpoint;
  }

  /**
   * @return the contact.
   */
  public Contact getContact() {
    return contact;
  }

  /**
   * @param contact the contact to set.
   */
  public void setContact(Contact contact) {
    this.contact = contact;
  }

  /**
   * @return the officialCountries.
   */
  public List<Country> getOfficialCountries() {
    return Country.OFFICIAL_COUNTRIES;
  }

  /**
   * Return a map of contact types. <key> is the enum name and <value> is the i18n name.
   * 
   * @return
   */
  public Map<String, String> getContactTypes() {
    Map<String, String> contactTypes = new HashMap<String, String>();
    for (ContactType contactType : ContactType.TYPES) {
      contactTypes.put(contactType.name(), getText("enum.contacttype." + contactType));
    }
    return contactTypes;
  }

  public List<Node> getNodes() {
    PagingResponse<Node> response = nodeService.list(null);

    if (response != null) {
      return response.getResults();
    }
    return null;
  }

  public String prepare() {
    if (getSessionOrganization() == null) {
      session.put("organization", new Organization());
    }
    if (getSessionContacts() == null) {
      session.put("contacts", new ArrayList<Contact>());
    }
    contact = new Contact();
    return SUCCESS;
  }

  public String editOrganization() {
    // TODO: add logic required to edit the organization fields (calling WS client)
    return SUCCESS;
  }

  public String addOrganization() {
    // first persist the WritableOrganization entity
    UUID organisationKey = wsClient.create(organization);

    // add contacts
    if (getSessionContacts() != null) {
      for (Contact contact : getSessionContacts()) {
        LOG.debug("WS add contact to entity with UUID: [{}]", organisationKey);
        wsClient.add(organisationKey, contact);
      }
    }

    // add endpoints
    if (getSessionEndpoints() != null) {
      for (Endpoint endpoint : getSessionEndpoints()) {
        wsClient.add(organisationKey, endpoint);
      }
    }

    // add tags
    if (getSessionTags() != null) {
      for (Tag tag : getSessionTags()) {
        wsClient.add(organisationKey, tag);
      }
    }

    // add identifiers
    if (getSessionIdentifiers() != null) {
      for (Identifier identifier : getSessionIdentifiers()) {
        wsClient.add(organisationKey, identifier);
      }
    }
    return SUCCESS;
  }

  public String addcontact() {
    LOG.debug("Adding new contact");
    getSessionContacts().add(contact);
    return SUCCESS;
  }

  public String addEndpoints() {
    getSessionEndpoints().add(endpoint);
    return SUCCESS;
  }

  public String addTags() {
    getSessionTags().add(tag);
    return SUCCESS;
  }

  public String addIdentifiers() {
    getSessionIdentifiers().add(identifier);
    return SUCCESS;
  }

  public Organization getSessionOrganization() {
    return (Organization) session.get("organization");
  }

  public List<Contact> getSessionContacts() {
    return (List<Contact>) session.get("contacts");
  }

  public List<Endpoint> getSessionEndpoints() {
    return (List<Endpoint>) session.get("endpoints");
  }

  public List<Tag> getSessionTags() {
    return (List<Tag>) session.get("tags");
  }

  public List<Identifier> getSessionIdentifiers() {
    return (List<Identifier>) session.get("identifiers");
  }
}
