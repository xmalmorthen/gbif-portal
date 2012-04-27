package org.gbif.portal.config;

import org.gbif.checklistbank.ws.client.guice.ChecklistBankWsClientModule;
import org.gbif.occurrencestore.ws.client.guice.OccurrenceWsClientModule;
import org.gbif.registry.ws.client.guice.RegistryWsClientModule;
import org.gbif.user.guice.DrupalMyBatisModule;
import org.gbif.utils.HttpUtil;
import org.gbif.ws.client.filter.HttpGbifAuthFilter;

import java.io.IOException;
import java.util.Properties;

import com.google.inject.AbstractModule;
import com.google.inject.Inject;
import com.google.inject.Provides;
import com.google.inject.Scopes;
import com.google.inject.Singleton;
import com.google.inject.name.Named;
import com.google.inject.name.Names;
import com.sun.jersey.api.client.filter.ClientFilter;
import org.apache.http.client.HttpClient;

public class PortalModule extends AbstractModule {

  /**
   * The portal module combines all service modules needed for the portal.
   * You can switch between the mybatis and the ws-client api implementation for checklistbank
   * by swapping the used module below.
   * When mybatis is used make sure your maven settings include the checklistbank jdbc properties.
   * 
   * @throws ConfigurationException If the application properties cannot be read
   */
  private Properties bindApplicationProperties() throws ConfigurationException {
    try {
      // load and bind single properties to pass on to other modules.
      Properties properties = new Properties();
      properties.load(this.getClass().getResourceAsStream("/application.properties"));
      Names.bindProperties(binder(), properties);
      return properties;
    } catch (IOException e) {
      throw new ConfigurationException(
        "Unable to read the application.properties (perhaps missing in WEB-INF/classes?)", e);
    }
  }

  @Provides
  @Singleton
  @Inject
  public ClientFilter provideSessionAuthFilter(SessionAuthProvider sessionAuthProvider,
    @Named("application.key") String applicationKey) {
    return new HttpGbifAuthFilter(applicationKey, sessionAuthProvider);
  }

  @Override
  protected void configure() {
    Properties properties = bindApplicationProperties();

    bind(SessionAuthProvider.class).in(Scopes.SINGLETON);

    // bind registry API
    install(new RegistryWsClientModule(properties, true, true));

    // bind drupal mybatis services
    install(new DrupalMyBatisModule(properties));

    // bind checklist bank api. Select either the mybatis or the ws-client api implementation:
    install(new ChecklistBankWsClientModule(properties));

    // bind occurrence API
    install(new OccurrenceWsClientModule(properties));
  }

  @Provides
  @Singleton
  public HttpClient provideHttpClient() {
    return HttpUtil.newMultithreadedClient();
  }


}
