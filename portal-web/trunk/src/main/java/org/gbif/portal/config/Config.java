package org.gbif.portal.config;

import org.gbif.utils.file.properties.PropertiesUtil;

import java.io.IOException;
import java.net.URI;
import java.util.Properties;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import static org.gbif.api.model.occurrence.search.Constants.CATALOG_NUMBER_PATH;
import static org.gbif.api.model.occurrence.search.Constants.COLLECTOR_NAME_PATH;
import static org.gbif.api.model.occurrence.search.Constants.SEARCH_PATH;

/**
 * Simple configuration bean to pass the guice binded properties on to the rendering layer.
 * When adding or modifying entries please also adjust the decorator default.ftl.
 */
public class Config {

  public static final String APPLICATION_PROPERTIES = "application.properties";
  private static final Logger LOG = LoggerFactory.getLogger(Config.class);
  public static final String SERVERNAME = "servername";
  public static final String SUGGEST_PATH = "suggest";

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

      // prefer system variable if existing, required (e.g.) by selenim
      try {
        URI uri = URI.create(System.getProperty(SERVERNAME));
        cfg.serverName = uri.toString();
        LOG.debug("Using servername system variable");
      } catch (Exception e) {
        cfg.serverName = getPropertyUrl(properties, SERVERNAME, false);
      }
      LOG.debug("Setting servername to {}", cfg.serverName);

      cfg.cas = getPropertyUrl(properties, "cas.url", true);
      cfg.drupal = getPropertyUrl(properties, "drupal.url", false);
      cfg.wsClb = getPropertyUrl(properties, "checklistbank.ws.url", true);
      cfg.wsClbSearch = getPropertyUrl(properties, "checklistbank.search.ws.url", true);
      cfg.wsClbSuggest = cfg.wsClbSearch + SUGGEST_PATH;
      cfg.wsReg = getPropertyUrl(properties, "registry.ws.url", true);
      cfg.wsRegSearch = getPropertyUrl(properties, "registry.search.ws.url", true);
      cfg.wsRegSuggest = cfg.wsRegSearch + SUGGEST_PATH;
      cfg.wsOcc = getPropertyUrl(properties, "occurrence.ws.url", true);
      cfg.wsOccSearch = cfg.wsOcc + SEARCH_PATH;
      cfg.wsOccCatalogNumberSearch = cfg.wsOccSearch + "/" + CATALOG_NUMBER_PATH;
      cfg.wsOccCollectorNameSearch = cfg.wsOccSearch + "/" + COLLECTOR_NAME_PATH;
      cfg.tileServerBaseUrl = getPropertyUrl(properties, "tile-server.url", false);
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

  private String cas;
  private String drupal;
  private String serverName;
  private String tileServerBaseUrl;
  private String wsClb;
  private String wsClbSearch;

  private String wsClbSuggest;
  private String wsOcc;
  private String wsOccCatalogNumberSearch;
  private String wsOccCollectorNameSearch;
  private String wsOccSearch;
  private String wsReg;

  private String wsRegSearch;

  private String wsRegSuggest;


  public String getCas() {
    return cas;
  }


  public String getDrupal() {
    return drupal;
  }

  public String getServerName() {
    return serverName;
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

  public String getWsOcc() {
    return wsOcc;
  }

  /**
   * @return the wsOccCatalogNumberSearch
   */
  public String getWsOccCatalogNumberSearch() {
    return wsOccCatalogNumberSearch;
  }

  /**
   * @return the wsOccCollectorNameSearch
   */
  public String getWsOccCollectorNameSearch() {
    return wsOccCollectorNameSearch;
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

  /**
   * @return the wsRegSuggest
   */
  public String getWsRegSuggest() {
    return wsRegSuggest;
  }


  public void setTileServerBaseUrl(String tileServerBaseUrl) {
    this.tileServerBaseUrl = tileServerBaseUrl;
  }
}
