package org.gbif.user.mybatis;

import org.gbif.test.DatabaseDrivenTestRule;
import org.gbif.user.guice.DrupalMyBatisModule;

import java.util.Map;
import javax.annotation.Nullable;

import com.google.common.collect.ImmutableMap;
import org.dbunit.database.DatabaseConfig;
import org.dbunit.ext.mysql.MySqlDataTypeFactory;

/**
 * Provides a JUnit {@link org.junit.rules.TestRule} to allow database driven integration tests in Drupal.
 * <p/>
 */
public class DrupalTestRule extends DatabaseDrivenTestRule {

  private static final String DEFAULT_PROPERTIES_FILE = "drupal.properties";
  private static final String DEFAULT_PROPERTY_PREFIX = "drupal";
  private static final Map<String, Object> DB_UNIT_PROPERTIES = new ImmutableMap.Builder<String, Object>()
    .put(DatabaseConfig.PROPERTY_DATATYPE_FACTORY, new MySqlDataTypeFactory())
    .put("http://www.dbunit.org/features/caseSensitiveTableNames", true).build();

  /**
   * @param propertyPrefix the prefix used to retrieve the db connections in the properties. E.g. occurrencestore
   * @param dbUnitFileName the optional unqualified filename within the dbunit package to be used in setting up the db
   */
  public DrupalTestRule(String propertiesFile, String propertyPrefix, @Nullable String dbUnitFileName) {
    super(DrupalMyBatisModule.class, propertiesFile, propertyPrefix, dbUnitFileName, DB_UNIT_PROPERTIES);
  }

  /**
   */
  public DrupalTestRule() {
    super(DrupalMyBatisModule.class, DEFAULT_PROPERTIES_FILE, DEFAULT_PROPERTY_PREFIX, null, DB_UNIT_PROPERTIES);
  }

  /**
   * @param dbUnitFileName the optional unqualified filename within the dbunit package to be used in setting up the db
   */
  public DrupalTestRule(String dbUnitFileName) {
    super(DrupalMyBatisModule.class, DEFAULT_PROPERTIES_FILE, DEFAULT_PROPERTY_PREFIX, dbUnitFileName, DB_UNIT_PROPERTIES);
  }

  /**
   * Before ever test and after the db is setup reindex the functioanl indices in postgres.
   * These get out of sync somehow and tests will fail otherwise.
   * In the production system these indices are updated after each import.
   */
  @Override
  protected void runFinally() {
/*    Connection c = null;
    try {
      log.debug("Reindex functional clb indices");
      c = dataSource.getConnection();
      Statement stmnt = c.createStatement();
      stmnt.execute("reindex index name_usage_synonyms_rankorder_idx;");
      stmnt.close();
      log.info("Reindexed functional clb index");
    } catch (SQLException e) {
      throw new IllegalStateException("Failed to reindex database", e);
    } finally {
      if (c != null) {
        try {
          c.close();
        } catch (SQLException e) {
          log.error("SQLException", e);
        }
      }
    }*/
  }
}
