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
import org.gbif.portal.model.FacetInstance;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.google.common.base.Function;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.google.common.collect.Multimap;

import static org.gbif.common.search.util.QueryUtils.httpParamsJoiner;
import static org.gbif.common.search.util.SearchConstants.HTTP_AND_OP;

/**
 * Provides the basic structure and functionality for: free text search, paginated navigation and faceting navigation.
 * Besides the inherited functionality from {@link BaseSearchAction} this class provides several features:
 * - Execution of the search request using an instance of {@link SearchService}.
 * - Holds the user selected values of a facet.
 * - Provides the required information for displaying the facet counts.
 * 
 * @param <T> type of the results content
 * @param <F> Enum that contains the valid facets
 * @see BaseSearchAction
 */
public abstract class BaseFacetedSearchAction<T, F extends Enum<F>> extends BaseSearchAction<T> {

  /**
   * Serial version
   */
  private static final long serialVersionUID = -1573017190241712345L;
  private Map<Enum<F>, List<FacetInstance>> facets = new HashMap<Enum<F>, List<FacetInstance>>();
  private HashMap<String, List<FacetInstance>> facetCounts;
  private boolean initDefault = true;

  /**
   * This constant restricts the maximum number of facet results to be displayed
   */
  private static final int MAX_FACETS = 5;

  /**
   * This field is used to hold the class of the enum used for faceting.
   * This instance is used to iterate over the possible literal values of the enumerated type.
   */
  private Class<? extends Enum<F>> facetEnum;

  /**
   * This string is used to keep a pre-built filter query and avoid re-build it every time is need it.
   */
  private String defaultFacetFilterQuery;

  private SearchService<T> searchService;

  /**
   * Default constructor for this class.
   * 
   * @param searchService an instance of search service
   * @param facetEnum the type of the {@link Enum} used for facets
   */
  public BaseFacetedSearchAction(SearchService<T> searchService, Class<? extends Enum<F>> facetEnum) {
    this.searchService = searchService;
    this.facetCounts = new HashMap<String, List<FacetInstance>>();
    this.facetEnum = facetEnum;
    this.defaultFacetFilterQuery = this.buildDefaultFacetsFiltersQuery();
  }

  /**
   * Adds the selected facets as faceted parameters to the SearchRequest input parameter.
   */
  private void addFacetParameters() {
    // parse plain http request to populate facets
    readFacetsFromRequest();

    // add all facets to request which are not in filters yet
    for (Enum<F> fEnum : facetEnum.getEnumConstants()) {
      searchRequest.addFacets(fEnum);
    }

    // add facet filters
    for (Enum<F> facet : facets.keySet()) {
      List<FacetInstance> values = facets.get(facet);
      if (values != null) {
        for (FacetInstance facetValue : values) {
          searchRequest.addFacetedParameter(facet, facetValue.getName());
        }
      }
    }
  }

  /**
   * Creates a query string that contains the default facet filter parameters.
   * The resulting string will have the form: facetParam1=value1&facetParam2=value2.
   * 
   * @return a string containing the list of default facet filter parameters.
   */
  private String buildDefaultFacetsFiltersQuery() {
    List<String> paramsList = new ArrayList<String>();
    for (Enum<F> facet : this.getDefaultFacetsFilters().keySet()) {
      for (FacetInstance facetInstance : this.getDefaultFacetsFilters().get(facet)) {
        paramsList.add(facet.name().toLowerCase() + "=" + facetInstance.getName());
      }
    }
    String queryString = "";
    if (!paramsList.isEmpty()) {
      paramsList.add("initDefault=false");
      queryString = httpParamsJoiner.join(paramsList);
      queryString = HTTP_AND_OP + queryString;
    }
    return queryString;
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
    LOG.info("Search for [{}]", this.getQ());
    // Request creation
    addFacetParameters();
    // default query parameters
    searchRequest.setQ(this.getQ());
    // adds parameters processed by subclasses
    searchRequest.addParameter(this.getRequestParameters());
    // adds the language
    searchRequest.setLanguage(this.getLocale().getLanguage());
    // issues the search operation
    searchResponse = searchService.search(searchRequest);
    // initializes the elements required by the UI
    initializeFacetCounts(searchResponse);

    LOG.info("Search for [{}] returned {} results", this.getQ(), searchResponse.getCount());
    return SUCCESS;
  }

  /**
   * Gets the instance of the current object.
   * This helps to expose public methods to the web templates.
   * 
   * @return
   */
  public BaseAction getAction() {
    return this;
  }

  /**
   * This method should return a map containing the default filter parameters for the first time that the page is
   * loaded
   * 
   * @return a map containing default values for facets filters
   */
  public abstract Map<Enum<F>, List<FacetInstance>> getDefaultFacetsFilters();

  /**
   * Returns the default facet filters query section.
   * If initDefault==true returns the value of variable "defaultFacetFilterQuery".
   * If initDefault==false returns an empty string.
   * 
   * @return the default facet filter query
   */
  public String getDefaultFacetsFiltersQuery() {
    if (this.initDefault) {
      return this.defaultFacetFilterQuery;
    }
    return "";
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
  public Map<String, List<FacetInstance>> getFacetCounts() {
    return facetCounts;
  }

  /**
   * Returns the Enum literal that has the name "facetName"
   * 
   * @param facetName the name of the facet.
   * @return an Enum<F> instance, null if the facetName is not found.
   */
  private Enum<F> getFacetFromString(String facetName) {
    Enum<F> facet = null;
    for (Enum<F> fEnum : this.getFacets().keySet()) {
      if (fEnum.name().equalsIgnoreCase(facetName)) {
        facet = fEnum;
      }
    }
    return facet;
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
  public Map<Enum<F>, List<FacetInstance>> getFacets() {
    return facets;
  }


  public int getMaxFacets() {
    return MAX_FACETS;
  }

  /**
   * Analyzed the request to determine if parameters should be added from the request parameters.
   * 
   * @return a {@link Multimap} containing the parameters
   */
  public abstract Multimap<String, String> getRequestParameters();

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
          this.facetCounts.put(facet.getField(), toFacetInstance(facet.getCounts()));
        }
      }
    }
  }

  /**
   * Checks if a facet value is already selected in the current selected filters.
   * 
   * @param facetName the facet name according to
   * @param facetKey
   * @return
   */
  public boolean isInFilter(String facetName, String facetKey) {
    Enum<F> facet = this.getFacetFromString(facetName);
    if (facet != null && this.getFacets().containsKey(facet)) {
      for (FacetInstance facetInstance : this.getFacets().get(facet)) {
        if (facetInstance.getName().equals(facetKey)) {
          return true;
        }
      }
    }
    return false;
  }

  /**
   * @return the initDefault
   */
  public boolean isInitDefault() {
    return initDefault;
  }

  /**
   * Utility function that sets facet titles.
   * The function uses a function parameter to accomplish this task.
   * The getTitleFunction could provide the actual communication with the service later to provide the required title.
   * 
   * @param facet the facet
   * @param getTitleFunction function that returns title using a facet name
   */
  protected void lookupFacetTitles(Enum<F> facet, Function<String, String> getTitleFunction) {
    // "cache"
    Map<String, String> names = Maps.newHashMap();

    // filters
    if (getFacets().containsKey(facet)) {
      for (FacetInstance fi : getFacets().get(facet)) {
        if (names.containsKey(fi.getName())) {
          fi.setTitle(names.get(fi.getName()));
        } else {

          try {
            fi.setTitle(getTitleFunction.apply(fi.getName()));
            names.put(fi.getName(), fi.getTitle());
          } catch (Exception e) {
            LOG.warn("Cannot lookup {} title for {}", new Object[] {facet.name(), fi.getName(), e});
          }
        }
      }
    }

    // facet counts
    if (getFacetCounts().containsKey(facet.name())) {
      for (int idx = 0; idx < getFacetCounts().get(facet.name()).size(); idx++) {
        FacetInstance c = getFacetCounts().get(facet.name()).get(idx);
        if (names.containsKey(c.getName())) {
          c.setTitle(names.get(c.getName()));
        } else {
          try {
            c.setTitle(getTitleFunction.apply(c.getName()));
            names.put(c.getName(), c.getTitle());
          } catch (Exception e) {
            LOG.warn("Cannot lookup {} title for {}", new Object[] {facet.name(), c.getName(), e});
          }
        }
      }
    }
  }

  /**
   * read facets from request to avoid fixed setter names.
   * Make sure that empty parameters are set too to filter null values!
   */
  private void readFacetsFromRequest() {
    @SuppressWarnings("unchecked")
    Map<String, String[]> params = request.getParameterMap();
    for (Enum<F> fEnum : facetEnum.getEnumConstants()) {
      // recognize facets by enum name
      String pname = fEnum.name().toLowerCase();
      if (params.containsKey(pname)) {
        // facet filter found
        List<FacetInstance> values = Lists.newArrayList();
        for (String v : params.get(pname)) {
          values.add(new FacetInstance(v));
        }
        this.facets.put(fEnum, values);
      }
    }
    if (this.initDefault) {
      this.facets.putAll(this.getDefaultFacetsFilters());
    }
  }

  /**
   * Flag that indicates if the default filter parameters should be initialized
   * 
   * @param initDefault the initDefault to set
   */
  public void setInitDefault(boolean initDefault) {
    this.initDefault = initDefault;
  }


  private List<FacetInstance> toFacetInstance(List<Facet.Count> counts) {
    List<FacetInstance> instances = Lists.newArrayList();
    for (Facet.Count c : counts) {
      // only show counts with at least 1 matching record
      if (c.getCount() > 0) {
        instances.add(new FacetInstance(c));
      }
    }
    return instances;
  }
}
