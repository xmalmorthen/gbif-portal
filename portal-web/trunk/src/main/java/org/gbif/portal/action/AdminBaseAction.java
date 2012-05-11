package org.gbif.portal.action;

import org.gbif.api.model.vocabulary.Country;
import org.gbif.api.model.vocabulary.IdentifierType;
import org.gbif.api.model.vocabulary.Language;
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

import com.google.common.collect.Lists;
import com.google.inject.Inject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public abstract class AdminBaseAction<T extends NetworkEntityService, K extends NetworkEntityComponents> extends
  BaseAction {

  protected static final Logger LOG = LoggerFactory.getLogger(AdminBaseAction.class);


  protected UUID id;
  protected int componentIndex;
  protected String component;

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

  public String prepareAddComponent() {

    NetworkEntityComponents entity = getEntity();

    // admin is editing metadata or components of an existing entity
    if (entity != null) {
      session.put("contacts", entity.getContacts());
      session.put("endpoints", entity.getEndpoints());
      session.put("tags", entity.getTags());
      session.put("identifiers", entity.getIdentifiers());
    }
    // admin is creating a new entity along with all its components
    else {
      if (session.get("contacts") == null) {
        session.put("contacts", Lists.newArrayList());
      }
      if (session.get("endpoints") == null) {
        session.put("endpoints", Lists.newArrayList());
      }
      if (session.get("tags") == null) {
        session.put("tags", Lists.newArrayList());
      }
      if (session.get("identifiers") == null) {
        session.put("identifiers", Lists.newArrayList());
      }
    }

    contact = new Contact();
    endpoint = new Endpoint();
    tag = new Tag();
    identifier = new Identifier();

    return SUCCESS;
  }

  public String prepareAddEntity() {

    NetworkEntityComponents entity = getEntity();

    // admin is editing metadata or components of an existing entity
    if (entity != null) {
      session.put("contacts", entity.getContacts());
      session.put("endpoints", entity.getEndpoints());
      session.put("tags", entity.getTags());
      session.put("identifiers", entity.getIdentifiers());
    }
    // admin is creating a new entity along with all its components
    else {
      session.put("contacts", Lists.newArrayList());
      session.put("endpoints", Lists.newArrayList());
      session.put("tags", Lists.newArrayList());
      session.put("identifiers", Lists.newArrayList());
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
    if (id != null) {
      wsClient.add(id, tag);
      // get the entity's tags
      session.put("tags", getEntity().getTags());
    } else {
      // entity does not exists yet, add the tag to the session
      // user is possibly creating a new organization in the same step
      getTags().add(tag);
    }
    return SUCCESS;
  }

  public String deletetag() {
    // TODO: use the prepareable interceptor if possible
    prepareAddComponent();
    List<Tag> tags = new ArrayList<Tag>();
    Tag tagToDelete = null;
    int currentIndex = 0;
    for (Tag currentTag : getTags()) {
      if (currentIndex++ == getComponentIndex()) {
        tagToDelete = currentTag;
        continue;
      }
      tags.add(currentTag);
    }
    // tag should be deleted from the entity as well
    if (id != null) {
      LOG.debug("Deleting a tag");
      wsClient.delete(id, tagToDelete);
    }
    session.put("tags", tags);

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


  /**
   * @param component the component to set.
   */
  public void setComponent(String component) {
    this.component = component;
  }
}
