package org.gbif.portal.action.species;

import org.gbif.api.exception.NotFoundException;
import org.gbif.api.exception.ServiceUnavailableException;
import org.gbif.checklistbank.api.model.DatasetMetrics;
import org.gbif.checklistbank.api.model.NameUsage;
import org.gbif.checklistbank.api.model.NameUsageContainer;
import org.gbif.checklistbank.api.service.DatasetMetricsService;
import org.gbif.checklistbank.api.service.NameUsageService;
import org.gbif.portal.action.BaseAction;
import org.gbif.registry.api.model.Dataset;
import org.gbif.registry.api.service.DatasetService;

import java.util.Collection;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

import com.google.inject.Inject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class UsageBaseAction extends BaseAction {

  private static final Logger LOG = LoggerFactory.getLogger(UsageBaseAction.class);

  @Inject
  protected NameUsageService usageService;
  @Inject
  protected DatasetService datasetService;
  @Inject
  protected DatasetMetricsService metricsService;

  protected Integer id;
  protected NameUsageContainer usage;
  protected Dataset dataset;
  protected DatasetMetrics metrics;
  protected Map<UUID, Dataset> datasets = new HashMap<UUID, Dataset>();

  /**
   * Loads a name usage and its checklist by the id parameter.
   *
   * @throws NotFoundException if no usage for the given id can be found
   */
  public void loadUsage() {
    if (id == null) {
      LOG.error("No checklist usage id given");
      throw new NotFoundException();
    }
    NameUsage u = usageService.get(id, getLocale());
    if (u == null) {
      LOG.error("No usage found with id {}", id);
      throw new NotFoundException();
    }
    usage = new NameUsageContainer(u);
    // load checklist
    dataset = datasetService.get(usage.getDatasetKey());
    try {
      metrics = metricsService.get(usage.getDatasetKey());
    } catch (ServiceUnavailableException e) {
      LOG.error("Failed to load checklist metrics for dataset {}", usage.getDatasetKey());
    }
  }

  /**
   * Populates the checklists map with the checklists for the given keys.
   * The method does not remove existing entries and can be called many times to add additional, new checklists.
   */
  protected void loadChecklists(Collection<UUID> checklistKeys) {
    for (UUID u : checklistKeys) {
      loadDataset(u);
    }
  }

  protected void loadDataset(UUID datasetKey) {
    if (datasetKey!=null && !datasets.containsKey(datasetKey)) {
      try {
        datasets.put(datasetKey, datasetService.get(datasetKey));
      } catch (ServiceUnavailableException e) {
        LOG.error("Failed to load dataset with key {}", datasetKey);
        datasets.put(datasetKey, null);
      }
    }
  }

  public void setId(Integer id) {
    this.id = id;
  }

  public Integer getId() {
    return id;
  }

  public NameUsageContainer getUsage() {
    return usage;
  }

  public Dataset getDataset() {
    return dataset;
  }

  public Map<UUID, Dataset> getDatasets() {
    return datasets;
  }

  public String getChecklistName(UUID key) {
    if (key != null && datasets.containsKey(key)) {
      return datasets.get(key).getTitle();
    }
    return "";
  }

  public boolean isNub() {
    return usage.isNub();
  }

  public DatasetMetrics getMetrics() {
    return metrics;
  }
}
