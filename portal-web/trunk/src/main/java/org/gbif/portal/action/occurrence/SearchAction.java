package org.gbif.portal.action.occurrence;

import org.gbif.api.model.checklistbank.Constants;
import org.gbif.api.model.common.paging.PagingRequest;
import org.gbif.api.model.common.paging.PagingResponse;
import org.gbif.api.model.occurrence.Occurrence;
import org.gbif.api.model.occurrence.search.OccurrenceSearchParameter;
import org.gbif.api.model.occurrence.search.OccurrenceSearchRequest;
import org.gbif.api.model.registry.Dataset;
import org.gbif.api.service.checklistbank.NameUsageService;
import org.gbif.api.service.occurrence.OccurrenceSearchService;
import org.gbif.api.service.registry.DatasetService;
import org.gbif.api.vocabulary.BasisOfRecord;
import org.gbif.portal.action.BaseAction;

import java.util.Arrays;

import com.google.common.collect.HashMultimap;
import com.google.common.collect.Multimap;
import com.google.inject.Inject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import static org.gbif.api.model.common.paging.PagingConstants.DEFAULT_PARAM_LIMIT;
import static org.gbif.api.model.common.paging.PagingConstants.DEFAULT_PARAM_OFFSET;

/**
 * Search action class for occurrence search page.
 */
public class SearchAction extends BaseAction {


  private static final long serialVersionUID = 4064512946598688405L;

  private static final Logger LOG = LoggerFactory.getLogger(SearchAction.class);

  private final OccurrenceSearchService occurrenceSearchService;

  private final DatasetService datasetService;

  private final OccurrenceSearchRequest pagingRequest;

  private PagingResponse<Occurrence> searchResponse;

  private Multimap<String, String> filters = HashMultimap.create();

  private final NameUsageService nameUsageService;

  @Inject
  public SearchAction(OccurrenceSearchService occurrenceSearchService, DatasetService datasetService,
    NameUsageService nameUsageService) {
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


  public BasisOfRecord[] getBasisOfRecords() {
    return BasisOfRecord.values();
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
    OccurrenceSearchParameter parameter = OccurrenceSearchParameter.getByParam(filterKey);
    if (parameter != null) {
      if (parameter == OccurrenceSearchParameter.NUB_KEY) {
        return nameUsageService.get(Integer.parseInt(filterValue), null).getScientificName();
      } else if (parameter == OccurrenceSearchParameter.BASIS_OF_RECORD) {
        return filterValue;
      }
    }
    return filterValue;
  }


  /**
   * Gets the NUB key value.
   */
  public String getNubTaxonomyKey() {
    return Constants.NUB_TAXONOMY_KEY.toString();
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

  /**
   * Checks is the parameters accepts range query.
   */
  private boolean isRangeParameter(OccurrenceSearchParameter param) {
    return (param == OccurrenceSearchParameter.BOUNDING_BOX || param == OccurrenceSearchParameter.DATE);
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
          if (!isRangeParameter(occParam) && paramValue.contains(",")) {
            filters.putAll(occParam.getParam(), Arrays.asList(paramValue.split(",")));
          } else {
            filters.put(occParam.getParam(), paramValue);
          }
        }
      }
    }
  }

}
