package org.gbif.portal.action.occurrence;

import org.gbif.api.model.Constants;
import org.gbif.api.model.occurrence.Occurrence;
import org.gbif.api.model.occurrence.search.OccurrenceSearchParameter;
import org.gbif.api.model.occurrence.search.OccurrenceSearchRequest;
import org.gbif.api.service.occurrence.OccurrenceSearchService;
import org.gbif.api.vocabulary.BasisOfRecord;
import org.gbif.portal.action.BaseSearchAction;

import com.google.common.collect.Multimap;
import com.google.inject.Inject;

import static org.gbif.api.model.common.paging.PagingConstants.DEFAULT_PARAM_LIMIT;
import static org.gbif.api.model.common.paging.PagingConstants.DEFAULT_PARAM_OFFSET;

/**
 * Search action class for occurrence search page.
 */
public class SearchAction extends BaseSearchAction<Occurrence, OccurrenceSearchParameter, OccurrenceSearchRequest> {

  private static final long serialVersionUID = 4064512946598688405L;

  private final FiltersActionHelper filtersActionHelper;

  @Inject
  public SearchAction(OccurrenceSearchService occurrenceSearchService, FiltersActionHelper filtersActionHelper) {
    super(occurrenceSearchService, OccurrenceSearchParameter.class, new OccurrenceSearchRequest(DEFAULT_PARAM_OFFSET,
      DEFAULT_PARAM_LIMIT));
    this.filtersActionHelper = filtersActionHelper;
  }


  /*
   * (non-Javadoc)
   * @see org.gbif.portal.action.BaseSearchAction#execute()
   */
  @Override
  public String execute() {
    if (filtersActionHelper.validateSearchParameters(this, this.request)) {
      return super.execute();
    } else {
      return SUCCESS;
    }
  }


  public BasisOfRecord[] getBasisOfRecords() {
    return BasisOfRecord.values();
  }


  /**
   * Gets the Dataset title, the key parameter is returned if either the Dataset doesn't exists or it
   * doesn't have a title.
   */
  public String getDatasetTitle(String key) {
    return this.filtersActionHelper.getDatasetTitle(key);
  }

  // this method is only a convenience one exposing the request filters so the ftl templates dont need to be adapted
  public Multimap<OccurrenceSearchParameter, String> getFilters() {
    return searchRequest.getParameters();
  }

  /**
   * Gets the displayable value of filter parameter.
   */
  public String getFilterTitle(String filterKey, String filterValue) {
    return this.filtersActionHelper.getFilterTitle(filterKey, filterValue);
  }

  /**
   * Gets the NUB key value.
   */
  public String getNubTaxonomyKey() {
    return Constants.NUB_TAXONOMY_KEY.toString();
  }

}
