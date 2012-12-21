package org.gbif.portal.action.occurrence;

import org.gbif.api.model.occurrence.search.OccurrenceSearchParameter;
import org.gbif.api.util.VocabularyUtils;
import org.gbif.api.vocabulary.BasisOfRecord;
import org.gbif.portal.action.BaseAction;

import java.util.Enumeration;
import java.util.Map;

import com.google.common.collect.Maps;
import com.google.inject.Inject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class DownloadHomeAction extends BaseAction {

  private static final long serialVersionUID = 3653614424275432914L;
  private static final Logger LOG = LoggerFactory.getLogger(DownloadHomeAction.class);

  private final FiltersActionHelper filtersActionHelper;

  private Map<OccurrenceSearchParameter, String[]> filters;

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
    filtersActionHelper.validateSearchParameters(this, this.request);
    return SUCCESS;
  }

  /**
   * List the value of BasisOfRecord enum.
   */
  public BasisOfRecord[] getBasisOfRecords() {
    return BasisOfRecord.values();
  }

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
   * Gets the displayable value of filter parameter.
   */
  public String getFilterTitle(String filterKey, String filterValue) {
    return this.filtersActionHelper.getFilterTitle(filterKey, filterValue);
  }
}
