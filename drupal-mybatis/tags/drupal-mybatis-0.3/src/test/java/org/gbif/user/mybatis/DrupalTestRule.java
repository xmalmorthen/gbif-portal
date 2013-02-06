package org.gbif.user.mybatis;

import org.gbif.test.DatabaseDrivenTestRule;
import org.gbif.user.guice.DrupalMyBatisModule;
import org.gbif.user.guice.InternalDrupalMyBatisModule;
import org.gbif.utils.file.properties.PropertiesUtil;

import java.io.IOException;
import java.util.Map;
import java.util.Properties;

import com.google.common.collect.ImmutableMap;
import org.dbunit.database.DatabaseConfig;
import org.dbunit.ext.mysql.MySqlDataTypeFactory;

/**
 * Provides a JUnit {@link org.junit.rules.TestRule} to allow database driven integration tests in Drupal.
 * <p/>
 */
public class DrupalTestRule<T> extends DatabaseDrivenTestRule<T> {

  private static final Map<String, Object> DB_UNIT_PROPERTIES = new ImmutableMap.Builder<String, Object>()
    .put(DatabaseConfig.PROPERTY_DATATYPE_FACTORY, new MySqlDataTypeFactory())
    .put("http://www.dbunit.org/features/caseSensitiveTableNames", true).build();
  private static final Properties properties;
  static {
    try {
      properties = PropertiesUtil.loadProperties("drupal.properties");
    } catch (IOException e) {
      throw new IllegalStateException("Cant load properties", e);
    }
  }

  /**
   */
  public DrupalTestRule(Class<T> serviceClass) {
    super(new DrupalMyBatisModule(properties), InternalDrupalMyBatisModule.DATASOURCE_BINDING_NAME, serviceClass,
      "users.xml", DB_UNIT_PROPERTIES);
  }

}
