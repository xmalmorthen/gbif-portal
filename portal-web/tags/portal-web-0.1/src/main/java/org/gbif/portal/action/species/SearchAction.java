/*
 * Copyright 2011 Global Biodiversity Information Facility (GBIF) Licensed under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at
 * http://www.apache.org/licenses/LICENSE-2.0 Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,
 * either express or implied. See the License for the specific language governing permissions and limitations under the
 * License.
 */
package org.gbif.portal.action.species;

import org.gbif.api.model.vocabulary.Rank;
import org.gbif.api.model.vocabulary.ThreatStatus;
import org.gbif.checklistbank.api.Constants;
import org.gbif.checklistbank.api.model.search.NameUsageFacetParameter;
import org.gbif.checklistbank.api.model.search.NameUsageSearchResult;
import org.gbif.checklistbank.api.model.vocabulary.TaxonomicStatus;
import org.gbif.checklistbank.api.service.NameUsageSearchService;
import org.gbif.checklistbank.api.service.NameUsageService;
import org.gbif.portal.action.BaseFacetedSearchAction;
import org.gbif.registry.api.service.DatasetService;

import java.util.UUID;

import com.google.common.base.Function;
import com.google.common.base.Strings;
import com.google.common.collect.HashMultimap;
import com.google.common.collect.Multimap;
import com.google.inject.Inject;

/**
 * The action for all species search operations.
 */
public class SearchAction extends BaseFacetedSearchAction<NameUsageSearchResult, NameUsageFacetParameter> {

  private static final String CHECKLIST_KEY_PARAM = "checklistKey";
  private static final String NUB_KEY_PARAM = "nubKey";
  private static final long serialVersionUID = -3736915206911951300L;

  private Integer nubKey;

  // injected
  private final NameUsageService usageService;
  private final DatasetService checklistService;

  private Function<String, String> getChecklistTitle;
  private Function<String, String> getHigherTaxaTitle;
  private Function<String, String> getBooleanTitle;
  private Function<String, String> getTaxStatusTitle;
  private Function<String, String> getRankTitle;
  private Function<String, String> getThreatStatusTitle;

  @Inject
  public SearchAction(NameUsageSearchService nameUsageSearchService, NameUsageService usageService,
    DatasetService checklistService) {
    super(nameUsageSearchService, NameUsageFacetParameter.class);
    this.usageService = usageService;
    this.checklistService = checklistService;
    initGetTitleFunctions();
  }

  @Override
  public String execute() {
    searchRequest.setMultiSelectFacets(true);
    // Turn off highlighting for empty query strings
    searchRequest.setHighlight(!getQ().isEmpty());

    super.execute();

    // replace higher taxon ids in facets with real names
    lookupFacetTitles(NameUsageFacetParameter.HIGHERTAXON, getHigherTaxaTitle);

    // replace checklist key with labels
    lookupFacetTitles(NameUsageFacetParameter.CHECKLIST, getChecklistTitle);

    // replace taxonomic status keys with labels
    lookupFacetTitles(NameUsageFacetParameter.TAXSTATUS, getTaxStatusTitle);

    // replace rank keys with labels
    lookupFacetTitles(NameUsageFacetParameter.RANK, getRankTitle);

    // replace extinct boolean values
    lookupFacetTitles(NameUsageFacetParameter.EXTINCT, getBooleanTitle);

    // replace marine boolean values
    lookupFacetTitles(NameUsageFacetParameter.MARINE, getBooleanTitle);

    // replace threat status keys values
    lookupFacetTitles(NameUsageFacetParameter.THREAT, getThreatStatusTitle);

    return SUCCESS;
  }

  /**
   * @return the nubKey
   */
  public Integer getNubKey() {
    return nubKey;
  }

  @Override
  public Multimap<String, String> getRequestParameters() {
    Multimap<String, String> params = HashMultimap.create();
    if (nubKey != null) {
      params.put(NUB_KEY_PARAM, nubKey.toString());
    }
    return params;
  }

  /**
   * @return true if the checklist facet filter contains a single checklist only.
   */
  public boolean getShowAccordingTo() {
    return getFacets() == null || !getFacets().containsKey(NameUsageFacetParameter.CHECKLIST)
           || getFacets().get(NameUsageFacetParameter.CHECKLIST).size() != 1;
  }

  /**
   * Initializes the getTitle* functions: getChecklistTitle and getHigherTaxaTitle.
   * Because we need the non static resource bundle lookup method getText() these methods
   * unfortuantely cant be static ones and are created here instead for every action.
   */
  private void initGetTitleFunctions() {
    getChecklistTitle = new Function<String, String>() {

      @Override
      public String apply(String name) {
        if (Strings.emptyToNull(name) == null) {
          return null;
        }
        return checklistService.get(UUID.fromString(name)).getTitle();
      }
    };

    getHigherTaxaTitle = new Function<String, String>() {

      @Override
      public String apply(String name) {
        if (Strings.emptyToNull(name) == null) {
          return null;
        }
        return usageService.get(Integer.valueOf(name), null).getCanonicalOrScientificName();
      }
    };

    getBooleanTitle = new Function<String, String>() {

      @Override
      public String apply(String name) {
        if (Strings.emptyToNull(name) == null) {
          return null;
        }
        return getText("enum.boolean." + name.toLowerCase());
      }
    };

    getRankTitle = new Function<String, String>() {

      @Override
      public String apply(String id) {
        if (Strings.emptyToNull(id) == null) {
          return null;
        }
        // this is the ordinal, replace with enum
        Rank status = Rank.values()[Integer.parseInt(id)];
        if (status != null) {
          return getText("enum.rank." + status.name());
        }
        return null;
      }
    };

    getTaxStatusTitle = new Function<String, String>() {

      @Override
      public String apply(String id) {
        if (Strings.emptyToNull(id) == null) {
          return null;
        }
        // this is the ordinal, replace with enum
        TaxonomicStatus status = TaxonomicStatus.values()[Integer.parseInt(id)];
        if (status != null) {
          return getText("enum.taxstatus." + status.name());
        }
        return null;
      }
    };

    getThreatStatusTitle = new Function<String, String>() {

      @Override
      public String apply(String id) {
        if (Strings.emptyToNull(id) == null) {
          return null;
        }
        // this is the ordinal, replace with enum
        ThreatStatus status = ThreatStatus.values()[Integer.parseInt(id)];
        if (status != null) {
          return getText("enum.threatstatus." + status.name());
        }
        return null;
      }
    };

  }


  /**
   * Request parameter for filtering results by nubKey.
   *
   * @param nubKey the nubKey to set
   */
  public void setNubKey(Integer nubKey) {
    this.nubKey = nubKey;
  }

  @Override
  protected String translateFacetValue(Enum<NameUsageFacetParameter> facet, String value) {
    if (NameUsageFacetParameter.CHECKLIST.equals(facet) && value != null) {
      return value.equalsIgnoreCase("nub") ? Constants.NUB_TAXONOMY_KEY.toString() : value;
    }
    return value;
  }
}
