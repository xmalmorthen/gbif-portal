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

import org.gbif.api.model.common.paging.PagingRequest;
import org.gbif.api.model.common.paging.PagingResponse;
import org.gbif.api.model.common.search.SearchRequest;
import org.gbif.api.model.common.search.SearchResponse;

import com.google.common.base.Strings;
import org.apache.commons.lang3.StringUtils;

import static org.gbif.api.model.common.paging.PagingConstants.DEFAULT_PARAM_LIMIT;
import static org.gbif.api.model.common.paging.PagingConstants.DEFAULT_PARAM_OFFSET;


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
  private static final int DEFAULT_HIGHLIGHT_TEXT_LENGTH = 110;

  public static final String HL_PRE = "<em class=\"gbifHl\">";

  public static final String HL_POST = "</em>";

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
   * Takes a highlighted text and trimmed it to show the first highlighted term.
   * The text is found using the HL_PRE and HL_POST tags.
   * Ensure that at least the whole term is shown or else MAX_LONG_HL_FIELD are displayed.
   * 
   * @param text highlighted text to be trimmed.
   * @return a trimmed version of the highlighted text
   */
  public static String getHighlightedText(String text) {
    return getHighlightedText(text, DEFAULT_HIGHLIGHT_TEXT_LENGTH);
  }

  public static String getHighlightedText(String text, final int maxLength) {
    final int firstHlBeginTag = text.indexOf(HL_PRE);
    final int firstHlEndTag = text.indexOf(HL_POST) + HL_POST.length();
    final int hlTextSize = firstHlEndTag - firstHlBeginTag;
    // highlighted text larger than max length - return it all to keep highlighting tags intact
    if (hlTextSize > maxLength) {
      return text.substring(firstHlBeginTag, firstHlEndTag);
    }
    // no highlighted text, return first bit
    if (firstHlBeginTag < 0 || firstHlEndTag < 0) {
      return StringUtils.abbreviate(text, 0, maxLength);
    }
    int sizeBefore = (maxLength - hlTextSize) / 3;
    int start = Math.max(0, firstHlBeginTag - sizeBefore);
    return StringUtils.abbreviate(text, start, maxLength);
  }

  /**
   * The input search pattern used to issue a search operation.
   * 
   * @return the q, input search pattern defaulting to "" if none is provided
   */
  public String getQ() {
    // To enable simple linking without a query as per http://dev.gbif.org/issues/browse/POR-274
    return (q == null) ? "" : q;
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
