package org.gbif.portal.action.occurrence;

import org.gbif.api.exception.NotFoundException;
import org.gbif.occurrencestore.api.model.Occurrence;
import org.gbif.occurrencestore.api.service.OccurrenceService;
import org.gbif.portal.action.BaseAction;
import org.gbif.registry.api.model.Dataset;
import org.gbif.registry.api.model.NetworkEntityMetrics;
import org.gbif.registry.api.service.DatasetService;

import com.google.inject.Inject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class DetailAction extends BaseAction {

  private static final Logger LOG = LoggerFactory.getLogger(DetailAction.class);

  @Inject
  private OccurrenceService occurrenceService;
  @Inject
  private DatasetService datasetService;

  private Integer id;
  private Occurrence occ;
  private Dataset dataset;
  private NetworkEntityMetrics metrics;

  @Override
  public String execute() {
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
    try {
      metrics = datasetService.getMetrics(occ.getDatasetKey());
    } catch (NotFoundException e) {
      LOG.warn("Cant get metrics for dataset {}", occ.getDatasetKey(), e);
    }

    return SUCCESS;
  }

  public String verbatim() {
    LOG.debug("Loading raw details for occurrence id [{}]", id);
    return execute();
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

  public NetworkEntityMetrics getMetrics() {
    return metrics;
  }
}
