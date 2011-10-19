/*
 * Copyright 2011 Global Biodiversity Information Facility (GBIF) Licensed under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at
 * http://www.apache.org/licenses/LICENSE-2.0 Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,
 * either express or implied. See the License for the specific language governing permissions and limitations under the
 * License.
 */
package org.gbif.portal.action.dataset;

import org.gbif.checklistbank.api.service.ChecklistService;
import org.gbif.portal.action.BaseAction;

import java.util.UUID;

import com.google.inject.Inject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class DetailAction extends BaseAction {

  private static final Logger LOG = LoggerFactory.getLogger(DetailAction.class);

  // detail
  private String id;
  private Object dataset;

  @Inject
  private ChecklistService checklistService;

  @Override
  public String execute() {
    LOG.debug("Fetching detail for dataset id [{}]", id);
    /** TODO: re-enable real lookup, render based on dataset type */
    // just for testing each of the 3 dataset type views
    if (id == null) {
      return HTTP_NOT_FOUND;
    }
    // TODO: the registry client needs to be invoked first to know which type of Resource we area dealing with. For now
    // the checklist client will be the default one being called. The default view will be the detailed checklist.
    // TODO: check to see if this is valid UUID first
    dataset = checklistService.get(UUID.fromString(id));
    return "detail_checklist";
    // other views --> "detail_external", "detail_occurrence"


    // log.debug("executing action class: " + this.getClass().getName());
    // if (!StringUtils.isBlank(id)) {
    // UUID uuid = null;
    // try {
    // uuid = UUID.fromString(id.trim());
    // dataset = registry.getDataset(uuid);
    // if (dataset != null) {
    // return SUCCESS;
    // }
    // } catch (Exception e) {
    // // swallow
    // }
    // }
    // return NOT_FOUND;
  }

  public Object getDataset() {
    return dataset;
  }

  public void setId(String id) {
    this.id = id;
  }

  public String getId() {
    return id;
  }
}
