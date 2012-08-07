package org.gbif.portal.action.occurrence;

import org.gbif.api.paging.PagingRequest;
import org.gbif.api.paging.PagingResponse;
import org.gbif.occurrencestore.api.model.Occurrence;
import org.gbif.occurrencestore.api.service.OccurrenceSearchService;
import org.gbif.portal.action.BaseAction;

import com.google.common.base.Strings;
import com.google.inject.Inject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import static org.gbif.api.paging.PagingConstants.DEFAULT_PARAM_LIMIT;
import static org.gbif.api.paging.PagingConstants.DEFAULT_PARAM_OFFSET;

/**
 * Search action class for occurrence search page.
 */
public class SearchAction extends BaseAction {

  private static final long serialVersionUID = 4064512946598688405L;

  private static final Logger LOG = LoggerFactory.getLogger(SearchAction.class);

  private final OccurrenceSearchService occurrenceSearchService;

  private String key;

  private String catalogueNumber;

  private String longitude;

  private String latitude;

  private String year;

  private String month;

  private String nubKey;

  private final PagingRequest pagingRequest;

  private PagingResponse<Occurrence> searchResponse;

  @Inject
  public SearchAction(OccurrenceSearchService occurrenceSearchService) {
    this.pagingRequest = new PagingRequest(DEFAULT_PARAM_OFFSET, DEFAULT_PARAM_LIMIT);
    this.occurrenceSearchService = occurrenceSearchService;
    LOG.info("Action built!");
  }

  @Override
  public String execute() {
    LOG.debug(
      "Exceuting query, year {}, month {}, latitude {}, longitude {}, catalogue number {}, nubKey {}",
      new Object[] {year, month, latitude, longitude, catalogueNumber, nubKey});
    searchResponse =
      occurrenceSearchService.listOccurrences(getIntValueOrNull(year), getIntValueOrNull(month),
        getFloatValueOrNull(latitude), getFloatValueOrNull(longitude), Strings.emptyToNull(catalogueNumber),
        getIntValueOrNull(nubKey), pagingRequest);
    return SUCCESS;
  }

  /**
   * @return the catalogueNumber
   */
  public String getCatalogueNumber() {
    return catalogueNumber;
  }

  /**
   * @return the key
   */
  public String getKey() {
    return key;
  }

  /**
   * @return the latitude
   */
  public String getLatitude() {
    return latitude;
  }


  /**
   * @return the longitude
   */
  public String getLongitude() {
    return longitude;
  }


  /**
   * @return the month
   */
  public String getMonth() {
    return month;
  }


  /**
   * @return the nubKey
   */
  public String getNubKey() {
    return nubKey;
  }


  /**
   * Gets the offset value.
   */
  public long getOffset() {
    return pagingRequest.getOffset();
  }


  /**
   * @return the response
   */
  public PagingResponse<Occurrence> getSearchResponse() {
    return searchResponse;
  }


  /**
   * @return the year
   */
  public String getYear() {
    return year;
  }


  /**
   * @param catalogueNumber the catalogueNumber to set
   */
  public void setCatalogueNumber(String catalogueNumber) {
    this.catalogueNumber = catalogueNumber;
  }


  /**
   * @param key the key to set
   */
  public void setKey(String key) {
    this.key = key;
  }


  /**
   * @param latitude the latitude to set
   */
  public void setLatitude(String latitude) {
    this.latitude = latitude;
  }


  /**
   * @param longitude the longitude to set
   */
  public void setLongitude(String longitude) {
    this.longitude = longitude;
  }


  /**
   * @param month the month to set
   */
  public void setMonth(String month) {
    this.month = month;
  }


  /**
   * @param nubKey the nubKey to set
   */
  public void setNubKey(String nubKey) {
    this.nubKey = nubKey;
  }


  /**
   * @param offset the offset to set
   * @see PagingRequest#setOffset(long)
   */
  public void setOffset(long offset) {
    pagingRequest.setOffset(offset);
  }

  /**
   * @param year the year to set
   */
  public void setYear(String year) {
    this.year = year;
  }

  /**
   * Converts the value into float.
   * Returns null if value is null or empty.
   */
  private Float getFloatValueOrNull(String value) {
    if (!Strings.isNullOrEmpty(value)) {
      return Float.parseFloat(value);
    }
    return null;
  }

  /**
   * Converts the value into integer.
   * Returns null if value is null or empty.
   */
  private Integer getIntValueOrNull(String value) {
    if (!Strings.isNullOrEmpty(value)) {
      return Integer.parseInt(value);
    }
    return null;
  }

}
