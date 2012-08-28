package org.gbif.portal.action.admin;

import org.gbif.api.paging.PagingResponse;
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

import java.util.List;
import java.util.Set;
import java.util.UUID;

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

  private List<CrawlJob> crawlJobs = Lists.newArrayList();

  @Override
  public String execute() {
    return SUCCESS;
  }

  public List<CrawlJob> getMetrics() {
    List<DatasetMetrics> metricsList = metricsWsClient.getDatasetMetricsList();
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
    // add some mock datasets
    // this is temporary and will be replaced as soon as Zookeeper starts getting fed data
    List<Dataset> tempDs = Lists.newArrayList();
    tempDs.add(datasetWsClient.get(UUID.fromString("0debafd0-6c8a-11de-8225-b8a03c50a862")));
    tempDs.add(datasetWsClient.get(UUID.fromString("76819780-989f-11de-b4d9-b8a03c50a862")));
    tempDs.add(datasetWsClient.get(UUID.fromString("e01e6790-13de-11de-b2e1-b8a03c50a862")));
    tempDs.add(datasetWsClient.get(UUID.fromString("8641b120-af9d-11db-ad75-b8a03c50a862")));
    tempDs.add(datasetWsClient.get(UUID.fromString("79bf7c00-c240-11dc-ab55-b8a03c50a862")));
    tempDs.add(datasetWsClient.get(UUID.fromString("a54ad100-f8f4-47f3-968d-f7dd2a4000e8")));

    for (Dataset ds : tempDs) {
      job = new CrawlJob();
      job.setDataset(ds);
      job.setMetrics(metricsWsClient.getDatasetMetrics(ds.getKey()));
      organization = organizationWsClient.get(ds.getOwningOrganizationKey());
      job.setOwningOrganizationName(organization.getTitle());
      crawlJobs.add(job);
    }

    return crawlJobs;
  }

  public List<Node> getNodes() {
    // TODO: This returns 20 by default, should process all nodes to return the complete list.
    PagingResponse<Node> response = nodeWsClient.list(null);

    if (response != null) {
      return response.getResults();
    }
    return null;
  }

  public Set<EndpointType> getOccurrenceEndpoints() {
    return EndpointType.OCCURRENCE_CODES;
  }

}
