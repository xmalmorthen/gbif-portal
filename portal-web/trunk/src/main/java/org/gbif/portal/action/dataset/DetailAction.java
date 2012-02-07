/*
 * Copyright 2011 Global Biodiversity Information Facility (GBIF) Licensed under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at
 * http://www.apache.org/licenses/LICENSE-2.0 Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,
 * either express or implied. See the License for the specific language governing permissions and limitations under the
 * License.
 */
package org.gbif.portal.action.dataset;

import org.gbif.checklistbank.api.model.Checklist;
import org.gbif.checklistbank.api.service.ChecklistService;
import org.gbif.portal.action.BaseAction;
import org.gbif.portal.action.NotFoundException;
import org.gbif.registry.api.model.Contact;
import org.gbif.registry.api.model.Dataset;
import org.gbif.registry.api.service.DatasetService;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import com.google.inject.Inject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class DetailAction extends BaseAction {

  private static final Logger LOG = LoggerFactory.getLogger(DetailAction.class);

  // detail
  private String id;
  private Dataset dataset;
  private Checklist checklist;
  private List<Contact> preferredContacts;
  private List<Contact> otherContacts;

  @Inject
  private DatasetService datasetService;
  @Inject
  private ChecklistService checklistService;

  @Override
  public String execute() {
    LOG.debug("Fetching detail for dataset id [{}]", id);
    if (id == null) {
      throw new NotFoundException();
    }

    dataset = datasetService.get(id);
    if (dataset == null) {
      LOG.error("No dataset found with id {}", id);
      throw new NotFoundException();
    }

    // try to load a checklist object if it exists
    try {
      checklist = checklistService.get(UUID.fromString(dataset.getKey()));
    } catch (Exception e) {
      // swallow
    }

    // are there preferred (primary) contacts
    separateContacts(dataset.getContacts());

    return SUCCESS;
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

  public Dataset getDataset() {
    return dataset;
  }

  public void setDataset(Dataset dataset) {
    this.dataset = dataset;
  }

  public void setId(String id) {
    this.id = id;
  }

  public String getId() {
    return id;
  }

  public List<Contact> getPreferredContacts() {
    return preferredContacts;
  }

  public List<Contact> getOtherContacts() {
    return otherContacts;
  }

  public Checklist getChecklist() {
    return checklist;
  }
}
