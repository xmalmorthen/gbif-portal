package org.gbif.portal.model;

import org.gbif.api.model.metrics.DatasetCrawlMetrics;
import org.gbif.api.model.registry.Dataset;

import java.util.Map;

/**
 * Object that aggregates all the information needed to be displayed for a single
 * crawl job.
 */
public class CrawlJob {

  private DatasetCrawlMetrics metrics;
  private Dataset dataset;
  private String owningOrganizationName;
  private Map<String, String> properties;

  /**
   * @return the dataset
   */
  public Dataset getDataset() {
    return dataset;
  }

  /**
   * @return the metrics
   */
  public DatasetCrawlMetrics getCrawlMetrics() {
    return metrics;
  }

  /**
   * @return the owningOrganizationName
   */
  public String getOwningOrganizationName() {
    return owningOrganizationName;
  }

  /**
   * @param dataset the dataset to set
   */
  public void setDataset(Dataset dataset) {
    this.dataset = dataset;
  }

  /**
   * @param metrics the metrics to set
   */
  public void setCrawlMetrics(DatasetCrawlMetrics metrics) {
    this.metrics = metrics;
  }

  /**
   * @param owningOrganizationName the owningOrganizationName to set
   */
  public void setOwningOrganizationName(String owningOrganizationName) {
    this.owningOrganizationName = owningOrganizationName;
  }

  /**
   * @return the properties.
   */
  public Map<String, String> getProperties() {
    return properties;
  }

  /**
   * @param properties the properties to set.
   */
  public void setProperties(Map<String, String> properties) {
    this.properties = properties;
  }
}
