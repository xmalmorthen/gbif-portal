package org.gbif.portal.config;

import com.google.inject.AbstractModule;
import com.google.inject.name.Names;

import java.io.IOException;
import java.util.Properties;

public class PortalModule extends AbstractModule {

  @Override
  protected void configure() {
    bindApplicationProperties();
  }

  /**
   * @throws ConfigurationException If the application properties cannot be read
   */
  private void bindApplicationProperties() throws ConfigurationException {
    try {
      Properties properties = new Properties();
      properties.load(this.getClass().getResourceAsStream("/application.properties"));
      Names.bindProperties(binder(), properties);
    } catch (IOException e) {
      throw new ConfigurationException(
        "Unable to read the application.properties (perhaps missing in WEB-INF/classes?)", e);
    }
  }
}
