/*
 * Copyright 2011 Global Biodiversity Information Facility (GBIF) Licensed under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at
 * http://www.apache.org/licenses/LICENSE-2.0 Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,
 * either express or implied. See the License for the specific language governing permissions and limitations under the
 * License.
 */
package org.gbif.portal.action.species;

import org.gbif.api.search.facets.Facet;
import org.gbif.api.search.model.SearchRequest;
import org.gbif.api.search.model.SearchResponse;
import org.gbif.checklistbank.api.model.NameUsage;
import org.gbif.checklistbank.api.model.search.ChecklistBankFacetParameter;
import org.gbif.checklistbank.api.service.NameUsageSearchService;
import org.gbif.portal.action.BaseSearchAction;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.google.inject.Inject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import static org.gbif.api.search.model.SearchConstants.HTTP_DEFAULT_SEARCH_PARAM;

/**
 * The action for all species search operations.
 */
public class SearchAction extends BaseSearchAction<NameUsage> {

  private static final Logger LOG = LoggerFactory.getLogger(SearchAction.class);

  private Map<String, String[]> facets;

  private Map<String, List<Facet.Count>> facetCounts;

  @Inject
  private NameUsageSearchService nameUsageSearchService;

  public SearchAction() {
    super();
    this.facetCounts = new HashMap<String, List<Facet.Count>>();
  }

  private void addFacetParameters(ChecklistBankFacetParameter facetEnum, SearchRequest request) {
    if (this.facets != null) {
      String[] values = facets.get(facetEnum.name());
      if (values != null) {
        for (String facetValue : values) {
          request.addFacetedParameter(facetEnum, facetValue);
        }
      }
    }
  }

  @Override
  public String execute() {
    LOG.info("Species search of [{}]", this.getQ());
    SearchRequest request = new SearchRequest(this.getSearchRequest().getOffset(), this.getSearchRequest().getLimit());
    request.addFacets(ChecklistBankFacetParameter.CHECKLIST);
    this.addFacetParameters(ChecklistBankFacetParameter.CHECKLIST, request);
    request.addFacets(ChecklistBankFacetParameter.RANK);
    this.addFacetParameters(ChecklistBankFacetParameter.RANK, request);
    // default query parameter
    request.addParameter(HTTP_DEFAULT_SEARCH_PARAM, this.getQ());
    SearchResponse<NameUsage> results = nameUsageSearchService.search(request);
    this.setSearchResponse(results);
    this.initializeFacets(results);
    LOG.info("Species search of [{}] returned {} results", this.getQ(), this.getSearchResponse().getCount());
    return SUCCESS;
  }


  /**
   * @return the facetCounts
   */
  public Map<String, List<Facet.Count>> getFacetCounts() {
    return facetCounts;
  }

  /**
   * @return the facets
   */
  public Map<String, String[]> getFacets() {
    return facets;
  }


  private void initializeFacets(SearchResponse<NameUsage> results) {
    if (results.getFacets() != null && !results.getFacets().isEmpty()) {
      for (Facet facet : results.getFacets()) {
        if (facet.getCounts() != null) {
          this.facetCounts.put(facet.getField(), facet.getCounts());
        }
      }
    }
  }

  /**
   * @param facetCounts the facetCounts to set
   */
  public void setFacetCounts(Map<String, List<Facet.Count>> facetCounts) {
    this.facetCounts = facetCounts;
  }


  /**
   * @param facets the facets to set
   */
  public void setFacets(Map<String, String[]> facets) {
    this.facets = facets;
  }


}
