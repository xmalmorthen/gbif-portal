/*
 * Copyright 2011 Global Biodiversity Information Facility (GBIF) Licensed under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at
 * http://www.apache.org/licenses/LICENSE-2.0 Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,
 * either express or implied. See the License for the specific language governing permissions and limitations under the
 * License.
 */
package org.gbif.portal.action.dataset;

import org.gbif.api.model.checklistbank.DatasetMetrics;
import org.gbif.api.model.metrics.cube.OccurrenceCube;
import org.gbif.api.model.metrics.cube.ReadBuilder;
import org.gbif.api.model.registry.search.DatasetSearchParameter;
import org.gbif.api.model.registry.search.DatasetSearchRequest;
import org.gbif.api.model.registry.search.DatasetSearchResult;
import org.gbif.api.service.checklistbank.DatasetMetricsService;
import org.gbif.api.service.metrics.CubeService;
import org.gbif.api.service.registry.DatasetSearchService;
import org.gbif.api.service.registry.NetworkService;
import org.gbif.api.service.registry.OrganizationService;
import org.gbif.api.vocabulary.DatasetType;
import org.gbif.portal.action.BaseFacetedSearchAction;

import java.util.Map;
import java.util.UUID;

import com.google.common.base.Function;
import com.google.common.base.Strings;
import com.google.common.collect.Maps;
import com.google.inject.Inject;

public class SearchAction
  extends BaseFacetedSearchAction<DatasetSearchResult, DatasetSearchParameter, DatasetSearchRequest> {

  private static final long serialVersionUID = 1488419402277401976L;

  private OrganizationService orgService;
  private NetworkService networkService;
  private Function<String, String> getOrgTitle;
  private Function<String, String> getNetworkTitle;
  private CubeService occurrenceCube;
  private DatasetMetricsService checklistMetricsService;

  // Index of the record counts (occurrence or taxa)
  private Map<String, Long> recordCounts = Maps.newHashMap();

  @Inject
  public SearchAction(DatasetSearchService datasetSearchService, OrganizationService orgService,
    CubeService occurrenceCube, DatasetMetricsService checklistMetricsService, NetworkService networkService) {
    super(datasetSearchService, DatasetSearchParameter.class, new DatasetSearchRequest());
    this.orgService = orgService;
    this.networkService = networkService;
    this.occurrenceCube = occurrenceCube;
    this.checklistMetricsService = checklistMetricsService;
    initGetTitleFunctions();
  }

  /**
   * Initializes the getTitle functions
   */
  private void initGetTitleFunctions() {
    getOrgTitle = new Function<String, String>() {

      @Override
      public String apply(String key) {
        if (!Strings.isNullOrEmpty(key)) {
          try {
            return orgService.get(UUID.fromString(key)).getTitle();
          } catch (Exception e) {
          }
        }
        return null;
      }
    };

    getNetworkTitle = new Function<String, String>() {

      @Override
      public String apply(String key) {
        if (!Strings.isNullOrEmpty(key)) {
          try {
            return networkService.get(UUID.fromString(key)).getTitle();
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
    lookupFacetTitles(DatasetSearchParameter.NETWORK_ORIGIN, getNetworkTitle);

    // populate counts
    for (DatasetSearchResult dsr : getSearchResponse().getResults()) {
      if (DatasetType.OCCURRENCE == dsr.getType()) {
        UUID k = UUID.fromString(dsr.getKey());
        Long count = occurrenceCube.get(new ReadBuilder().at(OccurrenceCube.DATASET_KEY, k));
        recordCounts.put(dsr.getKey(), count);
      } else if (DatasetType.CHECKLIST == dsr.getType()) {
        DatasetMetrics metrics = checklistMetricsService.get(UUID.fromString(dsr.getKey()));
        if (metrics != null) {
          recordCounts.put(dsr.getKey(), Long.valueOf(metrics.getCountIndexed()));
        }
      }
      // load network titles
      if (dsr.getNetworkOfOriginKey() != null && !titles.containsKey(dsr.getNetworkOfOriginKey())) {
        try {
          titles.put(dsr.getNetworkOfOriginKey(), networkService.get(dsr.getNetworkOfOriginKey()).getTitle());
        } catch (Exception e) {
          LOG.error("Failed to load network title with key {}", dsr.getNetworkOfOriginKey());
          titles.put(dsr.getNetworkOfOriginKey(), null);
        }
      }
    }


    return SUCCESS;
  }

  public Map<String, Long> getRecordCounts() {
    return recordCounts;
  }
}
