/*
 * Copyright 2011 Global Biodiversity Information Facility (GBIF) Licensed under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at
 * http://www.apache.org/licenses/LICENSE-2.0 Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,
 * either express or implied. See the License for the specific language governing permissions and limitations under the
 * License.
 */
package org.gbif.portal.action.dataset;

import org.gbif.api.model.common.paging.PagingRequest;
import org.gbif.api.model.common.paging.PagingResponse;
import org.gbif.api.model.registry.Contact;
import org.gbif.api.model.registry.Dataset;
import org.gbif.api.model.registry.Endpoint;
import org.gbif.api.model.registry.Organization;
import org.gbif.api.model.registry.TechnicalInstallation;
import org.gbif.api.service.registry.TechnicalInstallationService;
import org.gbif.api.vocabulary.EndpointType;
import org.gbif.api.vocabulary.Extension;
import org.gbif.api.vocabulary.Kingdom;
import org.gbif.api.vocabulary.Rank;

import java.util.List;
import java.util.Map;

import javax.annotation.Nullable;
import javax.validation.constraints.NotNull;

import com.google.common.base.Preconditions;
import com.google.common.collect.ImmutableList;
import com.google.common.collect.Lists;
import com.google.inject.Inject;

/**
 * Populates the model objects for the dataset detail page.
 */
@SuppressWarnings("serial")
public class DetailAction extends DatasetBaseAction {

  private static final List<Extension> EXTENSIONS = ImmutableList.copyOf(Extension.values());
  private static final List<Kingdom> KINGDOMS = ImmutableList.of(Kingdom.ANIMALIA, Kingdom.ARCHAEA, Kingdom.BACTERIA,
    Kingdom.CHROMISTA,
    Kingdom.FUNGI, Kingdom.PLANTAE, Kingdom.PROTOZOA, Kingdom.VIRUSES, Kingdom.INCERTAE_SEDIS);

  @Nullable
  private Organization hostingOrganization;
  @Nullable
  private Dataset parentDataset;
  private final List<Contact> preferredContacts = Lists.newArrayList();
  private final List<Contact> otherContacts = Lists.newArrayList();
  private final List<Endpoint> links = Lists.newArrayList();
  private final List<Endpoint> dataLinks = Lists.newArrayList();
  private final List<Endpoint> metaLinks = Lists.newArrayList();
  @Nullable
  private PagingResponse<Dataset> constituents;
  @Inject
  private TechnicalInstallationService installationService;

  @Override
  public String execute() {
    loadDetail();
    populateContacts(dataset.getContacts());
    populateLinks(dataset.getEndpoints());
    parentDataset = dataset.getParentDatasetKey() != null ? datasetService.get(dataset.getParentDatasetKey()) : null;
    // only datasets with a key (internal) can have constituents
    if (key != null) {
      constituents = datasetService.listConstituents(key, new PagingRequest(0, 10));
    }

    // populate hosting organization only if it differs from the owning organization
    if (dataset.getTechnicalInstallationKey() != null) {
      TechnicalInstallation installation = installationService.get(dataset.getTechnicalInstallationKey());
      if (!dataset.getOwningOrganizationKey().equals(installation.getHostingOrganizationKey())) {
        hostingOrganization = organizationService.get(installation.getHostingOrganizationKey());
      }
    }
    return SUCCESS;
  }

  /**
   * Will not be null following execute() invocation.
   */
  @Nullable
  public PagingResponse<Dataset> getConstituents() {
    return constituents;
  }

  @NotNull
  public List<Endpoint> getDataLinks() {
    return dataLinks;
  }

  /**
   * Exposed to allow easy access in freemarker.
   */
  public List<Extension> getExtensions() {
    return EXTENSIONS;
  }

  /**
   * @return The hosting Organization only if it differs from the owning organization, otherwise null
   */
  @Nullable
  public Organization getHostingOrganization() {
    return hostingOrganization;
  }

  /**
   * Exposed to allow easy access in freemarker.
   */
  public List<Kingdom> getKingdoms() {
    return KINGDOMS;
  }

  @NotNull
  public List<Endpoint> getLinks() {
    return links;
  }

  @NotNull
  public List<Endpoint> getMetaLinks() {
    return metaLinks;
  }

  @NotNull
  public List<Contact> getOtherContacts() {
    return otherContacts;
  }

  @Nullable
  public Dataset getParentDataset() {
    return parentDataset;
  }

  @NotNull
  public List<Contact> getPreferredContacts() {
    return preferredContacts;
  }

  /**
   * Exposed to allow easy access in freemarker.
   */
  public List<Rank> getRankEnum() {
    return Rank.LINNEAN_RANKS;
  }

  @NotNull
  public Map<String, String> getResourceBundleProperties() {
    return getResourceBundleProperties("enum.rank.");
  }

  /**
   * Populates the preferred and other contact lists from the unified contact list.
   */
  private void populateContacts(@NotNull List<Contact> contacts) {
    Preconditions.checkNotNull(contacts, "Contacts cannot be null - expected empty list for no contacts");
    preferredContacts.clear(); // for safety
    otherContacts.clear();
    for (Contact contact : contacts) {
      if (contact.isPreferred()) {
        preferredContacts.add(contact);
      } else {
        otherContacts.add(contact);
      }
    }
  }

  /**
   * Populates the data, metadata and other links from the unified endpoint list.
   */
  private void populateLinks(@NotNull List<Endpoint> endpoints) {
    Preconditions.checkNotNull(endpoints, "Enpoints cannot be null - expected empty list for no endpoints");
    dataLinks.clear(); // for safety
    metaLinks.clear();
    links.clear();
    for (Endpoint p : dataset.getEndpoints()) {
      if (EndpointType.DATA_CODES.contains(p.getType())) {
        dataLinks.add(p);
      } else if (EndpointType.METADATA_CODES.contains(p.getType())) {
        metaLinks.add(p);
      } else {
        links.add(p);
      }
    }
  }
}
