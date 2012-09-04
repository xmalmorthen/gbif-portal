/*
 * Copyright 2011 Global Biodiversity Information Facility (GBIF) Licensed under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at
 * http://www.apache.org/licenses/LICENSE-2.0 Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,
 * either express or implied. See the License for the specific language governing permissions and limitations under the
 * License.
 */
package org.gbif.portal.action.dataset;

import org.gbif.registry.api.model.Contact;
import org.gbif.registry.api.model.Organization;
import org.gbif.registry.api.model.TechnicalInstallation;
import org.gbif.registry.api.service.TechnicalInstallationService;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.google.inject.Inject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class DetailAction extends DatasetBaseAction {

  private static final Logger LOG = LoggerFactory.getLogger(DetailAction.class);

  private Organization hostingOrganization;
  private List<Contact> preferredContacts;
  private List<Contact> otherContacts;

  @Inject
  private TechnicalInstallationService technicalInstallationService;

  @Override
  public String execute() {
    loadDetail();

    // are there preferred (primary) contacts
    separateContacts(dataset.getContacts());

    if (dataset.getTechnicalInstallationKey() != null) {
      TechnicalInstallation technicalInstallation = technicalInstallationService.get(dataset.getTechnicalInstallationKey());
      if (technicalInstallation.getHostingOrganizationKey().equals(dataset.getOwningOrganizationKey())) {
        hostingOrganization = getOwningOrganization();
      } else {
        hostingOrganization = organizationService.get(technicalInstallation.getHostingOrganizationKey());
      }
    }
    return SUCCESS;
  }

  public List<Contact> getOtherContacts() {
    return otherContacts;
  }

  public List<Contact> getPreferredContacts() {
    return preferredContacts;
  }

  /**
   * @return the hostingOrganization
   */
  protected Organization getHostingOrganization() {
    return hostingOrganization;
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

}
