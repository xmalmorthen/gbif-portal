package org.gbif.portal.config;

import org.gbif.checklistbank.service.mybatis.guice.ChecklistBankServiceMyBatisModule;
import org.gbif.checklistbank.ws.client.guice.ChecklistBankWsClientModule;
import org.gbif.occurrencestore.ws.client.guice.OccurrenceWsClientModule;
import org.gbif.registry.ws.client.guice.RegistryWsClientModule;

import java.io.IOException;
import java.util.Properties;

import com.google.inject.AbstractModule;
import com.google.inject.name.Names;

public class PortalModule extends AbstractModule {

  /**
   * The portal module combines all service modules needed for the portal.
   * You can switch between the mybatis and the ws-client api implementation for checklistbank
   * by swapping the used module below.
   * When mybatis is used make sure your maven settings include the checklistbank jdbc properties.
   *
   * @throws ConfigurationException If the application properties cannot be read
   */
  private void bindApplicationProperties() throws ConfigurationException {
    try {
      Properties properties = new Properties();
      properties.load(this.getClass().getResourceAsStream("/application.properties"));
      Names.bindProperties(binder(), properties);
      // install modules
      install(new RegistryWsClientModule());
      install(new OccurrenceWsClientModule());
      // select either the mybatis or the ws-client api implementation:
      //install(new ChecklistBankServiceMyBatisModule(properties));
      //setting the ws client as the implementation
      install(new ChecklistBankWsClientModule());
    } catch (IOException e) {
      throw new ConfigurationException(
        "Unable to read the application.properties (perhaps missing in WEB-INF/classes?)", e);
    }
  }

  @Override
  protected void configure() {
    bindApplicationProperties();
  }
}
