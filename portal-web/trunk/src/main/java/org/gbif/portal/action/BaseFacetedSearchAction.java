/*
 * Copyright 2011 Global Biodiversity Information Facility (GBIF) Licensed under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at
 * http://www.apache.org/licenses/LICENSE-2.0 Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,
 * either express or implied. See the License for the specific language governing permissions and limitations under the
 * License.
 */
package org.gbif.portal.action;

import org.gbif.api.model.common.search.Facet;
import org.gbif.api.model.common.search.FacetedSearchRequest;
import org.gbif.api.model.common.search.SearchParameter;
import org.gbif.api.service.common.SearchService;
import org.gbif.portal.model.FacetInstance;

import java.util.Iterator;
import java.util.List;
import java.util.Map;

import com.google.common.base.Function;
import com.google.common.base.Splitter;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;

/**
 * Provides the basic structure and functionality for: free text search, paginated navigation and faceting navigation.
 * Besides the inherited functionality from {@link BaseSearchAction} this class provides several features:
 * - Execution of the search request using an instance of {@link SearchService}.
 * - Holds the user selected values of a facet.
 * - Provides the required information for displaying the facet counts.
 * 
 * @param <T> type of the results content
 * @param <P> the search parameter enum
 * @param <R> the request type
 */
public abstract class BaseFacetedSearchAction<T, P extends Enum<?> & SearchParameter, R extends FacetedSearchRequest<P>>
  extends BaseSearchAction<T, P, R> {

  private static final long serialVersionUID = -1573017190241712345L;
  private static final Splitter querySplitter = Splitter.on("&").omitEmptyStrings();
  private static final Splitter paramSplitter = Splitter.on("=");

  private final Map<P, List<FacetInstance>> facetFilters = Maps.newHashMap();
  private final Map<P, List<FacetInstance>> facetCounts = Maps.newHashMap();
  private final Map<P, Long> facetMinimumCount = Maps.newHashMap();

  /**
   * This constant restricts the maximum number of facet results to be displayed
   */
  private static final int MAX_FACETS = 5;

  /**
   * Default constructor for this class.
   * 
   * @param searchService an instance of search service
   * @param searchType the type of the {@link Enum} used for search parameters & facets
   * @param request a new, default search request
   */
  protected BaseFacetedSearchAction(SearchService<T, P, R> searchService, Class<P> searchType, R request) {
    super(searchService, searchType, request);
  }

  /**
   * Adds facets to the search before it gets executed and initializes the facets to be displayed in the user interface.
   */
  @Override
  public String execute() {
    searchRequest.setMultiSelectFacets(true);
    // add all available facets to the request
    for (P fEnum : searchType.getEnumConstants()) {
      searchRequest.addFacets(fEnum);
    }
    // execute search
    final String result = super.execute();
    // initializes the elements required by the UI
    initializeFacetsForUI();
    // Remove selected facet filters that are not part of the response
    // removeNotShownFacetsFilters(searchResponse);
    return result;
  }

  /**
   * Searches for facetInstance.name in the list of FacetInstances.
   * 
   * @param facetInstance to find
   * @param facetInstances list of items to search
   * @return true/false if the facetInstance.name exists in the facetInstances
   */
  private boolean existFacetByName(FacetInstance facetInstance, List<FacetInstance> facetInstances) {
    for (FacetInstance faceInstanceSelected : facetInstances) {
      if (faceInstanceSelected.getName() != null && faceInstanceSelected.getName().equals(facetInstance.getName())) {
        return true;
      }
    }
    return false;
  }

  /**
   * Translates current url query parameter values via the translateFacetValue method.
   * 
   * @return current url with translated values
   */
  @Override
  public String getCurrentUrl() {
    StringBuffer currentUrl = request.getRequestURL();
    if (request.getQueryString() != null) {
      boolean first = true;
      for (String p : querySplitter.split(request.getQueryString())) {
        Iterator<String> kvIter = paramSplitter.split(p).iterator();
        String key = kvIter.next();
        String val = kvIter.next();
        // potentially translate facet values
        P facet = getSearchParam(key);
        if (facet != null) {
          val = translateFilterValue(facet, val);
        }
        if (first) {
          currentUrl.append("?");
        } else {
          currentUrl.append("&");
        }
        currentUrl.append(key);
        currentUrl.append("=");
        currentUrl.append(val);
        first = false;
      }
    }
    return currentUrl.toString();
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
  public Map<P, List<FacetInstance>> getFacetCounts() {
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
  public Map<P, List<FacetInstance>> getFacetFilters() {
    return facetFilters;
  }

  public int getMaxFacets() {
    return MAX_FACETS;
  }

  /**
   * Gets (calculated field) the facet counts that were previously selected used
   * 
   * @return the selected facet counts if any
   */
  public Map<P, List<FacetInstance>> getSelectedFacetCounts() {
    Map<P, List<FacetInstance>> selectedFacetCounts = Maps.newHashMap();
    if (facetCounts != null) {
      for (P facet : facetCounts.keySet()) {
        Long min = null;
        List<FacetInstance> selectedFacets = Lists.newArrayList();
        for (FacetInstance facetInstance : facetCounts.get(facet)) {
          if (facetInstance.getCount() != null && (min == null || facetInstance.getCount() < min)) {
            min = facetInstance.getCount();
          }
          if (isInFilter(facet, facetInstance.getName())) {
            selectedFacets.add(facetInstance);
          }
        }
        selectedFacetCounts.put(facet, selectedFacets);
        facetMinimumCount.put(facet, min);
      }
    }
    for (P facet : facetFilters.keySet()) {
      for (FacetInstance facetInstance : facetFilters.get(facet)) {
        boolean facetFound = existFacetByName(facetInstance, selectedFacetCounts.get(facet.name()));
        if (!facetFound) {
          facetInstance.setCount(null);
          selectedFacetCounts.get(facet.name()).add(0, facetInstance);
        }
      }
    }
    return selectedFacetCounts;
  }

  /**
   * By using the response object, this method initializes the facetCounts field.
   * If the response object contains facets, iterates over the facets for copying the count information into the
   * facetCounts (see {@link Facet.Count}) field.
   */
  private void initializeFacetsForUI() {
    if (searchResponse.getFacets() != null && !searchResponse.getFacets().isEmpty()) {
      // there are facets in the response
      for (Facet<P> facet : searchResponse.getFacets()) {
        if (facet.getCounts() != null) {// the facet.Count are stored in the facetCounts field
          facetFilters.put(facet.getField(), toFacetInstance(facet.getCounts()));
          facetCounts.put(facet.getField(), toFacetInstance(facet.getCounts()));
        }
      }
    }
  }

  /**
   * Checks if a facet value is already selected in the current selected filters.
   * Public method used by the html templates.
   * 
   * @param facet the facet name according to
   */
  public boolean isInFilter(P facet, String facetKey) {
    if (facet != null && facetFilters.containsKey(facet)) {
      for (FacetInstance facetInstance : facetFilters.get(facet)) {
        if (facetInstance.getName().equals(facetKey)) {
          return true;
        }
      }
    }
    return false;
  }

  /**
   * Utility function that sets facet titles.
   * The function uses a function parameter to accomplish this task.
   * The getTitleFunction could provide the actual communication with the service later to provide the required title.
   * 
   * @param facet the facet
   * @param getTitleFunction function that returns title using a facet name
   */
  protected void lookupFacetTitles(P facet, Function<String, String> getTitleFunction) {
    // "cache"
    Map<String, String> names = Maps.newHashMap();

    // filters
    if (getFacetFilters().containsKey(facet)) {
      for (FacetInstance fi : getFacetFilters().get(facet)) {
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

  public Map<P, Long> getFacetMinimumCount() {
    return facetMinimumCount;
  }
}
