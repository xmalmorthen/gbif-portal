/*
 * Copyright 2011 Global Biodiversity Information Facility (GBIF) Licensed under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at
 * http://www.apache.org/licenses/LICENSE-2.0 Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,
 * either express or implied. See the License for the specific language governing permissions and limitations under the
 * License.
 */
package org.gbif.portal.action.dataset;

import org.gbif.api.model.registry.search.DatasetSearchParameter;
import org.gbif.api.model.registry.search.DatasetSearchRequest;
import org.gbif.api.model.registry.search.DatasetSearchResult;
import org.gbif.api.service.registry.DatasetSearchService;
import org.gbif.api.service.registry.OrganizationService;
import org.gbif.portal.action.BaseFacetedSearchAction;

import java.util.UUID;

import com.google.common.base.Function;
import com.google.common.base.Strings;
import com.google.inject.Inject;

public class SearchAction
  extends BaseFacetedSearchAction<DatasetSearchResult, DatasetSearchParameter, DatasetSearchRequest> {

  private static final long serialVersionUID = 1488419402277401976L;

  private OrganizationService orgService;
  private Function<String, String> getOrgTitle;

  @Inject
  public SearchAction(DatasetSearchService datasetSearchService, OrganizationService orgService) {
    super(datasetSearchService, DatasetSearchParameter.class, new DatasetSearchRequest());
    this.orgService = orgService;
    initGetTitleFunctions();
  }

  /**
   * Initializes the getTitle functions
   */
  private void initGetTitleFunctions() {
    getOrgTitle = new Function<String, String>() {

      @Override
      public String apply(String key) {
        if (Strings.emptyToNull(key) != null) {
          try {
            return orgService.get(UUID.fromString(key)).getTitle();
          } catch (Exception e) {
          }
        }
        return null;
      }
    };
  }

  @Override
  public String execute() {

    super.execute();

    // replace organisation keys with real names
    lookupFacetTitles(DatasetSearchParameter.HOSTING_ORG, getOrgTitle);
    lookupFacetTitles(DatasetSearchParameter.OWNING_ORG, getOrgTitle);

    return SUCCESS;
  }

}
