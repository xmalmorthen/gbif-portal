/*
 * Copyright 2011 Global Biodiversity Information Facility (GBIF) Licensed under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at
 * http://www.apache.org/licenses/LICENSE-2.0 Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,
 * either express or implied. See the License for the specific language governing permissions and limitations under the
 * License.
 */
package org.gbif.portal.action.species;

import org.gbif.checklistbank.api.model.search.ChecklistBankFacetParameter;
import org.gbif.checklistbank.api.model.search.NameUsageSearchResult;
import org.gbif.checklistbank.api.service.NameUsageSearchService;
import org.gbif.portal.action.BaseFacetedSearchAction;

import java.util.HashMap;
import java.util.Map;

import com.google.common.collect.HashMultimap;
import com.google.common.collect.Multimap;
import com.google.inject.Inject;

/**
 * The action for all species search operations.
 */
public class SearchAction extends BaseFacetedSearchAction<NameUsageSearchResult, ChecklistBankFacetParameter> {

  private static final String CHECKLIST_KEY_PARAM = "checklistKey";

  private static final String NUB_KEY_PARAM = "nubKey";

  private static final String GBIF_NUB_CHK_TITLE = "GBIF Taxonomic Backbone";

  /**
   * 
   */
  private static final long serialVersionUID = -3736915206911951300L;

  private static String ALL = "all";

  private Integer nubKey;

  private String checklistKey;

  @SuppressWarnings({"rawtypes", "unchecked"})
  @Inject
  public SearchAction(NameUsageSearchService nameUsageSearchService) {
    super(nameUsageSearchService, ChecklistBankFacetParameter.class);
  }

  @Override
  public String execute() {
    if (this.nubKey != null) {
      this.setInitDefault(false);
    }
    return super.execute();
  }

  /**
   * @return the checklistKey
   */
  public String getChecklistKey() {
    return checklistKey;
  }


  /*
   * (non-Javadoc)
   * @see org.gbif.portal.action.BaseFacetedSearchAction#getDefaultFacetsFilters()
   */
  @Override
  public Map<String, String[]> getDefaultFacetsFilters() {
    Map<String, String[]> map = new HashMap<String, String[]>();
    map.put(ChecklistBankFacetParameter.CHECKLIST.name(), new String[] {GBIF_NUB_CHK_TITLE});
    return map;
  }


  /**
   * @return the nubKey
   */
  public Integer getNubKey() {
    return nubKey;
  }

  /*
   * (non-Javadoc)
   * @see org.gbif.portal.action.BaseFacetedSearchAction#getRequestParameters()
   */
  @Override
  public Multimap<String, String> getRequestParameters() {
    Multimap<String, String> params = HashMultimap.create();
    // if set nubKet or checklistKey parameters, the initDefault flag is set to false
    if (this.nubKey != null) {
      params.put(NUB_KEY_PARAM, this.nubKey.toString());
      this.setInitDefault(false);
    }
    if (this.checklistKey != null) {
      // If checklistKey = "ALL" the Checklist facet should be removed to avoid filtering
      if (this.checklistKey.equals(ALL)) {
        if (this.getFacets() != null) {
          this.getFacets().remove(ChecklistBankFacetParameter.CHECKLIST.name());
        }
      } else {
        params.put(CHECKLIST_KEY_PARAM, this.checklistKey);
      }
      this.setInitDefault(false);
    }
    return params;
  }


  /**
   * Request parameter for filtering results by checklistKey.
   * 
   * @param checklistKey the checklistKey to set
   */
  public void setChecklistKey(String checklistKey) {
    this.checklistKey = checklistKey;
  }


  /**
   * Request parameter for filtering results by nubKey.
   * 
   * @param nubKey the nubKey to set
   */
  public void setNubKey(Integer nubKey) {
    this.nubKey = nubKey;
  }


}
