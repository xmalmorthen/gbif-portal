package org.gbif.portal.action.occurrence;

import org.gbif.api.exception.NotFoundException;
import org.gbif.checklistbank.api.model.DatasetMetrics;
import org.gbif.checklistbank.api.model.NameUsage;
import org.gbif.checklistbank.api.service.NameUsageService;
import org.gbif.occurrencestore.api.model.Occurrence;
import org.gbif.occurrencestore.api.service.OccurrenceService;
import org.gbif.portal.action.BaseAction;
import org.gbif.registry.api.model.Dataset;
import org.gbif.registry.api.service.DatasetService;

import com.google.inject.Inject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class OccurrenceBaseAction extends BaseAction {

  private static final Logger LOG = LoggerFactory.getLogger(OccurrenceBaseAction.class);

  @Inject
  protected OccurrenceService occurrenceService;
  @Inject
  protected DatasetService datasetService;
  @Inject
  protected NameUsageService usageService;

  protected Integer id;
  protected Occurrence occ;
  protected NameUsage nub;
  protected Dataset dataset;
  protected DatasetMetrics metrics;

  protected void loadDetail() {
    if (id == null) {
      LOG.error("No occurrence id given");
      throw new NotFoundException();
    }
    occ = occurrenceService.get(id);
    if (occ == null) {
      LOG.error("No occurrence found with id {}", id);
      throw new NotFoundException();
    }
    // load dataset
    dataset = datasetService.get(occ.getDatasetKey());
    // load name usage nub object
    if (occ.getNubKey() != null){
      nub = usageService.get(occ.getNubKey(), getLocale());
    }
    //TODO: load metrics for occurrence once implemented
    metrics = null;
  }

  public Integer getId() {
    return id;
  }

  public void setId(Integer id) {
    this.id = id;
  }

  public Occurrence getOcc() {
    return occ;
  }

  public Dataset getDataset() {
    return dataset;
  }

  public DatasetMetrics getMetrics() {
    return metrics;
  }

  public NameUsage getNub() {
    return nub;
  }
}
