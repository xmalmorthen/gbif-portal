package org.gbif.portal.action.dataset;

import org.gbif.api.exception.NotFoundException;
import org.gbif.api.exception.ServiceUnavailableException;
import org.gbif.portal.action.BaseAction;
import org.gbif.registry.api.model.Dataset;
import org.gbif.registry.api.model.NetworkEntityMetrics;
import org.gbif.registry.api.service.DatasetService;

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
  protected NetworkEntityMetrics metrics;
  @Inject
  protected DatasetService datasetService;


  @Override
  public String execute() {
    LOG.debug("Fetching detail for dataset id [{}]", id);
    if (Strings.isNullOrEmpty(id)) {
      throw new NotFoundException();
    }

    dataset = datasetService.get(id);
    if (dataset == null) {
      LOG.error("No dataset found with id {}", id);
      throw new NotFoundException();
    }

    // get metrics
    try {
      key = UUID.fromString(id);
      metrics = datasetService.getMetrics(key);
    } catch (NotFoundException e) {
      LOG.warn("Cant get metrics for dataset {}", key, e);
    } catch (IllegalArgumentException e) {
      // ignore external datasets without a uuid
    }
    // TODO: currently the getMetrics() just returns metrics for a checklist dataset, but if it is a
    // an occurrence DS, it sends a HTTP 500, which makes the DS detail page load fail. This catch should remain here
    // until the occurrence DS metrics is implemented and/or does not return a 500. Remove when implemented.
    catch (ServiceUnavailableException e) {
      metrics = new NetworkEntityMetrics();
    }

    return SUCCESS;
  }

  public String getId() {
    return id;
  }

  public UUID getKey() {
    return key;
  }

  public Dataset getDataset() {
    return dataset;
  }

  public Dataset getMember() {
    return dataset;
  }

  public NetworkEntityMetrics getMetrics() {
    return metrics;
  }

  public DatasetService getDatasetService() {
    return datasetService;
  }

  public void setId(String id) {
    this.id = id;
  }
}
