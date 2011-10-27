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

  private Map<String, String[]> facets = new HashMap<String, String[]>();
  private String[] chk_tile;

  private List<Facet.Count> checkListsFacetCounts;

  @Inject
  private NameUsageSearchService nameUsageSearchService;

  @Override
  public String execute() {
    LOG.info("Species search of [{}]", this.getQ());
    SearchRequest req = new SearchRequest(this.getSearchRequest().getOffset(), this.getSearchRequest().getLimit());
    req.addFacets(ChecklistBankFacetParameter.CHECKLIST);
    if (chk_tile != null) {
      LOG.info("Checklist facet: {}", chk_tile.length);
      for (String chkFacet : chk_tile) {
        req.addFacetedParameter(ChecklistBankFacetParameter.CHECKLIST, chkFacet);
      }
    }
    // default query parameter
    req.addParameter(HTTP_DEFAULT_SEARCH_PARAM, this.getQ());
    SearchResponse<NameUsage> results = nameUsageSearchService.search(req);
    this.setSearchResponse(results);
    this.initializeFacets(results);
    LOG.info("Species search of [{}] returned {} results", this.getQ(), this.getSearchResponse().getCount());
    return SUCCESS;
  }

  /**
   * Return the counts for facet chk_tile
   */
  public List<Facet.Count> getCheckListsFacetCounts() {
    return checkListsFacetCounts;
  }

  public String[] getChk_tile() {
    return chk_tile;
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
        if (facet.getField().equals("chk_tile")) {
          this.checkListsFacetCounts = facet.getCounts();
        }
      }
    }
  }


  public void setChk_tile(String[] chk_tile) {
    this.chk_tile = chk_tile;
  }


  /**
   * @param facets the facets to set
   */
  public void setFacets(Map<String, String[]> facets) {
    this.facets = facets;
  }
}
