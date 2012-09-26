package org.gbif.portal.action.admin;

import org.gbif.api.model.common.paging.PagingRequest;
import org.gbif.api.model.common.paging.PagingResponse;
import org.gbif.api.model.metrics.DatasetCrawlMetrics;
import org.gbif.api.model.registry.Dataset;
import org.gbif.api.model.registry.Node;
import org.gbif.api.model.registry.Organization;
import org.gbif.api.service.metrics.MetricsService;
import org.gbif.api.service.registry.DatasetService;
import org.gbif.api.service.registry.NodeService;
import org.gbif.api.service.registry.OrganizationService;
import org.gbif.api.vocabulary.EndpointType;
import org.gbif.portal.action.BaseAction;
import org.gbif.portal.model.CrawlJob;

import java.util.List;
import java.util.Set;
import java.util.UUID;

import com.google.common.base.Strings;
import com.google.common.collect.Lists;
import com.google.inject.Inject;

public class CrawlerAction extends BaseAction {

  @Inject
  protected NodeService nodeWsClient;

  @Inject
  protected MetricsService metricsWsClient;

  @Inject
  protected DatasetService datasetWsClient;

  @Inject
  protected OrganizationService organizationWsClient;

  protected String orgHost;
  protected String orgOwn;
  protected String id;

  private final List<CrawlJob> crawlJobs = Lists.newArrayList();


  public void crawl() {
    // TODO: call the scheduling-service ws
  }

  @Override
  public String execute() {
    return SUCCESS;
  }

  /**
   * Returns a list of metrics of a group of datasets.
   * 
   * @return list of metrics
   */
  public List<CrawlJob> getMetrics() {
    List<DatasetCrawlMetrics> metricsList = Lists.newArrayList();
    PagingResponse<Dataset> filteredDatasets = new PagingResponse<Dataset>(0, 50);
    UUID organizationKey = null;
    if (!Strings.isNullOrEmpty(orgHost)) {
      try {
        organizationKey = UUID.fromString(orgHost);
      } catch (IllegalArgumentException e) {
        // TODO: send error, invalid UUID format
      }
      filteredDatasets = datasetWsClient.listHostedBy(organizationKey, new PagingRequest(0, 50));
    } else if (!Strings.isNullOrEmpty(orgOwn)) {
      try {
        organizationKey = UUID.fromString(orgOwn);
      } catch (IllegalArgumentException e) {
        // TODO: send error, invalid UUID format
      }
      filteredDatasets = datasetWsClient.listOwnedBy(organizationKey, new PagingRequest(0, 50));
    }

    // calculate the metrics for each dataset
    if (filteredDatasets.getResults() != null) {
      for (Dataset dataset : filteredDatasets.getResults()) {
        metricsList.add(metricsWsClient.getDatasetMetrics(UUID.fromString(dataset.getKey())));
      }
    } else {
      // no filter was applied, just gets the current datasets being crawled
      metricsList.addAll(metricsWsClient.getDatasetMetricsList());
    }

    CrawlJob job;
    Dataset dataset;
    Organization organization;
    for (DatasetCrawlMetrics dm : metricsList) {
      job = new CrawlJob();
      dataset = datasetWsClient.get(dm.getDatasetKey());

      organization = organizationWsClient.get(dataset.getOwningOrganizationKey());
      job.setMetrics(dm);
      job.setDataset(dataset);
      job.setOwningOrganizationName(organization.getTitle());
      crawlJobs.add(job);
    }
    return crawlJobs;
  }

  public List<Node> getNodes() {
    // TODO: PagingRequest returns 20 by default, should process all nodes to return the complete list.
    PagingResponse<Node> response = nodeWsClient.list(new PagingRequest(0, 50));

    if (response != null) {
      return response.getResults();
    }
    return null;
  }

  public Set<EndpointType> getOccurrenceEndpoints() {
    return EndpointType.OCCURRENCE_CODES;
  }

  /**
   * @param id the id to set
   */
  public void setId(String id) {
    this.id = id;
  }

  /**
   * @param orgHost the orgHost to set
   */
  public void setOrgHost(String orgHost) {
    this.orgHost = orgHost;
  }

  /**
   * @param orgOwn the orgOwn to set
   */
  public void setOrgOwn(String orgOwn) {
    this.orgOwn = orgOwn;
  }
}
