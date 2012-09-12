package org.gbif.portal.model;

import org.gbif.api.model.metrics.DatasetMetrics;
import org.gbif.api.model.registry.Dataset;

/**
 * Object that aggregates all the information needed to be displayed for a single
 * crawl job.
 */
public class CrawlJob {

  private DatasetMetrics metrics;
  private Dataset dataset;
  private String owningOrganizationName;

  /**
   * @return the dataset
   */
  public Dataset getDataset() {
    return dataset;
  }

  /**
   * @return the metrics
   */
  public DatasetMetrics getMetrics() {
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
  public void setMetrics(DatasetMetrics metrics) {
    this.metrics = metrics;
  }

  /**
   * @param owningOrganizationName the owningOrganizationName to set
   */
  public void setOwningOrganizationName(String owningOrganizationName) {
    this.owningOrganizationName = owningOrganizationName;
  }
}
