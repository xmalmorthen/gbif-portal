/*
 * Copyright 2011 Global Biodiversity Information Facility (GBIF) Licensed under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at
 * http://www.apache.org/licenses/LICENSE-2.0 Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,
 * either express or implied. See the License for the specific language governing permissions and limitations under the
 * License.
 */
package org.gbif.portal.action;

import org.gbif.api.search.facets.Facet;
import org.gbif.api.search.model.SearchRequest;
import org.gbif.api.search.model.SearchResponse;
import org.gbif.api.search.service.SearchService;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import static org.gbif.api.search.model.SearchConstants.DEFAULT_SEARCH_PARAM;


/**
 * Provides the basic structure and functionality for: free text search, paginated navigation and faceting navigation.
 * Besides the inherited functionality from {@link BaseSearchAction} this class provides several features:
 * - Execution of the search request using an instance of {@link SearchService}.
 * - Holds the user selected values of a facet.
 * - Provides the required information for displaying the facet counts.
 * 
 * @see BaseSearchAction
 * @param <T> type of the results content
 * @param <F> Enum that contains the valid facets
 */
public abstract class BaseFacetedSearchAction<T, F extends Enum<F>> extends BaseSearchAction<T> {

  /**
   * Serial version
   */
  private static final long serialVersionUID = -1573017190241712345L;

  private static final Logger LOG = LoggerFactory.getLogger(BaseFacetedSearchAction.class);

  private Map<String, String[]> facets;

  private Map<String, List<Facet.Count>> facetCounts;

  /**
   * This constant restricts the maximum number of facet results to be displayed
   */
  public static final int MAX_FACETS = 5;

  /**
   * This field is used to hold the class of the enum used for faceting.
   * This instance is used to iterate over the possible literal values of the enumerated type.
   */
  private Class<? extends Enum<F>> classEnum;

  private SearchService<T> searchService;

  /**
   * Default constructor for this class.
   * 
   * @param searchService an instance of search service
   * @param classEnum the type of the {@link Enum} used for facets
   */
  public BaseFacetedSearchAction(SearchService<T> searchService, Class<? extends Enum<F>> classEnum) {
    this.searchService = searchService;
    this.facetCounts = new HashMap<String, List<Facet.Count>>();
    this.classEnum = classEnum;
  }

  /**
   * Adds the selected facets as faceted parameters to the SearchRequest input parameter.
   * 
   * @param facetEnum Enum literal used to get the selected values of a facet.
   * @param request used to add the faceted parameters.
   */
  private void addFacetParameters(final Enum<F> facetEnum, SearchRequest request) {
    if (this.facets != null) { // there are facet values selected
      String[] values = facets.get(facetEnum.name()); // gets the selected values of facet with name facetEnum.name()
      if (values != null) {
        for (String facetValue : values) {
          request.addFacetedParameter(facetEnum, facetValue);
        }
      }
    }
  }

  /**
   * Adds the requested facets and the selected facet values to the SearchRequest parameter.
   * The class parameter F is used to iterate over all the constants it declares and for each one:
   * - Adds the facet to the request
   * - Adds the faceted filter if there are selected facets values.
   * 
   * @param request that will include the selected facets filter.
   */
  private void addFacetParameters(SearchRequest request) {
    for (Enum<F> enumConstant : classEnum.getEnumConstants()) {
      request.addFacets(enumConstant);
      this.addFacetParameters(enumConstant, request);
    }
  }

  /**
   * Executes the default action behavior.
   * The steps taken on this method are:
   * - Creates a {@link SearchRequest} using the current {@link SearchRequest} instance
   * - Adds the search pattern to the request by invoking this.getQ().
   * - Executes the search operation using the {@link SearchService}.
   * - Stores the response in the {@link SearchResponse} instance.
   * - Initializes the facets to be displayed in the user interface.
   */
  @Override
  public String execute() {
    LOG.info("Search of [{}]", this.getQ());
    // Request creation
    SearchRequest request = new SearchRequest(this.getSearchRequest().getOffset(), this.getSearchRequest().getLimit());
    this.addFacetParameters(request);
    // default query parameter
    request.addParameter(DEFAULT_SEARCH_PARAM, this.getQ());
    // Set constants
    this.request.setAttribute("MAX_FACETS", MAX_FACETS);
    // issues the search operation
    SearchResponse<T> response = searchService.search(request);
    // store the response
    this.setSearchResponse(response);
    // initializes the elements required by the UI
    this.initializeFacetCounts(response);
    LOG.info("Action search of [{}] returned {} results", this.getQ(), response.getCount());
    return SUCCESS;
  }

  /**
   * Holds the facet count information retrieved after each search operation.
   * For accessing this field the user interface should be able to referencing map data types.
   * An example of usage of this field could be:
   * <#list facetCounts['RANK'] as count>
   * <option value="${count.name}">${count.name}-(${count.count})</option>
   * </#list>
   * In the previous example the selected elements of a "select" element will be populated by using the list of
   * counts of the facet 'RANK'.
   * 
   * @return the facetCounts
   */
  public Map<String, List<Facet.Count>> getFacetCounts() {
    return facetCounts;
  }


  /**
   * Holds the list of values selected in the user interface.
   * For accessing this field the user interface should be able to referencing map data types.
   * An example of usage of this field could be:
   * <select id="RANK_FACET" name="facets['RANK']" multiple>
   * In the previous example the selected elements of a "select" element will be stored as an array of String
   * accessible using the key 'RANK'.
   * 
   * @return the facets selected values.
   */
  public Map<String, String[]> getFacets() {
    return facets;
  }

  /**
   * By using the response object, this method initializes the facetCounts field.
   * If the response object contains facets, iterates over the facets for copying the count information into the
   * facetCounts (see {@link Facet.Count}) field.
   * 
   * @param response the response gotten after executing the search operation.
   */
  private void initializeFacetCounts(final SearchResponse<T> response) {
    if (response.getFacets() != null && !response.getFacets().isEmpty()) {// there are facets in the response
      for (Facet facet : response.getFacets()) {
        if (facet.getCounts() != null) {// the facet.Count are stored in the facetCounts field
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
