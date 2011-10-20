/*
 * Copyright 2011 Global Biodiversity Information Facility (GBIF) Licensed under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at
 * http://www.apache.org/licenses/LICENSE-2.0 Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,
 * either express or implied. See the License for the specific language governing permissions and limitations under the
 * License.
 */
package org.gbif.portal.action.species;

import org.gbif.api.search.model.SearchRequest;
import org.gbif.api.search.model.SearchResponse;
import org.gbif.checklistbank.api.model.NameUsage;
import org.gbif.checklistbank.api.service.NameUsageSearchService;
import org.gbif.portal.action.BaseAction;
import static org.gbif.api.paging.PagingConstants.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.google.inject.Inject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * The action for all species search operations.
 */
public class SearchAction extends BaseAction {
  private static final Logger LOG = LoggerFactory.getLogger(SearchAction.class);

  private String q;
  private List<NameUsage> usages;

  @Inject
  private NameUsageSearchService nameUsageSearchService;

  @Override
  public String execute() {
    LOG.info("Species search of [{}]", q);
    SearchRequest req = new SearchRequest(DEFAULT_PARAM_OFFSET, DEFAULT_PARAM_LIMIT);
    Map<String, String> params = new HashMap<String, String>();
    params.put("q", q);//deafult query parameter
    req.setParameters(params);
    SearchResponse<NameUsage> results = nameUsageSearchService.search(req);
    Long count = results.getCount();
    this.usages = results.getResults(); //sets the results
    LOG.info("Species search of [{}] returned {} results", q, count);
    return SUCCESS;
  }

  public String getQ() {
    return q;
  }

  /**
   * @return the usages.
   */
  public List<NameUsage> getUsages() {
    return usages == null ? null : usages;
  }

  public void setQ(String q) {
    this.q = q;
  }
}
