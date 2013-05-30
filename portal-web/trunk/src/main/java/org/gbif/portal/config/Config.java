package org.gbif.portal.config;

import org.gbif.utils.file.properties.PropertiesUtil;

import java.io.IOException;
import java.net.URI;
import java.util.Properties;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import static org.gbif.ws.paths.OccurrencePaths.CATALOG_NUMBER_PATH;
import static org.gbif.ws.paths.OccurrencePaths.COLLECTION_CODE_PATH;
import static org.gbif.ws.paths.OccurrencePaths.COLLECTOR_NAME_PATH;
import static org.gbif.ws.paths.OccurrencePaths.INSTITUTION_CODE_PATH;
import static org.gbif.ws.paths.OccurrencePaths.OCC_SEARCH_PATH;

/**
 * Simple configuration bean to pass the guice binded properties on to the rendering layer.
 * When adding or modifying entries please also adjust the decorator default.ftl.
 */
public class Config {

  private static final Logger LOG = LoggerFactory.getLogger(Config.class);

  public static final String APPLICATION_PROPERTIES = "application.properties";
  private static final String STRUTS_PROPERTIES = "struts.properties";

  public static final String SERVERNAME = "servername";
  public static final String SUGGEST_PATH = "suggest";

  private String drupal;
  private String drupalCookieName;
  private String serverName;
  private boolean includeContext;
  private String tileServerBaseUrl;
  private String wsClb;
  private String wsClbSearch;
  private String wsClbSuggest;
  private String wsOcc;
  private String wsOccCatalogNumberSearch;
  private String wsOccCollectorNameSearch;
  private String wsOccSearch;
  private String wsOccDownload;
  private String wsReg;
  private String wsRegSearch;
  private String wsRegSuggest;
  private String wsMetrics;
  private String wsOccCollectionCodeSearch;
  private String wsOccInstitutionCodeSearch;
  private String wsImageCache;



  /**
   * To safeguard against configuration issues, this ensures that trailing slashes exist where required.
   * A future enhancement would be for those not to be required by the depending components, but currently
   * this is the state of affairs. This does at least help guard against incorrect use in the property
   * files.
   */
  public static Config buildFromProperties() {
    Config cfg = new Config();
    try {
      Properties properties = PropertiesUtil.loadProperties(APPLICATION_PROPERTIES);
      properties.putAll(PropertiesUtil.loadProperties(STRUTS_PROPERTIES));

      // prefer system variable if existing, required (e.g.) by selenim
      try {
        URI uri = URI.create(System.getProperty(SERVERNAME));
        cfg.serverName = uri.toString();
        LOG.debug("Using servername system variable");
      } catch (Exception e) {
        cfg.serverName = getPropertyUrl(properties, SERVERNAME, false);
      }
      LOG.debug("Setting servername to {}", cfg.serverName);

      cfg.drupal = getPropertyUrl(properties, "drupal.url", false);
      cfg.drupalCookieName = properties.getProperty("drupal.cookiename");
      cfg.wsClb = getPropertyUrl(properties, "checklistbank.ws.url", true);
      cfg.wsClbSearch = getPropertyUrl(properties, "checklistbank.search.ws.url", true);
      cfg.wsClbSuggest = cfg.wsClbSearch + SUGGEST_PATH;
      cfg.wsReg = getPropertyUrl(properties, "registry.ws.url", true);
      cfg.wsRegSearch = cfg.wsReg + "search/";
      cfg.wsRegSuggest = cfg.wsRegSearch + SUGGEST_PATH;
      cfg.wsOcc = getPropertyUrl(properties, "occurrence.ws.url", true);
      cfg.wsOccSearch = cfg.wsOcc + OCC_SEARCH_PATH;
      cfg.wsOccDownload = getPropertyUrl(properties, "occurrencedownload.ws.url", true);
      cfg.wsMetrics = getPropertyUrl(properties, "metrics.ws.url", true);
      cfg.wsOccCatalogNumberSearch = cfg.wsOcc + OCC_SEARCH_PATH + '/' + CATALOG_NUMBER_PATH;
      cfg.wsOccCollectorNameSearch = cfg.wsOcc + OCC_SEARCH_PATH + '/' + COLLECTOR_NAME_PATH;
      cfg.wsOccCollectionCodeSearch = cfg.wsOcc + OCC_SEARCH_PATH + '/' + COLLECTION_CODE_PATH;
      cfg.wsOccInstitutionCodeSearch = cfg.wsOcc + OCC_SEARCH_PATH + '/' + INSTITUTION_CODE_PATH;
      cfg.tileServerBaseUrl = getPropertyUrl(properties, "tile-server.url", false);
      cfg.wsImageCache = getPropertyUrl(properties, "image-cache.url", false);
      cfg.includeContext = Boolean.parseBoolean(properties.getProperty("struts.url.includeContext"));

    } catch (IOException e) {
      throw new ConfigurationException("application.properties cannot be read", e);
    }
    return cfg;
  }

  /**
   * Reads the property as a URL, and will optionally force a trailing slash as required by
   * http://dev.gbif.org/issues/browse/POR-260
   */
  private static String getPropertyUrl(Properties properties, String propName, boolean forceTrailingSlash) {
    String value = null;
    try {
      value = properties.getProperty(propName);
      value = (forceTrailingSlash && !value.endsWith("/")) ? value + "/" : value;
      URI uri = URI.create(value);
      return uri.toString();
    } catch (Exception e) {
      throw new ConfigurationException(value + " is no valid URL for property " + propName
        + ". Please configure application.properties appropriately!", e);
    }
  }

  public String getDrupal() {
    return drupal;
  }

  public String getDrupalCookieName() {
    return drupalCookieName;
  }

  public String getServerName() {
    return serverName;
  }

  public boolean isIncludeContext() {
    return includeContext;
  }

  public String getTileServerBaseUrl() {
    return tileServerBaseUrl;
  }

  public String getWsClb() {
    return wsClb;
  }

  public String getWsClbSearch() {
    return wsClbSearch;
  }

  public String getWsClbSuggest() {
    return wsClbSuggest;
  }

  public String getWsMetrics() {
    return wsMetrics;
  }

  public String getWsOcc() {
    return wsOcc;
  }

  public String getWsOccCatalogNumberSearch() {
    return wsOccCatalogNumberSearch;
  }

  /**
   * @return the wsOccCollectionCodeSearch
   */
  public String getWsOccCollectionCodeSearch() {
    return wsOccCollectionCodeSearch;
  }

  public String getWsOccCollectorNameSearch() {
    return wsOccCollectorNameSearch;
  }

  public String getWsOccDownload() {
    return wsOccDownload;
  }

  /**
   * @return the wsOccInstitutionCodeSearch
   */
  public String getWsOccInstitutionCodeSearch() {
    return wsOccInstitutionCodeSearch;
  }

  public String getWsOccSearch() {
    return wsOccSearch;
  }

  public String getWsReg() {
    return wsReg;
  }

  public String getWsRegSearch() {
    return wsRegSearch;
  }

  public String getWsRegSuggest() {
    return wsRegSuggest;
  }

  public void setTileServerBaseUrl(String tileServerBaseUrl) {
    this.tileServerBaseUrl = tileServerBaseUrl;
  }

  public String getWsImageCache() {
    return wsImageCache;
  }
}
