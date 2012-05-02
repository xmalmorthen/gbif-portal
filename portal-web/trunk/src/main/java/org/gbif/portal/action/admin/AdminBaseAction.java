package org.gbif.portal.action.admin;

import org.gbif.api.model.vocabulary.Country;
import org.gbif.api.model.vocabulary.IdentifierType;
import org.gbif.api.model.vocabulary.Language;
import org.gbif.portal.action.BaseAction;
import org.gbif.registry.api.model.Contact;
import org.gbif.registry.api.model.Dataset;
import org.gbif.registry.api.model.Endpoint;
import org.gbif.registry.api.model.Identifier;
import org.gbif.registry.api.model.NetworkEntityComponents;
import org.gbif.registry.api.model.Tag;
import org.gbif.registry.api.model.vocabulary.ContactType;
import org.gbif.registry.api.model.vocabulary.EndpointType;
import org.gbif.registry.api.service.NetworkEntityService;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;
import java.util.UUID;

import javax.validation.Valid;

import com.google.inject.Inject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public abstract class AdminBaseAction<T extends NetworkEntityService, K extends NetworkEntityComponents> extends
  BaseAction {

  protected static final Logger LOG = LoggerFactory.getLogger(AdminBaseAction.class);


  protected UUID id;
  protected int componentIndex;

  @Valid
  Contact contact;

  @Valid
  Endpoint endpoint;

  @Valid
  Tag tag;

  @Valid
  Identifier identifier;

  @Inject
  protected T wsClient;

  public abstract K getEntity();

  public String prepare() {

    NetworkEntityComponents entity = getEntity();

    if (entity != null && entity.getContacts() != null) {
      session.put("contacts", entity.getContacts());
    } else {
      session.put("contacts", new ArrayList<Contact>());
    }
    if (getEndpoints() == null) {
      session.put("endpoints", new ArrayList<Endpoint>());
    }
    if (entity != null && entity.getContacts() != null) {
      session.put("tags", entity.getTags());
    } else {
      session.put("tags", new ArrayList<Tag>());
    }
    if (getIdentifiers() == null) {
      session.put("identifiers", new ArrayList<Identifier>());
    }
    contact = new Contact();
    endpoint = new Endpoint();
    tag = new Tag();
    identifier = new Identifier();
    return SUCCESS;
  }

  protected void createMembers(UUID memberKey) {
    // add contacts
    if (getContacts() != null) {
      for (Contact contact : getContacts()) {
        LOG.debug("WS add contact to entity with UUID: [{}]", memberKey);
        wsClient.add(memberKey, contact);
      }
    }

    // add endpoints
    if (getEndpoints() != null) {
      for (Endpoint endpoint : getEndpoints()) {
        wsClient.add(memberKey, endpoint);
      }
    }

    // add tags
    if (getTags() != null) {
      for (Tag tag : getTags()) {
        wsClient.add(memberKey, tag);
      }
    }

    // add identifiers
    if (getIdentifiers() != null) {
      for (Identifier identifier : getIdentifiers()) {
        wsClient.add(memberKey, identifier);
      }
    }
  }

  public String addcontact() {
    LOG.debug("Adding new contact");
    getContacts().add(contact);
    return SUCCESS;
  }

  public String addendpoint() {
    LOG.debug("Adding new endpoint");
    getEndpoints().add(endpoint);
    return SUCCESS;
  }

  public String addtag() {
    LOG.debug("Adding new tag");
    getTags().add(tag);
    return SUCCESS;
  }

  public String addidentifier() {
    LOG.debug("Adding new identifier");
    getIdentifiers().add(identifier);
    return SUCCESS;
  }

  public Dataset getSessionDataset() {
    return (Dataset) session.get("dataset");
  }

  public List<Contact> getContacts() {
    return (List<Contact>) session.get("contacts");
  }

  public List<Endpoint> getEndpoints() {
    return (List<Endpoint>) session.get("endpoints");
  }

  public List<Tag> getTags() {
    return (List<Tag>) session.get("tags");
  }

  public List<Identifier> getIdentifiers() {
    return (List<Identifier>) session.get("identifiers");
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

  /**
   * Return a map of endpoint types. <key> is the enum name and <value> is the i18n name.
   * 
   * @return
   */
  public Map<String, String> getEndpointTypes() {
    Map<String, String> endpointTypes = new HashMap<String, String>();
    for (EndpointType endpointType : EndpointType.TYPES) {
      endpointTypes.put(endpointType.name(), getText("enum.endpointtype." + endpointType));
    }
    return endpointTypes;
  }

  /**
   * Return a map of identifier types. <key> is the enum name and <value> is the i18n name.
   * 
   * @return
   */
  public Map<String, String> getIdentifierTypes() {
    Map<String, String> identifierTypes = new HashMap<String, String>();
    for (IdentifierType identifierType : IdentifierType.TYPES) {
      identifierTypes.put(identifierType.name(), getText("enum.identifiertype." + identifierType));
    }
    return identifierTypes;
  }

  /**
   * @return the officialCountries.
   */
  public List<Country> getOfficialCountries() {
    return Country.OFFICIAL_COUNTRIES;
  }

  public Map<String, String> getLanguages() {
    Map<String, String> languages = new TreeMap<String, String>();
    for (Language language : Language.LANGUAGES) {
      // TODO: internationalize language names?
      languages.put(language.name(), language.name());
    }
    return languages;
  }

  public String deletetag() {
    LOG.debug("Deleting a tag");
    List<Tag> tags = new ArrayList<Tag>();
    int currentIndex = 0;
    for (Tag currentTag : getTags()) {
      if (currentIndex++ == getComponentIndex()) {
        continue;
      }
      tags.add(currentTag);
    }
    session.put("tags", tags);
    return SUCCESS;
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
   * @return the tag.
   */
  public Tag getTag() {
    return tag;
  }


  /**
   * @param tag the tag to set.
   */
  public void setTag(Tag tag) {
    this.tag = tag;
  }


  /**
   * @return the identifier.
   */
  public Identifier getIdentifier() {
    return identifier;
  }


  /**
   * @param identifier the identifier to set.
   */
  public void setIdentifier(Identifier identifier) {
    this.identifier = identifier;
  }


  /**
   * @return the id.
   */
  public UUID getId() {
    return id;
  }


  /**
   * @param id the id to set.
   */
  public void setId(UUID id) {
    this.id = id;
  }


  /**
   * @return the componentIndex.
   */
  public int getComponentIndex() {
    return componentIndex;
  }


  /**
   * @param componentIndex the componentIndex to set.
   */
  public void setComponentIndex(int componentIndex) {
    this.componentIndex = componentIndex;
  }

}
