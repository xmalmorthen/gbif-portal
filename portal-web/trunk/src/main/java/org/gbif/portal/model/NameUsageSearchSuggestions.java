package org.gbif.portal.model;

import org.gbif.api.model.checklistbank.search.NameUsageSearchResult;

import java.util.List;
import java.util.Map;

import com.google.common.collect.Maps;

/**
 * Utility class that holds the list of suggestions and replacements done for a scientific name search.
 */
public class NameUsageSearchSuggestions {

  private Map<String, List<NameUsageSearchResult>> nameUsagesSuggestions;


  private Map<String, NameUsageSearchResult> nameUsagesReplacements;


  public NameUsageSearchSuggestions() {
    nameUsagesSuggestions = Maps.newHashMap();
    nameUsagesReplacements = Maps.newHashMap();
  }


  /**
   * @return the nameUsagesReplacements
   */
  public Map<String, NameUsageSearchResult> getNameUsagesReplacements() {
    return nameUsagesReplacements;
  }


  /**
   * @return the nameUsagesSuggestions
   */
  public Map<String, List<NameUsageSearchResult>> getNameUsagesSuggestions() {
    return nameUsagesSuggestions;
  }


  /**
   * Determines if there are replacements available.
   */
  public boolean hasReplacements() {
    return !nameUsagesReplacements.isEmpty();
  }


  /**
   * Determines if there are suggestions available.
   */
  public boolean hasSuggestions() {
    return !nameUsagesSuggestions.isEmpty();
  }

  /**
   * @param nameUsagesReplacements the nameUsagesReplacements to set
   */
  public void setNameUsagesReplacements(Map<String, NameUsageSearchResult> nameUsagesReplacements) {
    this.nameUsagesReplacements = nameUsagesReplacements;
  }

  /**
   * @param nameUsagesSuggestions the nameUsagesSuggestions to set
   */
  public void setNameUsagesSuggestions(Map<String, List<NameUsageSearchResult>> nameUsagesSuggestions) {
    this.nameUsagesSuggestions = nameUsagesSuggestions;
  }

}
