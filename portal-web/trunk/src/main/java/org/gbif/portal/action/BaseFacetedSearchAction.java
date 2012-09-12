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
import org.gbif.api.model.common.search.SearchResponse;
import org.gbif.api.service.common.SearchService;
import org.gbif.api.vocabulary.Language;
import org.gbif.portal.model.FacetInstance;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import com.google.common.base.Function;
import com.google.common.base.Splitter;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.google.common.collect.Multimap;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

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

  private static final Logger LOG = LoggerFactory.getLogger(BaseFacetedSearchAction.class);
  private static final Splitter querySplitter = Splitter.on("&").omitEmptyStrings();
  private static final Splitter paramSplitter = Splitter.on("=");

  /**
   * Serial version
   */
  private static final long serialVersionUID = -1573017190241712345L;
  private final Map<Enum<F>, List<FacetInstance>> facets = new HashMap<Enum<F>, List<FacetInstance>>();
  private final HashMap<String, List<FacetInstance>> facetCounts;

  /**
   * This constant restricts the maximum number of facet results to be displayed
   */
  private static final int MAX_FACETS = 5;

  /**
   * This field is used to hold the class of the enum used for faceting.
   * This instance is used to iterate over the possible literal values of the enumerated type.
   */
  private final Class<? extends Enum<F>> facetEnum;

  private final SearchService<T> searchService;

  /**
   * Default constructor for this class.
   * 
   * @param searchService an instance of search service
   * @param facetEnum the type of the {@link Enum} used for facets
   */
  protected BaseFacetedSearchAction(SearchService<T> searchService, Class<? extends Enum<F>> facetEnum) {
    this.searchService = searchService;
    this.facetCounts = new HashMap<String, List<FacetInstance>>();
    this.facetEnum = facetEnum;
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
    for (Map.Entry<Enum<F>, List<FacetInstance>> enumListEntry : facets.entrySet()) {
      List<FacetInstance> values = enumListEntry.getValue();
      if (values != null) {
        for (FacetInstance facetValue : values) {
          searchRequest.addFacetedParameter(enumListEntry.getKey(), facetValue.getName());
        }
      }
    }
  }

  /**
   * Executes the default action behavior.
   * The steps taken on this method are:
   * - Creates a {@link org.gbif.api.search.SearchRequest} using the current {@link org.gbif.api.search.SearchRequest}
   * instance
   * - Adds the search pattern to the request by invoking this.getQ().
   * - Executes the search operation using the {@link SearchService}.
   * - Stores the response in the {@link SearchResponse} instance.
   * - Initializes the facets to be displayed in the user interface.
   */
  @Override
  public String execute() {
    LOG.info("Search for [{}]", getQ());
    // Request creation
    addFacetParameters();
    // default query parameters
    searchRequest.setQ(getQ());
    // adds parameters processed by subclasses
    searchRequest.addParameter(getRequestParameters());
    // adds the language
    Language lang = Language.fromIsoCode(getLocale().getLanguage());
    searchRequest.setLanguage(lang);
    // issues the search operation
    searchResponse = searchService.search(searchRequest);
    // initializes the elements required by the UI
    initializeFacetCounts(searchResponse);
    // Remove selected facet filters that are not part of the response
    // removeNotShownFacetsFilters(searchResponse);
    LOG.info("Search for [{}] returned {} results", getQ(), searchResponse.getCount());
    return SUCCESS;
  }

  /**
   * Searches for facetInstance.name in the list of FacetInstances.
   * 
   * @param facetInstance to find
   * @param facetInstances list of items to search
   * @return true/false if the facetInstance.name exists in the facetInstances
   */
  private boolean existFacetByName(FacetInstance facetInstance, List<FacetInstance> facetInstances) {
    boolean facetFound = false;
    for (FacetInstance faceInstanceSelected : facetInstances) {
      if (faceInstanceSelected.getName() != null && faceInstanceSelected.getName().equals(facetInstance.getName())) {
        return facetFound = true;
      }
    }
    return facetFound;
  }

  private Enum<F> findFacetEnum(String param) {
    if (com.google.common.base.Strings.isNullOrEmpty(param)) {
      return null;
    }
    for (Enum<F> fEnum : facetEnum.getEnumConstants()) {
      // recognize facets by enum name
      String pname = fEnum.name().toLowerCase();
      if (param.equalsIgnoreCase(pname)) {
        return fEnum;
      }
    }
    return null;
  }

  /**
   * Gets the instance of the current object.
   * This helps to expose public methods to the web templates.
   */
  public BaseAction getAction() {
    return this;
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
        Enum<F> facet = findFacetEnum(key);
        if (facet != null) {
          val = translateFacetValue(facet, val);
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
   * Analyze the request to determine if parameters should be added from the request parameters.
   * 
   * @return a {@link Multimap} containing the parameters
   */
  public abstract Multimap<String, String> getRequestParameters();

  /**
   * Gets (calculated field) the facet counts that were previously selected.
   * 
   * @return the selected facet counts if any
   */
  public Map<String, List<FacetInstance>> getSelectedFacetCounts() {
    HashMap<String, List<FacetInstance>> selectedFacetCounts = new HashMap<String, List<FacetInstance>>();
    if (facetCounts != null) {
      for (String facet : facetCounts.keySet()) {
        List<FacetInstance> selectedFacets = new ArrayList<FacetInstance>();
        for (FacetInstance facetInstance : facetCounts.get(facet)) {
          if (isInFilter(facet, facetInstance.getName())) {
            selectedFacets.add(facetInstance);
          }
        }
        selectedFacetCounts.put(facet, selectedFacets);
      }
    }
    for (Enum<F> facet : this.facets.keySet()) {
      for (FacetInstance facetInstance : this.facets.get(facet)) {
        boolean facetFound = existFacetByName(facetInstance, selectedFacetCounts.get(facet.name()));
        if (!facetFound) {
          facetInstance.setCount(0L);
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

    for (String p : params.keySet()) {
      // recognize facets by enum name
      Enum<F> facet = findFacetEnum(p);
      if (facet != null) {
        // facet filter found
        List<FacetInstance> values = Lists.newArrayList();
        for (String v : params.get(p)) {
          values.add(new FacetInstance(translateFacetValue(facet, v)));
        }
        this.facets.put(facet, values);
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

  /**
   * Optional hook for concrete search actions to define custom translations of facet filter values
   * before they are send to the search service.
   * For example to enable a simple checklist=nub filter without the need to know the real nub UUID.
   * The values will NOT be translated for the UI and request parameters, only for the search and title lookup service!
   * This method can be overriden to modify the returned value, by default it keeps it as it is.
   * 
   * @param facet the value belongs to
   * @param value the value to translate or return as is
   */
  protected String translateFacetValue(Enum<F> facet, String value) {
    // dont do anything by default
    return value;
  }
}
