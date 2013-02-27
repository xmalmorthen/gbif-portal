package org.gbif.portal.action.species;

import org.gbif.portal.exception.NotFoundException;
import org.gbif.api.exception.ServiceUnavailableException;
import org.gbif.api.model.checklistbank.DatasetMetrics;
import org.gbif.api.model.checklistbank.NameUsage;
import org.gbif.api.model.checklistbank.NameUsageContainer;
import org.gbif.api.model.metrics.cube.OccurrenceCube;
import org.gbif.api.model.metrics.cube.ReadBuilder;
import org.gbif.api.model.registry.Dataset;
import org.gbif.api.service.checklistbank.DatasetMetricsService;
import org.gbif.api.service.checklistbank.NameUsageService;
import org.gbif.api.service.metrics.CubeService;
import org.gbif.api.service.registry.DatasetService;
import org.gbif.portal.action.BaseAction;
import org.gbif.portal.exception.ReferentialIntegrityException;

import java.util.Collection;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

import com.google.inject.Inject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class UsageBaseAction extends BaseAction {

  protected final Logger LOG = LoggerFactory.getLogger(getClass());

  @Inject
  protected NameUsageService usageService;
  @Inject
  protected DatasetService datasetService;
  @Inject
  protected DatasetMetricsService metricsService;
  @Inject
  protected CubeService occurrenceCubeService;

  protected Integer id;
  protected NameUsageContainer usage;
  protected Dataset dataset;
  protected DatasetMetrics metrics;
  private long numOccurrences;
  private long numGeoreferencedOccurrences;
  protected Map<UUID, Dataset> datasets = new HashMap<UUID, Dataset>();

  public String getChecklistName(UUID key) {
    if (key != null && datasets.containsKey(key)) {
      return datasets.get(key).getTitle();
    }
    return "";
  }

  public Dataset getDataset() {
    return dataset;
  }

  public Map<UUID, Dataset> getDatasets() {
    return datasets;
  }

  public Integer getId() {
    return id;
  }

  public DatasetMetrics getMetrics() {
    return metrics;
  }

  public long getNumOccurrences() {
    return numOccurrences;
  }

  public long getNumGeoreferencedOccurrences() {
    return numGeoreferencedOccurrences;
  }

  public NameUsageContainer getUsage() {
    return usage;
  }

  public boolean isNub() {
    return usage.isNub();
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
    if (datasetKey != null && !datasets.containsKey(datasetKey)) {
      try {
        datasets.put(datasetKey, datasetService.get(datasetKey));
      } catch (ServiceUnavailableException e) {
        LOG.error("Failed to load dataset with key {}", datasetKey);
        datasets.put(datasetKey, null);
      }
    }
  }

  /**
   * Loads a name usage and its checklist by the id parameter.
   * 
   * @throws NotFoundException if no usage for the given id can be found
   */
  public void loadUsage() {
    if (id == null) {
      throw new NotFoundException("No checklist usage id given");
    }
    NameUsage u = usageService.get(id, getLocale());
    if (u == null) {
      throw new NotFoundException("No usage found with id " + id);
    }
    usage = new NameUsageContainer(u);
    // load checklist
    dataset = datasetService.get(usage.getDatasetKey());
    if (dataset == null) {
      throw new ReferentialIntegrityException(NameUsage.class, id, "Missing dataset " + usage.getDatasetKey());
    }

    try {
      metrics = metricsService.get(usage.getDatasetKey());
    } catch (ServiceUnavailableException e) {
      LOG.error("Failed to load checklist metrics for dataset {}", usage.getDatasetKey());
    }

    try {
      numOccurrences = occurrenceCubeService.get(new ReadBuilder().at(OccurrenceCube.NUB_KEY, usage.getKey()));
      numGeoreferencedOccurrences =
        occurrenceCubeService.get(new ReadBuilder().at(OccurrenceCube.NUB_KEY, usage.getKey()).at(
          OccurrenceCube.IS_GEOREFERENCED, true));
    } catch (ServiceUnavailableException e) {
      LOG.error("Failed to load occurrence metrics for usage {}", usage.getKey(), e);
    }
  }

  public void setId(Integer id) {
    this.id = id;
  }
}
