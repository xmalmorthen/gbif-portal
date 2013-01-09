package org.gbif.portal.action.occurrence;

import org.gbif.api.model.checklistbank.search.NameUsageSearchResult;
import org.gbif.api.model.occurrence.search.OccurrenceSearchParameter;
import org.gbif.api.util.VocabularyUtils;
import org.gbif.api.vocabulary.BasisOfRecord;
import org.gbif.portal.action.BaseAction;

import java.util.Enumeration;
import java.util.List;
import java.util.Map;

import com.google.common.collect.Maps;
import com.google.inject.Inject;

/**
 * Action for initial occurrence download page.
 * Provides the functions required by the UI widgets.
 */
public class DownloadHomeAction extends BaseAction {

  private static final long serialVersionUID = 3653614424275432914L;

  private final FiltersActionHelper filtersActionHelper;

  private Map<OccurrenceSearchParameter, String[]> filters;

  private Map<String, List<NameUsageSearchResult>> nameUsagesSuggestions;

  @Inject
  public DownloadHomeAction(FiltersActionHelper filtersActionHelper) {
    this.filtersActionHelper = filtersActionHelper;
  }

  /*
   * (non-Javadoc)
   * @see org.gbif.portal.action.BaseSearchAction#execute()
   */
  @Override
  public String execute() {
    // process taxon/scientific-name suggestions
    nameUsagesSuggestions = filtersActionHelper.processTaxonSuggestions(request);
    // Validation is executed only if there aren't suggestions that need to be notified to the user
    if (!hasSuggestions()) {
      filtersActionHelper.validateSearchParameters(this, this.request);
    }
    return SUCCESS;
  }

  /**
   * List the value of BasisOfRecord enum.
   */
  public BasisOfRecord[] getBasisOfRecords() {
    return filtersActionHelper.getBasisOfRecords();
  }

  /**
   * Gets the list of values of {@link OccurrenceSearchParameter} that have been requested.
   */
  public Map<OccurrenceSearchParameter, String[]> getFilters() {
    if (filters == null) {
      filters = Maps.newHashMap();
      for (Enumeration<String> params = this.request.getParameterNames(); params.hasMoreElements();) {
        String param = params.nextElement();
        Enum<?> occSearchParam = VocabularyUtils.lookupEnum(param, OccurrenceSearchParameter.class);
        if (occSearchParam != null) {
          filters.put((OccurrenceSearchParameter) occSearchParam, this.request.getParameterValues(param));
        }
      }
    }
    return filters;
  }

  /**
   * Gets the readable value of filter parameter.
   */
  public String getFilterTitle(String filterKey, String filterValue) {
    return this.filtersActionHelper.getFilterTitle(filterKey, filterValue);
  }

  /**
   * Suggestions map for scientific name, has the form: "parameter value" -> list of suggestions.
   * 
   * @return the nameUsagesSuggestions
   */
  public Map<String, List<NameUsageSearchResult>> getNameUsagesSuggestions() {
    return nameUsagesSuggestions;
  }

  /**
   * Determines if there are suggestions available.
   */
  public boolean hasSuggestions() {
    return !nameUsagesSuggestions.isEmpty();
  }
}
