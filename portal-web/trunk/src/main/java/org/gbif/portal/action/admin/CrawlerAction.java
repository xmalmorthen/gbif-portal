package org.gbif.portal.action.admin;

import org.gbif.api.model.common.paging.PagingRequest;
import org.gbif.api.model.metrics.DatasetCrawlMetrics;
import org.gbif.api.model.registry.Dataset;
import org.gbif.api.model.registry.Node;
import org.gbif.api.model.registry.Organization;
import org.gbif.api.service.crawler.CrawlerDetailService;
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
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * The crawler action which uses the metrics-ws and diverse registry web services
 * to display information on running/queued crawls and also to give the ability to the
 * user to schedule and see progress of a new crawl job.
 */
public class CrawlerAction extends BaseAction {

  private static final Logger LOG = LoggerFactory.getLogger(CrawlerAction.class);

  private NodeService nodeWsClient;

  private CrawlerDetailService crawlerWsClient;

  private DatasetService datasetWsClient;

  private OrganizationService organizationWsClient;

  private String orgHost;
  private String orgOwn;
  private String nodeHost;
  private String nodeOwn;
  private String id;

  /**
   * @param nodeWsClient
   * @param metricsWsClient
   * @param datasetWsClient
   * @param organizationWsClient
   */
  @Inject
  private CrawlerAction(NodeService nodeWsClient, CrawlerDetailService crawlerWsClient, DatasetService datasetWsClient,
    OrganizationService organizationWsClient) {
    this.nodeWsClient = nodeWsClient;
    this.crawlerWsClient = crawlerWsClient;
    this.datasetWsClient = datasetWsClient;
    this.organizationWsClient = organizationWsClient;
  }

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
    List<Dataset> filteredDatasets = Lists.newArrayList();
    UUID organizationKey = null;
    UUID nodeKey = null;
    if (!Strings.isNullOrEmpty(nodeHost) && Strings.isNullOrEmpty(orgHost)) {
      try {
        nodeKey = UUID.fromString(nodeHost);
        filteredDatasets =
          getHostedDatasetsFromOrganizations(nodeWsClient.listEndorsedBy(nodeKey, new PagingRequest(0, 50))
            .getResults());
      } catch (IllegalArgumentException e) {
        LOG.warn("Hosting node parameter \"[{}]\" is not a valid UUID, ignoring parameter");
      }
    } else if (!Strings.isNullOrEmpty(nodeHost) && !Strings.isNullOrEmpty(orgHost)) {
      try {
        organizationKey = UUID.fromString(orgHost);
        filteredDatasets = datasetWsClient.listOwnedBy(organizationKey, new PagingRequest(0, 50)).getResults();
      } catch (IllegalArgumentException e) {
        LOG.warn("Hosting organization parameter \"[{}]\" is not a valid UUID, ignoring parameter");
      }
    }

    if (!Strings.isNullOrEmpty(nodeOwn) && Strings.isNullOrEmpty(orgOwn)) {
      try {
        nodeKey = UUID.fromString(nodeOwn);
        filteredDatasets =
          getOwnedDatasetsFromOrganizations(nodeWsClient.listEndorsedBy(nodeKey, new PagingRequest(0, 50)).getResults());
      } catch (IllegalArgumentException e) {
        LOG.warn("Owning node parameter \"[{}]\" is not a valid UUID, ignoring parameter");
      }
    } else if (!Strings.isNullOrEmpty(nodeOwn) && !Strings.isNullOrEmpty(orgOwn)) {
      try {
        organizationKey = UUID.fromString(orgOwn);
        filteredDatasets = datasetWsClient.listOwnedBy(organizationKey, new PagingRequest(0, 50)).getResults();
      } catch (IllegalArgumentException e) {
        LOG.warn("Owning organization parameter \"[{}]\" is not a valid UUID, ignoring parameter");
      }
    }

    // calculate the metrics for each dataset
    if (!filteredDatasets.isEmpty()) {
      for (Dataset dataset : filteredDatasets) {
        metricsList.add(crawlerWsClient.getCrawlMetrics(UUID.fromString(dataset.getKey())));
      }
    } else {
      // no filter was applied, just gets the current datasets being crawled
      metricsList.addAll(crawlerWsClient.getCrawlMetricsList());
    }

    return createCrawlJobs(metricsList);
  }

  /**
   * Generates a list of {@link CrawlJob} given a list of {@link DatasetCrawlMetrics}. The crawl jobs is a consolidated
   * list of values which are displayed to the user.
   * 
   * @param metrics the {@link DatasetCrawlMetrics} object which contains only metrics for a dataset
   * @return a consolidated list of values for datasets which involve metrics and information from the GBIF Registry
   */
  private List<CrawlJob> createCrawlJobs(List<DatasetCrawlMetrics> metrics) {
    List<CrawlJob> crawlJobs = Lists.newArrayList();
    CrawlJob job;
    Dataset dataset;
    Organization organization;
    for (DatasetCrawlMetrics dm : metrics) {
      dataset = datasetWsClient.get(dm.getDatasetKey());
      job = new CrawlJob();
      // if the datasetKey does not exist in the GBIF Registry, don't add the dataset info to the crawl job
      if (dataset != null) {
        organization = organizationWsClient.get(dataset.getOwningOrganizationKey());
        job.setOwningOrganizationName(organization.getTitle());
        job.setDataset(dataset);
        job.setCrawlMetrics(dm);
        crawlJobs.add(job);
      }
    }
    return crawlJobs;
  }

  /**
   * Returns a list of {@link Dataset} generated from traversing across a list of organizations.
   * 
   * @param organizations
   * @return
   */
  private List<Dataset> getHostedDatasetsFromOrganizations(List<Organization> organizations) {
    List<Dataset> filteredDatasets = Lists.newArrayList();
    for (Organization organization : organizations) {
      filteredDatasets.addAll(datasetWsClient.listHostedBy(organization.getKey(), new PagingRequest(0, 50))
        .getResults());
    }
    return filteredDatasets;
  }

  /**
   * Returns a list of {@link Dataset} generated from traversing across a list of organizations.
   * 
   * @param organizations
   * @return
   */
  private List<Dataset> getOwnedDatasetsFromOrganizations(List<Organization> organizations) {
    List<Dataset> filteredDatasets = Lists.newArrayList();
    for (Organization organization : organizations) {
      filteredDatasets
        .addAll(datasetWsClient.listOwnedBy(organization.getKey(), new PagingRequest(0, 50)).getResults());
    }
    return filteredDatasets;
  }

  public List<Node> getNodes() {
    /*
    TODO: We don't need to load a list of nodes right now, as the use of the Crawler UI
    is for inspecting the crawling process instead of scheduling new crawls.
    
    PagingResponse<Node> response = nodeWsClient.list(new PagingRequest(0, 50));

    if (response != null) {
      return response.getResults();
    }
    */
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

  /**
   * @param nodeHost the nodeHost to set
   */
  public void setNodeHost(String nodeHost) {
    this.nodeHost = nodeHost;
  }

  /**
   * @param nodeOwn the nodeOwn to set
   */
  public void setNodeOwn(String nodeOwn) {
    this.nodeOwn = nodeOwn;
  }
}
