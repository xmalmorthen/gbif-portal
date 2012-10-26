package org.gbif.portal.action.dataset;

import org.gbif.api.exception.NotFoundException;
import org.gbif.api.model.checklistbank.DatasetMetrics;
import org.gbif.api.model.registry.Dataset;
import org.gbif.api.model.registry.Network;
import org.gbif.api.model.registry.Organization;
import org.gbif.api.service.checklistbank.DatasetMetricsService;
import org.gbif.api.service.registry.DatasetService;
import org.gbif.api.service.registry.NetworkService;
import org.gbif.api.service.registry.OrganizationService;
import org.gbif.portal.action.BaseAction;

import java.util.UUID;

import com.google.common.base.Strings;
import com.google.inject.Inject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class DatasetBaseAction extends BaseAction {

  private static final Logger LOG = LoggerFactory.getLogger(DatasetBaseAction.class);

  protected String id;
  protected UUID key;
  protected Dataset dataset;
  protected DatasetMetrics metrics;
  @Inject
  protected DatasetService datasetService;
  @Inject
  protected DatasetMetricsService metricsService;
  // detail
  protected Organization owningOrganization;
  // detail
  protected Network networkOfOrigin;
  @Inject
  protected OrganizationService organizationService;
  @Inject
  protected NetworkService networkService;

  public Dataset getDataset() {
    return dataset;
  }

  public DatasetService getDatasetService() {
    return datasetService;
  }

  public String getId() {
    return id;
  }

  public UUID getKey() {
    return key;
  }

  public Dataset getMember() {
    return dataset;
  }

  public DatasetMetrics getMetrics() {
    return metrics;
  }

  /**
   * @return the dataset's owningOrganization
   */
  public Organization getOwningOrganization() {
    return owningOrganization;
  }

  /**
   * @return the Dataset's Network of origin.
   */
  public Network getNetworkOfOrigin() {
    return networkOfOrigin;
  }

  protected void loadDetail() {
    LOG.debug("Fetching detail for dataset id [{}]", id);
    if (Strings.isNullOrEmpty(id)) {
      throw new NotFoundException();
    }

    dataset = datasetService.get(id);
    if (dataset == null) {
      LOG.error("No dataset found with id {}", id);
      throw new NotFoundException();
    }

    // gets the owning organization
    if (dataset.getOwningOrganizationKey() != null) {
      owningOrganization = organizationService.get(dataset.getOwningOrganizationKey());
    }

    // get the network of origin
    if (dataset.getNetworkOfOriginKey() != null) {
      networkOfOrigin = networkService.get(dataset.getNetworkOfOriginKey());
    }

    // get metrics
    try {
      key = UUID.fromString(id);
      metrics = metricsService.get(key);
    } catch (NotFoundException e) {
      LOG.warn("Cant get metrics for dataset {}", key, e);
    } catch (IllegalArgumentException e) {
      // ignore external datasets without a uuid
    } catch (Exception e) {
      LOG.warn("Cant get metrics for dataset {}", key, e);
    }
  }

  public void setId(String id) {
    this.id = id;
  }
}
