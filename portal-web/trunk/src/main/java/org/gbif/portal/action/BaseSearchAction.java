/*
 * Copyright 2011 Global Biodiversity Information Facility (GBIF)
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * http://www.apache.org/licenses/LICENSE-2.0
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 */
package org.gbif.portal.action;

import org.gbif.api.paging.PagingRequest;
import org.gbif.api.paging.PagingResponse;
import org.gbif.api.search.model.SearchRequest;
import org.gbif.api.search.model.SearchResponse;

import com.google.common.base.Strings;

import static org.gbif.api.paging.PagingConstants.DEFAULT_PARAM_LIMIT;
import static org.gbif.api.paging.PagingConstants.DEFAULT_PARAM_OFFSET;


/**
 * Class that encapsulates the basic functionality of free text search and paginated navigation.
 * The class builds a {@link PagingRequest} at creation time, the {@link PagingResponse} not use directly by this
 * class, it should be used for specific instances.
 *
 * @param <T> the content type of the results
 */
public abstract class BaseSearchAction<T> extends BaseAction {

  /**
   * Generated serialVersionUID
   */
  private static final long serialVersionUID = -3731894129684841108L;
  protected SearchResponse<T> searchResponse;
  protected SearchRequest searchRequest;
  protected String q;

  /**
   * Default constructor
   */
  public BaseSearchAction() {
    // Initialize the request
    this.searchRequest = new SearchRequest(DEFAULT_PARAM_OFFSET, DEFAULT_PARAM_LIMIT);
  }

  /**
   * The input search pattern used to issue a search operation.
   *
   * @return the q, input search pattern
   */
  public String getQ() {
    return q;
  }

  /**
   * Response (containing the list of results) of the request issued.
   *
   * @return the searchResponse
   *
   * @see PagingResponse
   */
  public SearchResponse<T> getSearchResponse() {
    return searchResponse;
  }

  /**
   * @param offset the offset to set
   *
   * @see PagingRequest#setOffset(long)
   */
  public void setOffset(long offset) {
    this.searchRequest.setOffset(offset);
  }


  /**
   * @param q the input search pattern to set
   */
  public void setQ(String q) {
    this.q = Strings.nullToEmpty(q).trim();
  }


}
