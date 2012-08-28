package org.gbif.portal.action.occurrence;

import org.gbif.api.paging.PagingRequest;
import org.gbif.api.paging.PagingResponse;
import org.gbif.occurrencestore.api.model.Occurrence;
import org.gbif.occurrencestore.api.model.constants.OccurrenceSearchParameter;
import org.gbif.occurrencestore.api.service.OccurrenceSearchService;
import org.gbif.occurrencestore.api.service.search.OccurrenceSearchRequest;
import org.gbif.occurrencestore.download.api.model.predicate.Predicate;
import org.gbif.portal.action.BaseAction;
import org.gbif.portal.action.occurrence.util.PredicateFactory;
import org.gbif.portal.action.occurrence.util.search.QueryBuildingException;
import org.gbif.portal.action.occurrence.util.search.WsSearchVisitor;
import org.gbif.registry.api.model.Dataset;
import org.gbif.registry.api.service.DatasetService;

import java.util.Map;

import com.google.common.collect.Maps;
import com.google.common.collect.Multimap;
import com.google.inject.Inject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import static org.gbif.api.paging.PagingConstants.DEFAULT_PARAM_LIMIT;
import static org.gbif.api.paging.PagingConstants.DEFAULT_PARAM_OFFSET;

/**
 * Search action class for occurrence search page.
 */
public class SearchAction extends BaseAction {

  // This is a placeholder to map from the JSON definition ID to the query field
  private static final Map<String, String> QUERY_FIELD_MAPPING = Maps.newHashMap();
  static {
    QUERY_FIELD_MAPPING.put("1", OccurrenceSearchParameter.LATITUDE.getParam());
    QUERY_FIELD_MAPPING.put("2", OccurrenceSearchParameter.LONGITUDE.getParam());
    QUERY_FIELD_MAPPING.put("3", OccurrenceSearchParameter.DATASET_KEY.getParam());
    QUERY_FIELD_MAPPING.put("4", OccurrenceSearchParameter.YEAR.getParam());
    QUERY_FIELD_MAPPING.put("5", OccurrenceSearchParameter.MONTH.getParam());
    QUERY_FIELD_MAPPING.put("6", OccurrenceSearchParameter.CATALOGUE_NUMBER.getParam());
    QUERY_FIELD_MAPPING.put("7", OccurrenceSearchParameter.HIGHER_TAXON_KEY.getParam());
    QUERY_FIELD_MAPPING.put("8", OccurrenceSearchParameter.COLLECTOR_NAME.getParam());
    QUERY_FIELD_MAPPING.put("9", OccurrenceSearchParameter.BASIS_OF_RECORD.getParam());
    QUERY_FIELD_MAPPING.put("10", OccurrenceSearchParameter.COUNTRY_CODE.getParam());
    QUERY_FIELD_MAPPING.put("11", OccurrenceSearchParameter.DAY.getParam());

  }

  private static final long serialVersionUID = 4064512946598688405L;

  private static final Logger LOG = LoggerFactory.getLogger(SearchAction.class);

  private final OccurrenceSearchService occurrenceSearchService;

  private final DatasetService datasetService;

  private final PredicateFactory predicateFactory = new PredicateFactory(QUERY_FIELD_MAPPING);

  private final OccurrenceSearchRequest pagingRequest;

  private final WsSearchVisitor paramsVisitor = new WsSearchVisitor();

  private PagingResponse<Occurrence> searchResponse;

  @Inject
  public SearchAction(OccurrenceSearchService occurrenceSearchService, DatasetService datasetService) {
    this.pagingRequest = new OccurrenceSearchRequest(DEFAULT_PARAM_OFFSET, DEFAULT_PARAM_LIMIT);
    this.occurrenceSearchService = occurrenceSearchService;
    this.datasetService = datasetService;
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
   * Allows exposing the Action class to the jsp level.
   */
  public SearchAction getAction() {
    return this;
  }

  /**
   * Gets the title of a data set byt its key.
   */
  public String getDatasetTitle(String datasetKey) {
    Dataset dataset = datasetService.get(datasetKey);
    return dataset.getTitle();
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
      LOG.info("Predicate build for passing to search [{}]", params);
    }
    return params;
  }

}
