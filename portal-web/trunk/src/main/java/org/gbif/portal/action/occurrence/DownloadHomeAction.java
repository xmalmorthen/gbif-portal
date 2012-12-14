package org.gbif.portal.action.occurrence;

import org.gbif.api.vocabulary.BasisOfRecord;
import org.gbif.portal.action.BaseAction;
import org.gbif.portal.action.occurrence.util.OccurrenceDownloadParameter;

import java.util.Enumeration;
import java.util.Map;

import com.google.common.base.Enums;
import com.google.common.collect.Maps;
import com.google.inject.Inject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class DownloadHomeAction extends BaseAction {

  private static final long serialVersionUID = 3653614424275432914L;
  private static final Logger LOG = LoggerFactory.getLogger(DownloadHomeAction.class);

  private final FiltersActionHelper filtersActionHelper;

  private Map<String, String[]> filters;

  @Inject
  public DownloadHomeAction(FiltersActionHelper filtersActionHelper) {
    this.filtersActionHelper = filtersActionHelper;
  }

  public BasisOfRecord[] getBasisOfRecords() {
    return BasisOfRecord.values();
  }

  public Map<String, String[]> getFilters() {
    if (filters == null) {
      filters = Maps.newHashMap();
      for (Enumeration<String> params = this.request.getParameterNames(); params.hasMoreElements();) {
        String param = params.nextElement();
        if (Enums.getIfPresent(OccurrenceDownloadParameter.class, param).isPresent()) {
          filters.put(param, this.request.getParameterValues(param));
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
