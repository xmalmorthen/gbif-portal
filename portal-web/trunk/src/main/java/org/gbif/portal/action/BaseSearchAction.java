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
import org.gbif.api.search.SearchRequest;
import org.gbif.api.search.SearchResponse;
import org.gbif.common.search.util.SearchConstants;

import com.google.common.base.Strings;

import static org.gbif.api.paging.PagingConstants.DEFAULT_PARAM_LIMIT;
import static org.gbif.api.paging.PagingConstants.DEFAULT_PARAM_OFFSET;
import static org.gbif.common.search.util.SearchConstants.HL_POST;
import static org.gbif.common.search.util.SearchConstants.HL_PRE;


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

  /**
   * Maximum # of characters shown in a highlighted field.
   */
  private static final int MAX_LONG_HL_FIELD = 100;

  /**
   * This string is added before and after a highlighted text whose length is greater than MAX_LONG_HL_FIELD.
   */
  private static final String MORE_TEXT_MARKER = "...";

  /**
   * Takes a highlighted text and trimmed it to show the first highlighted term.
   * The text is found using the {@link SearchConstants#HL_PRE} and {@link SearchConstants#HL_POST} tags.
   * Ensure that at least the whole term is shown or else MAX_LONG_HL_FIELD are displayed.
   * 
   * @param text highlighted text to be trimmed.
   * @return a trimmed version of the highlighted text
   */
  public static String getHighlightedText(String text) {
    String trimmedHLText = "";
    int firstHlBeginTag = text.indexOf(HL_PRE);
    int firstHlEndTag = text.indexOf(HL_POST) + HL_POST.length();
    int newSize = firstHlEndTag - firstHlBeginTag;
    if (firstHlBeginTag >= 0 && firstHlEndTag >= 0) {
      int textLenght = text.length();
      firstHlEndTag =
        Math.min(firstHlEndTag + ((newSize > MAX_LONG_HL_FIELD) ? 0 : (MAX_LONG_HL_FIELD - newSize)), textLenght);
      trimmedHLText = text.substring(firstHlBeginTag, firstHlEndTag);
      if (firstHlBeginTag > 0) {
        trimmedHLText = MORE_TEXT_MARKER + trimmedHLText;
      }
      if (firstHlEndTag < textLenght) {
        trimmedHLText = trimmedHLText + MORE_TEXT_MARKER;
      }
    }
    return trimmedHLText;
  }

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
   * @see PagingResponse
   */
  public SearchResponse<T> getSearchResponse() {
    return searchResponse;
  }


  /**
   * @param offset the offset to set
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
