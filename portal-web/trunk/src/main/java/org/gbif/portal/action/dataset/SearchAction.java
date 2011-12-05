/*
 * Copyright 2011 Global Biodiversity Information Facility (GBIF) Licensed under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at
 * http://www.apache.org/licenses/LICENSE-2.0 Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,
 * either express or implied. See the License for the specific language governing permissions and limitations under the
 * License.
 */
package org.gbif.portal.action.dataset;

import org.gbif.portal.action.BaseFacetedSearchAction;
import org.gbif.portal.model.FacetInstance;
import org.gbif.registry.api.model.search.DatasetSearchResult;
import org.gbif.registry.api.model.search.RegistryFacetParameter;
import org.gbif.registry.api.service.DatasetSearchService;

import java.util.List;
import java.util.Map;

import com.google.common.collect.HashMultimap;
import com.google.common.collect.Maps;
import com.google.common.collect.Multimap;
import com.google.inject.Inject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class SearchAction extends BaseFacetedSearchAction<DatasetSearchResult, RegistryFacetParameter> {

  private static final Logger LOG = LoggerFactory.getLogger(SearchAction.class);
  private static final long serialVersionUID = 1488419402277401976L;

  @Inject
  public SearchAction(DatasetSearchService<DatasetSearchResult> datasetSearchService) {
    super(datasetSearchService, RegistryFacetParameter.class);
  }

  @Override
  public String execute() {
    LOG.debug("Searching for datasets matching [{}]", this.getQ());

    super.execute();

    LOG.debug("Found [{}] matching datasets", searchResponse.getCount());
    return SUCCESS;
  }

  @Override
  public Map<Enum<RegistryFacetParameter>, List<FacetInstance>> getDefaultFacetsFilters() {
    return Maps.newHashMap();
  }

  @Override
  public Multimap<String, String> getRequestParameters() {
    return HashMultimap.create();
  }
}
