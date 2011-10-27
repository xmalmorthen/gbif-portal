/**
 * 
 */
package org.gbif.portal.action;

import org.gbif.api.paging.PagingRequest;
import org.gbif.api.paging.PagingResponse;

import static org.gbif.api.paging.PagingConstants.DEFAULT_PARAM_LIMIT;
import static org.gbif.api.paging.PagingConstants.DEFAULT_PARAM_OFFSET;


/**
 * @author fede
 */
public class BaseSearchAction<T> extends BaseAction {

  private PagingResponse<T> searchResponse;
  private PagingRequest searchRequest;
  private String q;

  /**
   * Default constructor
   */
  public BaseSearchAction() {
    super();
    this.searchRequest = new PagingRequest(DEFAULT_PARAM_OFFSET, DEFAULT_PARAM_LIMIT);
  }

  /**
   * @return the q
   */
  public String getQ() {
    return q;
  }

  /**
   * @return the searchRequest
   */
  public PagingRequest getSearchRequest() {
    return searchRequest;
  }


  /**
   * @return the searchResponse
   */
  public PagingResponse<T> getSearchResponse() {
    return searchResponse;
  }


  /**
   * @param q the q to set
   */
  public void setQ(String q) {
    this.q = q;
  }


  /**
   * @param searchRequest the searchRequest to set
   */
  public void setSearchRequest(PagingRequest searchRequest) {
    this.searchRequest = searchRequest;
  }


  /**
   * @param searchResponse the searchResponse to set
   */
  public void setSearchResponse(PagingResponse<T> searchResponse) {
    this.searchResponse = searchResponse;
  }

}
