package org.gbif.portal.config;

import java.io.IOException;
import java.net.URI;
import java.util.Properties;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Simple configuration bean to pass the guice binded properties on to the rendering layer.
 */
public class Config {
  private final static Logger LOG = LoggerFactory.getLogger(Config.class);
  public final static String SERVERNAME = "servername";

  private String cas;
  private String serverName;
  private String drupal;
  private String wsClb;
  private String wsClbSearch;
  private String wsReg;
  private String wsRegSearch;
  private String wsOcc;
  private String wsOccSearch;
  private String wsClbSuggest;

  private static String getPropertyUrl(Properties properties, String propName){
    String value = null;
    try {
      value = properties.getProperty(propName);
      URI uri = URI.create(value);
      return uri.toString();
    } catch (Exception e) {
      throw new ConfigurationException(value+" is no valid URL for property "+propName+". Please configure application.properties appropriately!", e);
    }
  }

  public static Config buildFromProperties(){
    Config cfg = new Config();
      try {
        Properties properties = new Properties();
        properties.load(Config.class.getResourceAsStream("/application.properties"));
        // prefer system variable if existing
        try {
          URI uri = URI.create(System.getProperty(SERVERNAME));
          cfg.serverName = uri.toString();
          LOG.debug("Using servername system variable");
        } catch (Exception e) {
          cfg.serverName = getPropertyUrl(properties, SERVERNAME);
        }
        LOG.debug("Setting servername to {}", cfg.serverName);

        cfg.cas = getPropertyUrl(properties, "cas.url");
        cfg.drupal = getPropertyUrl(properties, "drupal.url");
        cfg.wsClb = getPropertyUrl(properties, "checklistbank.ws.url");
        cfg.wsClbSearch = getPropertyUrl(properties, "checklistbank.search.ws.url");
        cfg.wsReg = getPropertyUrl(properties, "registry.ws.url");
        cfg.wsRegSearch = getPropertyUrl(properties, "registry.search.ws.url");
        cfg.wsOcc = getPropertyUrl(properties, "occurrencestore.ws.url");
        cfg.wsOccSearch = getPropertyUrl(properties, "occurrencestore.search.ws.url");
        cfg.wsClbSuggest = getPropertyUrl(properties, "checklistbank.suggest.ws.url");
      } catch (IOException e) {
        throw new ConfigurationException("application.properties cannot be read", e);
      }
    return cfg;
  }

  public String getServerName() {
    return serverName;
  }

  public String getDrupal() {
    return drupal;
  }

  public String getCas() {
    return cas;
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

  public String getWsOccSearch() {
    return wsOccSearch;
  }

  public String getWsReg() {
    return wsReg;
  }

  public String getWsRegSearch() {
    return wsRegSearch;
  }
}
