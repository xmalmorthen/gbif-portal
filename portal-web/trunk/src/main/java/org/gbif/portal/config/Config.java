package org.gbif.portal.config;

import com.google.inject.Inject;
import com.google.inject.Singleton;
import com.google.inject.name.Named;

/**
 * Simple configuration bean to pass the guice binded properties on to the rendering layer.
 */
@Singleton
public class Config {

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
