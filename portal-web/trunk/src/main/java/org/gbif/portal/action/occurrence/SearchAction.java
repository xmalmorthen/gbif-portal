package org.gbif.portal.action.occurrence;

import org.gbif.api.paging.PagingRequest;
import org.gbif.api.paging.PagingResponse;
import org.gbif.occurrencestore.api.model.Occurrence;
import org.gbif.occurrencestore.api.service.OccurrenceSearchService;
import org.gbif.occurrencestore.api.service.search.OccurrenceSearchRequest;
import org.gbif.occurrencestore.download.api.model.predicate.Predicate;
import org.gbif.portal.action.BaseAction;
import org.gbif.portal.action.occurrence.util.PredicateFactory;
import org.gbif.portal.action.occurrence.util.search.QueryBuildingException;
import org.gbif.portal.action.occurrence.util.search.WsSearchVisitor;

import java.util.Map;

import com.google.common.base.Strings;
import com.google.common.collect.Maps;
import com.google.common.collect.Multimap;
import com.google.inject.Inject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import static org.gbif.api.paging.PagingConstants.DEFAULT_PARAM_LIMIT;
import static org.gbif.api.paging.PagingConstants.DEFAULT_PARAM_OFFSET;
import static org.gbif.occurrencestore.api.service.search.Constants.CATALOGUE_NUMBER_PARAM;
import static org.gbif.occurrencestore.api.service.search.Constants.DATASET_KEY_PARAM;
import static org.gbif.occurrencestore.api.service.search.Constants.LATITUDE_PARAM;
import static org.gbif.occurrencestore.api.service.search.Constants.LONGITUDE_PARAM;
import static org.gbif.occurrencestore.api.service.search.Constants.MONTH_PARAM;
import static org.gbif.occurrencestore.api.service.search.Constants.NUB_KEY_PARAM;
import static org.gbif.occurrencestore.api.service.search.Constants.YEAR_PARAM;

/**
 * Search action class for occurrence search page.
 */
public class SearchAction extends BaseAction {

  // This is a placeholder to map from the JSON definition ID to the query field
  private static final Map<String, String> QUERY_FIELD_MAPPING = Maps.newHashMap();
  static {
    QUERY_FIELD_MAPPING.put("1", LATITUDE_PARAM);
    QUERY_FIELD_MAPPING.put("2", LONGITUDE_PARAM);
    QUERY_FIELD_MAPPING.put("3", YEAR_PARAM);
    QUERY_FIELD_MAPPING.put("4", MONTH_PARAM);
    QUERY_FIELD_MAPPING.put("5", CATALOGUE_NUMBER_PARAM);

  }

  private static final long serialVersionUID = 4064512946598688405L;

  private static final Logger LOG = LoggerFactory.getLogger(SearchAction.class);

  private final OccurrenceSearchService occurrenceSearchService;

  private final PredicateFactory predicateFactory = new PredicateFactory(QUERY_FIELD_MAPPING);

  private final OccurrenceSearchRequest pagingRequest;

  private final WsSearchVisitor paramsVisitor = new WsSearchVisitor();

  private PagingResponse<Occurrence> searchResponse;

  private String datasetKey = "";

  private String nubKey = "";

  @Inject
  public SearchAction(OccurrenceSearchService occurrenceSearchService) {
    this.pagingRequest = new OccurrenceSearchRequest(DEFAULT_PARAM_OFFSET, DEFAULT_PARAM_LIMIT);
    this.occurrenceSearchService = occurrenceSearchService;
    LOG.info("Action built!");
  }

  @Override
  public String execute() {
    try {
      LOG.debug(
        "Exceuting query, params {}, limit {}, offset {}",
        new Object[] {pagingRequest.getParams(), pagingRequest.getLimit(), pagingRequest.getOffset()});
      pagingRequest.setParams(buildFilterParams());
      searchResponse = occurrenceSearchService.listOccurrences(pagingRequest);
      return SUCCESS;
    } catch (QueryBuildingException e) {
      LOG.error("Error creating query parameters from the current request paramaters", e);
      return ERROR;
    }
  }


  /**
   * @return the datasetKey
   */
  public String getDatasetKey() {
    return datasetKey;
  }


  /**
   * @return the nubKey
   */
  public String getNubKey() {
    return nubKey;
  }


  /**
   * Gets the offset value.
   */
  public long getOffset() {
    return pagingRequest.getOffset();
  }


  /**
   * @return the response
   */
  public PagingResponse<Occurrence> getSearchResponse() {
    return searchResponse;
  }


  /**
   * @param datasetKey the datasetKey to set
   */
  public void setDatasetKey(String datasetKey) {
    this.datasetKey = datasetKey;
  }


  /**
   * @param nubKey the nubKey to set
   */
  public void setNubKey(String nubKey) {
    this.nubKey = nubKey;
  }


  /**
   * @param offset the offset to set
   * @see PagingRequest#setOffset(long)
   */
  public void setOffset(long offset) {
    pagingRequest.setOffset(offset);
  }

  /**
   * Builds the parameters from query predicate parameters.
   */
  private Multimap<String, String> buildFilterParams() throws QueryBuildingException {
    Multimap<String, String> params = null;
    if (!getServletRequest().getParameterMap().isEmpty()) {
      @SuppressWarnings("unchecked")
      Predicate p = predicateFactory.build(getServletRequest().getParameterMap());
      params = paramsVisitor.getWsSearchParameters(p);
      if (!Strings.isNullOrEmpty(datasetKey)) {
        params.put(DATASET_KEY_PARAM, datasetKey);
      }
      if (!Strings.isNullOrEmpty(nubKey)) {
        params.put(NUB_KEY_PARAM, nubKey);
      }
      LOG.info("Predicate build for passing to search [{}]", params);
    }
    return params;
  }

}
