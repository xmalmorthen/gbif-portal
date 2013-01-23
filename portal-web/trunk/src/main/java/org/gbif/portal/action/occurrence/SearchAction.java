package org.gbif.portal.action.occurrence;

import org.gbif.api.model.Constants;
import org.gbif.api.model.occurrence.Occurrence;
import org.gbif.api.model.occurrence.search.OccurrenceSearchParameter;
import org.gbif.api.model.occurrence.search.OccurrenceSearchRequest;
import org.gbif.api.service.occurrence.OccurrenceSearchService;
import org.gbif.api.vocabulary.BasisOfRecord;
import org.gbif.api.vocabulary.Country;
import org.gbif.portal.action.BaseSearchAction;
import org.gbif.portal.model.NameUsageSearchSuggestions;
import org.gbif.portal.model.OccurrenceTable;

import java.util.Set;

import com.google.common.base.Strings;
import com.google.common.collect.Multimap;
import com.google.inject.Inject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import static org.gbif.api.model.common.paging.PagingConstants.DEFAULT_PARAM_LIMIT;
import static org.gbif.api.model.common.paging.PagingConstants.DEFAULT_PARAM_OFFSET;

/**
 * Search action class for occurrence search page.
 */
public class SearchAction extends BaseSearchAction<Occurrence, OccurrenceSearchParameter, OccurrenceSearchRequest> {

  private static final long serialVersionUID = 4064512946598688405L;

  private static final Logger LOG = LoggerFactory.getLogger(SearchAction.class);

  private final FiltersActionHelper filtersActionHelper;

  private NameUsageSearchSuggestions nameUsagesSuggestions;

  private OccurrenceTable table;


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
    // read filter parameters in order to have them available even when the search wasn't executed.
    readFilterParams();

    table = new OccurrenceTable(request);

    // process taxon/scientific-name suggestions
    nameUsagesSuggestions = filtersActionHelper.processNameUsagesSuggestions(request);

    // replace known name usages
    filtersActionHelper.replaceKnownNameUsages(searchRequest, nameUsagesSuggestions);

    // Search is executed only if there aren't suggestions that need to be notified to the user
    if (!nameUsagesSuggestions.hasSuggestions() && filtersActionHelper.validateSearchParameters(this, this.request)) {
      return executeSearch();
    }
    return SUCCESS;
  }


  /**
   * Utility method that executes the search.
   * Differs to the BaseSearchAction.execute() method in that this method doesn't execute the method
   * BaseSearchAction.readFilterParams().
   */
  public String executeSearch() {
    LOG.info("Search for [{}]", getQ());
    // default query parameters
    searchRequest.setQ(getQ());
    // Turn off highlighting for empty query strings
    searchRequest.setHighlight(!Strings.isNullOrEmpty(q));
    // issues the search operation
    searchResponse = searchService.search(searchRequest);
    LOG.debug("Search for [{}] returned {} results", getQ(), searchResponse.getCount());
    return SUCCESS;
  }

  /**
   * Returns the list of {@link BasisOfRecord} literals.
   */
  public BasisOfRecord[] getBasisOfRecords() {
    return filtersActionHelper.getBasisOfRecords();
  }

  /**
   * Returns the list of {@link Country} literals.
   */
  public Set<Country> getCountries() {
    return filtersActionHelper.getCountries();
  }

  /**
   * Gets the current year.
   * This value is used by occurrence filters to determine the maximum year that is allowed for the
   * OccurrenceSearchParamater.DATE.
   */
  public int getCurrentYear() {
    return filtersActionHelper.getCurrentYear();
  }

  /**
   * Gets the Dataset title, the key parameter is returned if either the Dataset doesn't exists or it
   * doesn't have a title.
   */
  public String getDatasetTitle(String key) {
    return filtersActionHelper.getDatasetTitle(key);
  }

  // this method is only a convenience one exposing the request filters so the ftl templates dont need to be adapted
  public Multimap<OccurrenceSearchParameter, String> getFilters() {
    return searchRequest.getParameters();
  }

  /**
   * Gets the readable value of filter parameter.
   */
  public String getFilterTitle(String filterKey, String filterValue) {
    return filtersActionHelper.getFilterTitle(filterKey, filterValue);
  }

  /**
   * Suggestions map for scientific name, has the form: "parameter value" -> list of suggestions.
   * 
   * @return the nameUsagesSuggestions
   */
  public NameUsageSearchSuggestions getNameUsagesSuggestions() {
    return nameUsagesSuggestions;
  }

  /**
   * Gets the NUB key value.
   */
  public String getNubTaxonomyKey() {
    return Constants.NUB_TAXONOMY_KEY.toString();
  }


  /**
   * @return the table
   */
  public OccurrenceTable getTable() {
    return table;
  }

  /**
   * Validates if the download functionality should be shown.
   */
  public boolean showDownload() {
    return this.getCurrentUser() != null && searchResponse.getCount() > 0 && !hasErrors()
      && !nameUsagesSuggestions.hasSuggestions();
  }
}
