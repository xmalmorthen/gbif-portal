/*
 * Copyright 2011 Global Biodiversity Information Facility (GBIF) Licensed under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at
 * http://www.apache.org/licenses/LICENSE-2.0 Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,
 * either express or implied. See the License for the specific language governing permissions and limitations under the
 * License.
 */
package org.gbif.portal.action.dataset;

import org.gbif.api.paging.Pageable;
import org.gbif.api.paging.PagingResponse;
import org.gbif.api.search.model.SearchResponse;
import org.gbif.checklistbank.api.model.Checklist;
import org.gbif.checklistbank.api.service.ChecklistService;
import org.gbif.portal.action.BaseSearchAction;

import com.google.inject.Inject;

public class SearchAction extends BaseSearchAction<Checklist> {

  @Inject
  private ChecklistService checklistService;

  @Override
  public String execute() {
    LOG.debug("Searching for datasets matching [{}]", this.getQ());
    // wrap the PagingResponse into a SearchResponse and manually set counts until we use a real Solr Search!
    searchResponse = new SearchResponse<Checklist>( (PagingResponse <Checklist>) checklistService.list((Pageable)searchRequest) );
    //searchResponse.setCount((long)searchResponse.getResults().size());

    LOG.debug("Found [{}] matching datasets", searchResponse.getCount());
    return SUCCESS;
  }

}
