/*
 * Copyright 2011 Global Biodiversity Information Facility (GBIF) Licensed under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at
 * http://www.apache.org/licenses/LICENSE-2.0 Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,
 * either express or implied. See the License for the specific language governing permissions and limitations under the
 * License.
 */
package org.gbif.portal.action.dataset;

import org.gbif.api.paging.PagingRequest;
import org.gbif.checklistbank.api.model.Checklist;
import org.gbif.checklistbank.ws.client.ChecklistWsClient;
import org.gbif.portal.action.BaseAction;

import java.util.Collections;
import java.util.Comparator;
import java.util.List;

import com.google.inject.Inject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class SearchAction extends BaseAction {

  private static final Logger LOG = LoggerFactory.getLogger(SearchAction.class);

  // paging
  private long offset = 0;
  private int page_size = 20;

  // search
  private String q;
  private List<?> datasets;

  @Inject
  private ChecklistWsClient checklistClient;

  @Override
  public String execute() {
    LOG.debug("Searching for datasets matching [{}]", q);
    datasets = checklistClient.list(new PagingRequest(offset, page_size));
    LOG.debug("Found [{}] matching datasets", datasets == null ? 0 : datasets.size());

    // TODO: This sort is temporary to just show the list in an ordered fashion
    Collections.sort(datasets, new Comparator<Object>() {

      public int compare(Object o1, Object o2) {
        Checklist c1 = (Checklist) o1;
        Checklist c2 = (Checklist) o2;
        return c1.getName().compareToIgnoreCase(c2.getName());
      }
    });

    // using static just to make sure all layout is working properly
    if (q == null || q.isEmpty()) {
      q = "NoSearchTerm";
    }

    return SUCCESS;
  }

  public List<?> getDatasets() {
    return datasets == null ? null : datasets;
  }

  public String getQ() {
    return q;
  }

  public void setQ(String q) {
    this.q = q;
  }

  /**
   * @param page_size the page_size to set.
   */
  public void setPage_size(int page_size) {
    this.page_size = page_size;
  }

  /**
   * @param offset the offset to set.
   */
  public void setOffset(long offset) {
    this.offset = offset;
  }
}
