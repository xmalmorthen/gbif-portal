/*
 * Copyright 2011 Global Biodiversity Information Facility (GBIF) Licensed under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at
 * http://www.apache.org/licenses/LICENSE-2.0 Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,
 * either express or implied. See the License for the specific language governing permissions and limitations under the
 * License.
 */
package org.gbif.portal.action.user;

import org.gbif.api.model.common.paging.PagingRequest;
import org.gbif.api.model.common.paging.PagingResponse;
import org.gbif.api.model.occurrence.Download;
import org.gbif.api.model.occurrence.predicate.Predicate;
import org.gbif.api.model.occurrence.search.OccurrenceSearchParameter;
import org.gbif.api.service.checklistbank.NameUsageService;
import org.gbif.api.service.occurrence.DownloadService;
import org.gbif.api.service.registry2.DatasetService;
import org.gbif.portal.action.BaseAction;
import org.gbif.portal.action.occurrence.util.HumanFilterBuilder;
import org.gbif.portal.action.occurrence.util.QueryParameterFilterBuilder;

import java.util.LinkedList;
import java.util.Map;

import com.google.common.base.Strings;
import com.google.inject.Inject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Manages user downloads. Default action lists a page of downloads,
 * the cancel method can be used to cancel a single download and then return the list again.
 */
public class DownloadsAction extends BaseAction {
  private static Logger LOG = LoggerFactory.getLogger(DownloadsAction.class);

  private String key;
  private PagingResponse<Download> page;
  private long offset = 0;
  @Inject
  private DownloadService downloadService;
  @Inject
  private NameUsageService usageService;
  @Inject
  private DatasetService datasetService;

  @Override
  public String execute() throws Exception {
    // never null, guaranteed by the LoginInterceptor stack
    page = downloadService.list(getCurrentUser().getUserName(), new PagingRequest(offset, 25));
    return SUCCESS;
  }

  public String cancel () throws Exception {
    if (!Strings.isNullOrEmpty(key)) {
      downloadService.delete(key);
    }
    // to be used via POST/REDIRECT/GET
    return SUCCESS;
  }

  public Map<OccurrenceSearchParameter, LinkedList<String>> getHumanFilter(Predicate p) {
    try {
      // not thread safe!
      HumanFilterBuilder builder = new  HumanFilterBuilder(this, datasetService, usageService);
      return builder.humanFilter(p);

    } catch (IllegalArgumentException e) {
      LOG.warn("Cannot create human representation for predicate " + p);
      return null;
    }
  }

  public String getQueryParams(Predicate p) {
    try {
      // not thread safe!
      QueryParameterFilterBuilder builder = new QueryParameterFilterBuilder();
      return builder.queryFilter(p);

    } catch (IllegalArgumentException e) {
      LOG.warn("Cannot create query parameter representation for predicate " + p);
      return null;
    }
  }



  public void setKey(String key) {
    this.key = key;
  }

  public void setOffset(long offset) {
    this.offset = offset;
  }

  public String getKey() {
    return key;
  }

  public PagingResponse<Download> getPage() {
    return page;
  }
}
