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

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.google.common.collect.Lists;
import com.google.inject.Inject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class DetailAction extends DatasetBaseAction {

  private static final Logger LOG = LoggerFactory.getLogger(DetailAction.class);

  private Organization hostingOrganization;
  private Dataset parentDataset;
  private List<Contact> preferredContacts;
  private List<Contact> otherContacts;
  private List<Endpoint> links = Lists.newArrayList();
  private List<Endpoint> dataLinks = Lists.newArrayList();
  private List<Endpoint> metaLinks = Lists.newArrayList();
  private PagingResponse<Dataset> constituents;

  @Inject
  private TechnicalInstallationService technicalInstallationService;

  @Override
  public String execute() {
    loadDetail();

    // are there preferred (primary) contacts
    separateContacts(dataset.getContacts());

    setLinks();

    if (dataset.getTechnicalInstallationKey() != null) {
      TechnicalInstallation technicalInstallation = technicalInstallationService.get(dataset.getTechnicalInstallationKey());
      if (!technicalInstallation.getHostingOrganizationKey().equals(dataset.getOwningOrganizationKey())) {
        hostingOrganization = organizationService.get(technicalInstallation.getHostingOrganizationKey());
      }
    }
    // load the parentDataset if any
    if (dataset.getParentDatasetKey() != null) {
      parentDataset = datasetService.get(dataset.getParentDatasetKey());
    }
    // try to load first 10 constituent datasets
    if (key != null) {
      constituents = datasetService.listConstituents(key, new PagingRequest(0, 10));
    }

    return SUCCESS;
  }

  /**
   * Takes all endpoints and splits them into data, metadata and other links.
   */
  private void setLinks() {
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

  public List<Contact> getOtherContacts() {
    return otherContacts;
  }

  public List<Contact> getPreferredContacts() {
    return preferredContacts;
  }

  public Dataset getParentDataset() {
    return parentDataset;
  }

  /**
   * @return the hostingOrganization
   */
  public Organization getHostingOrganization() {
    return hostingOrganization;
  }

  public PagingResponse<Dataset> getConstituents() {
    return constituents;
  }

  /**
   * Iterate over the list of dataset contacts. Divide them into two lists:
   * those thare are preferred (primary), and those that are not.
   * 
   * @param contacts list of contacts associated to the dataset
   */
  private void separateContacts(List<Contact> contacts) {
    // instantiate lists
    preferredContacts = new ArrayList<Contact>();
    otherContacts = new ArrayList<Contact>();
    // populate lists
    if (contacts.size() > 0) {
      for (Contact contact : contacts) {
        if (contact.isPreferred()) {
          preferredContacts.add(contact);
        } else {
          otherContacts.add(contact);
        }
      }
    }
  }

  public Map<String, String> getResourceBundleProperties() {
    return getResourceBundleProperties("enum.rank.");
  }

  public List<Endpoint> getLinks() {
    return links;
  }

  public List<Endpoint> getDataLinks() {
    return dataLinks;
  }

  public List<Endpoint> getMetaLinks() {
    return metaLinks;
  }
}
