package org.gbif.portal.action.admin;

import org.gbif.api.paging.PagingRequest;
import org.gbif.api.paging.PagingResponse;
import org.gbif.common.messaging.MessagingService;
import org.gbif.common.messaging.api.StartCrawlMessage;
import org.gbif.metrics.api.model.DatasetMetrics;
import org.gbif.metrics.api.service.MetricsService;
import org.gbif.portal.action.BaseAction;
import org.gbif.portal.model.CrawlJob;
import org.gbif.registry.api.model.Dataset;
import org.gbif.registry.api.model.Node;
import org.gbif.registry.api.model.Organization;
import org.gbif.registry.api.model.vocabulary.EndpointType;
import org.gbif.registry.api.service.DatasetService;
import org.gbif.registry.api.service.NodeService;
import org.gbif.registry.api.service.OrganizationService;

import java.io.IOException;
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

  @Inject
  protected MessagingService service;

  protected String orgHost;
  protected String orgOwn;
  protected String id;

  private List<CrawlJob> crawlJobs = Lists.newArrayList();


  @Override
  public String execute() {
    return SUCCESS;
  }

  public void crawl() {
    try {
      service.declareAllExchangesFromRegistry();
    } catch (IOException e1) {
      e1.printStackTrace();
    }
    StartCrawlMessage message = new StartCrawlMessage(UUID.fromString(id));
    try {
      service.send(message);
    } catch (IOException e) {
      e.printStackTrace();
    }
  }

  public List<CrawlJob> getMetrics() {
    List<DatasetMetrics> metricsList = Lists.newArrayList();
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
        metricsList.add(metricsWsClient.getDatasetMetrics(dataset.getKey()));
      }
    } else {
      // no filter was applied, just gets the current datasets being crawled
      metricsList.addAll(metricsWsClient.getDatasetMetricsList());
    }

    CrawlJob job;
    Dataset dataset;
    Organization organization;
    for (DatasetMetrics dm : metricsList) {
      job = new CrawlJob();
      dataset = datasetWsClient.get(dm.getKey());

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

  /**
   * @param id the id to set
   */
  public void setId(String id) {
    this.id = id;
  }
}
