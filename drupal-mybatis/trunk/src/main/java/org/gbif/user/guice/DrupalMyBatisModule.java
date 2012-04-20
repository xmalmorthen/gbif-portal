package org.gbif.user.guice;

import org.gbif.service.guice.PrivateServiceModule;
import org.gbif.user.UserService;

import java.io.IOException;
import java.util.Map;
import java.util.Properties;

public class DrupalMyBatisModule extends PrivateServiceModule {

  private static final String PREFIX = "drupal.db.";

  public DrupalMyBatisModule(Map<String, String> properties) {
    super(PREFIX, properties);
  }

  /**
   * Uses the given properties to configure the service.
   *
   * @param properties to use
   */
  public DrupalMyBatisModule(Properties properties) {
    super(PREFIX, properties);
  }

  public DrupalMyBatisModule(String propertiesFile) throws IOException {
    super(PREFIX, propertiesFile);
  }

  @Override
  protected void configureService() {
    // bind classes
    install(new InternalDrupalMyBatisModule());

    // expose services
    expose(UserService.class);
  }
}
