package org.gbif.portal.action.dataset;

import org.gbif.api.exception.NotFoundException;
import org.gbif.api.model.vocabulary.Kingdom;
import org.gbif.api.model.vocabulary.Rank;
import org.gbif.portal.action.BaseAction;
import org.gbif.registry.api.model.Dataset;
import org.gbif.registry.api.model.NetworkEntityMetrics;
import org.gbif.registry.api.model.vocabulary.Extension;
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
    //TODO: remove once metrics webservice works
    metrics = new NetworkEntityMetrics();
    metrics.getCountExtensionRecords().put(Extension.IMAGE, 4);
    metrics.getCountExtensionRecords().put(Extension.VERNACULAR_NAME, 44);
    metrics.getCountByKingdom().put(Kingdom.ANIMALIA, 400);
    metrics.getCountByKingdom().put(Kingdom.PLANTAE, 300);
    metrics.getCountByKingdom().put(Kingdom.VIRUSES, 4);
    metrics.getCountByKingdom().put(Kingdom.FUNGI, 14);
    metrics.getCountByRank().put(Rank.SPECIES, 777);
    metrics.getCountByRank().put(Rank.FAMILY, 77);
    metrics.getCountByRank().put(Rank.KINGDOM, 7);
    metrics.getCountByRank().put(Rank.INFRASPECIFIC_NAME, 99);
    metrics.setCountIndexed(432011);
    try {
      UUID key = UUID.fromString(id);
      metrics.setNetworkEntityKey(key);
      //metrics = datasetService.getMetrics(key);
    } catch (IllegalArgumentException e) {
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
