package org.gbif.portal.config;

import java.io.IOException;
import java.net.URI;
import java.util.Properties;

import com.google.inject.Inject;
import com.google.inject.Singleton;
import com.google.inject.name.Named;

/**
 * Simple configuration bean to pass the guice binded properties on to the rendering layer.
 */
@Singleton
public class Config {

  @Inject
  @Named("cas.url")
  private String cas;

  @Inject
  @Named("servername")
  private String serverName;

  @Inject
  @Named("drupal.url")
  private String drupal;

  @Inject
  @Named("checklistbank.ws.url")
  private String wsClb;

  @Inject
  @Named("checklistbank.search.ws.url")
  private String wsClbSearch;

  @Inject
  @Named("registry.ws.url")
  private String wsReg;

  @Inject
  @Named("registry.search.ws.url")
  private String wsRegSearch;

  @Inject
  @Named("occurrencestore.ws.url")
  private String wsOcc;

  @Inject
  @Named("occurrencestore.search.ws.url")
  private String wsOccSearch;

  @Inject
  @Named("checklistbank.suggest.ws.url")
  private String wsClbSuggest;

  private static String getPropertyUrl(Properties properties, String propName){
    try {
      URI uri = URI.create(properties.getProperty(propName));
      return uri.toString();
    } catch (Exception e) {
      throw new ConfigurationException(propName+" is no valid URL. Please configure application.properties appropriately!", e);
    }
  }

  public static Config buildFromProperties(){
    Config cfg = new Config();
      try {
        Properties properties = new Properties();
        properties.load(Config.class.getResourceAsStream("/application.properties"));
        // check if its a real URL
        cfg.serverName = getPropertyUrl(properties, "servername");
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
