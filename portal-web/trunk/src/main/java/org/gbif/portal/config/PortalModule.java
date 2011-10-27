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
      // load and bind single properties to pass on to other modules.
      Properties properties = new Properties();
      properties.load(this.getClass().getResourceAsStream("/application.properties"));
      Names.bindProperties(binder(), properties);

      // bind checklist bank api. Select either the mybatis or the ws-client api implementation:
      installClbMyBatis(properties);
      //installClbWsClient(properties);

      // bind registry API
      install(new RegistryWsClientModule());

      // bind occurrence API
      install(new OccurrenceWsClientModule());

    } catch (IOException e) {
      throw new ConfigurationException(
        "Unable to read the application.properties (perhaps missing in WEB-INF/classes?)", e);
    }
  }

  /**
   * Installs the CLB API using the direct MyBatis module and the solr search ws client.
   */
  private void installClbMyBatis(Properties properties) {
    install(new ChecklistBankServiceMyBatisModule(properties));
    install(new ChecklistBankWsClientModule(true, false));
  }

  /**
   * Installs the CLB API using only the ws clients.
   */
  private void installClbWsClient(Properties properties) {
    install(new ChecklistBankWsClientModule());
  }

  @Override
  protected void configure() {
    bindApplicationProperties();
  }
}
