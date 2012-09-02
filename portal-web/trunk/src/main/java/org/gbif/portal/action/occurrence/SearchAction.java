package org.gbif.portal.action.occurrence;

import org.gbif.api.paging.PagingRequest;
import org.gbif.api.paging.PagingResponse;
import org.gbif.checklistbank.api.service.NameUsageService;
import org.gbif.occurrencestore.api.model.Occurrence;
import org.gbif.occurrencestore.api.model.constants.OccurrenceSearchParameter;
import org.gbif.occurrencestore.api.service.OccurrenceSearchService;
import org.gbif.occurrencestore.api.service.search.OccurrenceSearchRequest;
import org.gbif.portal.action.BaseAction;
import org.gbif.registry.api.model.Dataset;
import org.gbif.registry.api.service.DatasetService;

import java.util.Map;

import com.google.common.collect.HashMultimap;
import com.google.common.collect.Maps;
import com.google.common.collect.Multimap;
import com.google.inject.Inject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import static org.gbif.api.paging.PagingConstants.DEFAULT_PARAM_LIMIT;
import static org.gbif.api.paging.PagingConstants.DEFAULT_PARAM_OFFSET;
import static org.gbif.occurrencestore.api.model.constants.OccurrenceSearchParameter.BASIS_OF_RECORD;
import static org.gbif.occurrencestore.api.model.constants.OccurrenceSearchParameter.CATALOGUE_NUMBER;
import static org.gbif.occurrencestore.api.model.constants.OccurrenceSearchParameter.COLLECTOR_NAME;
import static org.gbif.occurrencestore.api.model.constants.OccurrenceSearchParameter.COUNTRY_CODE;
import static org.gbif.occurrencestore.api.model.constants.OccurrenceSearchParameter.DATASET_KEY;
import static org.gbif.occurrencestore.api.model.constants.OccurrenceSearchParameter.DAY;
import static org.gbif.occurrencestore.api.model.constants.OccurrenceSearchParameter.HIGHER_TAXON_KEY;
import static org.gbif.occurrencestore.api.model.constants.OccurrenceSearchParameter.LATITUDE;
import static org.gbif.occurrencestore.api.model.constants.OccurrenceSearchParameter.LONGITUDE;
import static org.gbif.occurrencestore.api.model.constants.OccurrenceSearchParameter.MONTH;
import static org.gbif.occurrencestore.api.model.constants.OccurrenceSearchParameter.YEAR;

/**
 * Search action class for occurrence search page.
 */
public class SearchAction extends BaseAction {

  // This is a placeholder to map from the JSON definition ID to the query field
  private static final Map<String, String> QUERY_FIELD_MAPPING = Maps.newHashMap();
  static {
    QUERY_FIELD_MAPPING.put("1", LATITUDE.getParam());
    QUERY_FIELD_MAPPING.put("2", LONGITUDE.getParam());
    QUERY_FIELD_MAPPING.put("3", DATASET_KEY.getParam());
    QUERY_FIELD_MAPPING.put("4", YEAR.getParam());
    QUERY_FIELD_MAPPING.put("5", MONTH.getParam());
    QUERY_FIELD_MAPPING.put("6", CATALOGUE_NUMBER.getParam());
    QUERY_FIELD_MAPPING.put("7", HIGHER_TAXON_KEY.getParam());
    QUERY_FIELD_MAPPING.put("8", COLLECTOR_NAME.getParam());
    QUERY_FIELD_MAPPING.put("9", BASIS_OF_RECORD.getParam());
    QUERY_FIELD_MAPPING.put("10", COUNTRY_CODE.getParam());
    QUERY_FIELD_MAPPING.put("11", DAY.getParam());

  }

  private static final long serialVersionUID = 4064512946598688405L;

  private static final Logger LOG = LoggerFactory.getLogger(SearchAction.class);

  private final OccurrenceSearchService occurrenceSearchService;

  private final DatasetService datasetService;

  private final OccurrenceSearchRequest pagingRequest;

  private PagingResponse<Occurrence> searchResponse;

  private Multimap<String, String> filters = HashMultimap.create();

  private final NameUsageService nameUsageService;

  @Inject
  public SearchAction(OccurrenceSearchService occurrenceSearchService, DatasetService datasetService, NameUsageService nameUsageService) {
    this.pagingRequest = new OccurrenceSearchRequest(DEFAULT_PARAM_OFFSET, DEFAULT_PARAM_LIMIT);
    this.occurrenceSearchService = occurrenceSearchService;
    this.datasetService = datasetService;
    this.nameUsageService = nameUsageService;
    LOG.info("Action built!");
  }

  @Override
  public String execute() {
    LOG.debug("Exceuting query, params {}, limit {}, offset {}",
      new Object[] {pagingRequest.getParams(), pagingRequest.getLimit(), pagingRequest.getOffset()});
    readFiltersFromRequest();
    pagingRequest.setParams(this.filters);
    searchResponse = occurrenceSearchService.listOccurrences(pagingRequest);
    return SUCCESS;
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
   * @return the filters
   */
  public Multimap<String, String> getFilters() {
    return filters;
  }

  /**
   * Gets the displayable value of filter parameter.
   */
  public String getFilterTitle(String filterKey, String filterValue) {
// Removed by Tim, because this method does not exist, and this appears to be half done dev code
// OccurrenceSearchParameter parameter = OccurrenceSearchParameter.getByParam(filterKey);
// if (parameter != null) {
// if (parameter == OccurrenceSearchParameter.NUB_KEY) {
// return nameUsageService.get(Integer.parseInt(filterValue), null).getScientificName();
// }
// }
    return filterValue;
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
   * Reads the filters from the request parameters.
   * The format of filter parameters is : OccurrenceSearchParameter.getParam*().
   */
  private void readFiltersFromRequest() {
    for (OccurrenceSearchParameter occParam : OccurrenceSearchParameter.values()) {
      String[] values = this.request.getParameterValues(occParam.getParam());
      if (values != null) {
        for (String paramValue : values) {
          filters.put(occParam.getParam(), paramValue);
        }
      }
    }
  }


  /**
   * @param filters the filters to set
   */
  public void setFilter(Multimap<String, String> filters) {
    this.filters = filters;
  }

  /**
   * @param offset the offset to set
   * @see PagingRequest#setOffset(long)
   */
  public void setOffset(long offset) {
    pagingRequest.setOffset(offset);
  }

}
