/*
 * Copyright 2011 Global Biodiversity Information Facility (GBIF) Licensed under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at
 * http://www.apache.org/licenses/LICENSE-2.0 Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,
 * either express or implied. See the License for the specific language governing permissions and limitations under the
 * License.
 */
package org.gbif.portal.action.dataset;

import org.gbif.api.paging.PagingResponse;
import org.gbif.checklistbank.api.model.Checklist;
import org.gbif.checklistbank.api.service.ChecklistService;
import org.gbif.portal.action.BaseSearchAction;

import java.util.Collections;
import java.util.Comparator;
import java.util.List;

import com.google.inject.Inject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class SearchAction extends BaseSearchAction<Checklist> {

  /**
   * 
   */
  private static final long serialVersionUID = -5488762514856137948L;

  private static final Logger LOG = LoggerFactory.getLogger(SearchAction.class);

  private List<?> datasets;

  private ChecklistService checklistService;

  @Inject
  public SearchAction(ChecklistService checklistService) {
    this.checklistService = checklistService;
  }

  @Override
  public String execute() {
    LOG.debug("Searching for datasets matching [{}]", this.getQ());
    PagingResponse<Checklist> searchResponse = checklistService.list(getSearchRequest());
    this.setSearchResponse(searchResponse);
    if (searchResponse != null) {
      datasets = searchResponse.getResults();
    }
    LOG.debug("Found [{}] matching datasets", datasets == null ? 0 : datasets.size());

    // TODO: This sort is temporary to just show the list in an ordered fashion
    if (datasets != null) {
      Collections.sort(datasets, new Comparator<Object>() {

        public int compare(Object o1, Object o2) {
          Checklist c1 = (Checklist) o1;
          Checklist c2 = (Checklist) o2;
          if (c1.getName() != null && c2.getName() != null) {
            return c1.getName().compareToIgnoreCase(c2.getName());
          }
          return 0;
        }
      });
    }

    // using static just to make sure all layout is working properly
    if (this.getQ() == null || this.getQ().isEmpty()) {
      this.setQ("NoSearchTerm");
    }

    return SUCCESS;
  }

  /**
   * @return the datasets
   */
  public List<?> getDatasets() {
    return datasets == null ? null : datasets;
  }
}
