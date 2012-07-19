package org.gbif.portal.config;

import org.gbif.checklistbank.ws.client.guice.ChecklistBankWsClientModule;
import org.gbif.occurrencestore.download.ws.client.guice.OccurrenceDownloadWsClientModule;
import org.gbif.registry.ws.client.guice.RegistryWsClientModule;
import org.gbif.user.guice.DrupalMyBatisModule;
import org.gbif.ws.util.PropertiesUtil;

import java.util.Properties;

import com.google.inject.AbstractModule;

public class PortalModule extends AbstractModule {

  private static final String PROPERTIES_FILE = "application.properties";

  @Override
  protected void configure() {
    Properties properties = PropertiesUtil.readFromClasspath(PROPERTIES_FILE);

    install(new PrivatePortalModule(properties));

    // bind registry API
    install(new RegistryWsClientModule(properties, true, true));

    // bind drupal mybatis services
    install(new DrupalMyBatisModule(properties));

    // bind checklist bank api. Select either the mybatis or the ws-client api implementation:
    install(new ChecklistBankWsClientModule(properties));

    // bind the occurrence download service
    install(new OccurrenceDownloadWsClientModule(properties));
  }

}
