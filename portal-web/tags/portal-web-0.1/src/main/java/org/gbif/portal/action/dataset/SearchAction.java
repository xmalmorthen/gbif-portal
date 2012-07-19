/*
 * Copyright 2011 Global Biodiversity Information Facility (GBIF) Licensed under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at
 * http://www.apache.org/licenses/LICENSE-2.0 Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,
 * either express or implied. See the License for the specific language governing permissions and limitations under the
 * License.
 */
package org.gbif.portal.action.dataset;

import org.gbif.portal.action.BaseFacetedSearchAction;
import org.gbif.registry.api.model.search.DatasetFacetParameter;
import org.gbif.registry.api.model.search.DatasetSearchResult;
import org.gbif.registry.api.service.DatasetSearchService;
import org.gbif.registry.api.service.OrganizationService;

import java.util.UUID;

import com.google.common.base.Function;
import com.google.common.base.Strings;
import com.google.common.collect.HashMultimap;
import com.google.common.collect.Multimap;
import com.google.inject.Inject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class SearchAction extends BaseFacetedSearchAction<DatasetSearchResult, DatasetFacetParameter> {

  private static final Logger LOG = LoggerFactory.getLogger(SearchAction.class);
  private static final long serialVersionUID = 1488419402277401976L;

  private OrganizationService orgService;
  private Function<String, String> getOrgTitle;

  @Inject
  public SearchAction(DatasetSearchService<DatasetSearchResult> datasetSearchService, OrganizationService orgService) {
    super(datasetSearchService, DatasetFacetParameter.class);
    this.orgService = orgService;
    initGetTitleFunctions();
  }

  /**
   * Initializes the getTitle functions
   */
  private void initGetTitleFunctions() {
    getOrgTitle = new Function<String, String>() {

      @Override
      public String apply(String key) {
        if (Strings.emptyToNull(key) != null) {
          try {
            return orgService.get(UUID.fromString(key)).getTitle();
          } catch (Exception e) {
          }
        }
        return null;
      }
    };
  }

  @Override
  public String execute() {
    searchRequest.setMultiSelectFacets(true);
    // Turn off highlighting for empty query strings
    searchRequest.setHighlight(!getQ().isEmpty());

    super.execute();

    // replace organisation keys with real names
    lookupFacetTitles(DatasetFacetParameter.HOSTING_ORG, getOrgTitle);
    lookupFacetTitles(DatasetFacetParameter.OWNING_ORG, getOrgTitle);

    return SUCCESS;
  }

  @Override
  public Multimap<String, String> getRequestParameters() {
    return HashMultimap.create();
  }
}
