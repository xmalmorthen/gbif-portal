/**
 * 
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
 * @author fede
 */
public class BaseFacetedSearchAction<T, F extends Enum<F>> extends BaseSearchAction<T> {

  /**
   * 
   */
  private static final long serialVersionUID = -1573017190241712345L;

  private static final Logger LOG = LoggerFactory.getLogger(BaseFacetedSearchAction.class);

  private Map<String, String[]> facets;

  private Map<String, List<Facet.Count>> facetCounts;

  private Class<? extends Enum<F>> classEnum;


  private SearchService<T> searchService;

  public BaseFacetedSearchAction(SearchService<T> searchService, Class<? extends Enum<F>> classEnum) {
    super();
    this.searchService = searchService;
    this.facetCounts = new HashMap<String, List<Facet.Count>>();
    this.classEnum = classEnum;
  }

  private void addFacetParameters(Enum<F> facetEnum, SearchRequest request) {
    if (this.facets != null) {
      String[] values = facets.get(facetEnum.name());
      if (values != null) {
        for (String facetValue : values) {
          request.addFacetedParameter(facetEnum, facetValue);
        }
      }
    }
  }

  private void addFacetParameters(SearchRequest request) {
    for (Enum<F> enumConstant : classEnum.getEnumConstants()) {
      request.addFacets(enumConstant);
      this.addFacetParameters(enumConstant, request);
    }
  }

  @Override
  public String execute() {
    LOG.info("Search of [{}]", this.getQ());
    SearchRequest request = new SearchRequest(this.getSearchRequest().getOffset(), this.getSearchRequest().getLimit());
    this.addFacetParameters(request);
    // default query parameter
    request.addParameter(DEFAULT_SEARCH_PARAM, this.getQ());
    SearchResponse<T> results = searchService.search(request);
    this.setSearchResponse(results);
    this.initializeFacets(results);
    LOG.info("Action search of [{}] returned {} results", this.getQ(), this.getSearchResponse().getCount());
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

  private void initializeFacets(SearchResponse<T> results) {
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
