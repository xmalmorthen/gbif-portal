/*
 * Copyright 2011 Global Biodiversity Information Facility (GBIF) Licensed under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at
 * http://www.apache.org/licenses/LICENSE-2.0 Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,
 * either express or implied. See the License for the specific language governing permissions and limitations under the
 * License.
 */
package org.gbif.portal.action.species;

import org.gbif.checklistbank.api.model.NameUsage;
import org.gbif.checklistbank.api.model.search.ChecklistBankFacetParameter;
import org.gbif.checklistbank.api.service.NameUsageSearchService;
import org.gbif.portal.action.BaseFacetedSearchAction;

import com.google.inject.Inject;

/**
 * The action for all species search operations.
 */
public class SearchAction extends BaseFacetedSearchAction<NameUsage<?>, ChecklistBankFacetParameter> {

  /**
   * 
   */
  private static final long serialVersionUID = -3736915206911951300L;

  @SuppressWarnings({"rawtypes", "unchecked"})
  @Inject
  public SearchAction(NameUsageSearchService nameUsageSearchService) {
    super(nameUsageSearchService, ChecklistBankFacetParameter.class);
  }
}
