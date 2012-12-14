package org.gbif.portal.action.species;

import org.gbif.api.model.Constants;
import org.gbif.api.model.checklistbank.DatasetMetrics;
import org.gbif.api.service.checklistbank.DatasetMetricsService;
import org.gbif.api.vocabulary.Extension;
import org.gbif.api.vocabulary.Rank;
import org.gbif.portal.action.BaseAction;

import java.util.UUID;

import com.google.inject.Inject;

import static org.gbif.api.model.Constants.NUB_TAXONOMY_KEY;

@SuppressWarnings("serial")
public class HomeAction extends BaseAction {

  public static final UUID COL_KEY = UUID.fromString("7ddf754f-d193-4cc9-b351-99906754a03b");


  @Inject
  private DatasetMetricsService metricsService;

  private DatasetMetrics colMetrics;
  private DatasetMetrics nubMetrics;

  @Override
  public String execute() {
    nubMetrics = metricsService.get(Constants.NUB_TAXONOMY_KEY);
    colMetrics = metricsService.get(COL_KEY);

    return SUCCESS;
  }

  /**
   * Exposed to allow easy access in freemarker.
   */
  public UUID getNubDatasetKey() {
    return NUB_TAXONOMY_KEY;
  }

  public DatasetMetrics getNubMetrics() {
    return nubMetrics;
  }

  public Integer getNubCommonNames() {
    return nubMetrics.getExtensionRecordCount(Extension.VERNACULAR_NAME);
  }

  public Integer getNubInfraSpecies() {
    return nubMetrics.getCountByRank(Rank.INFRASPECIFIC_NAME);
  }

  public Integer getNubLanguages() {
    return nubMetrics.getCountNamesByLanguage().size();
  }

  public Integer getNubSpecies() {
    return nubMetrics.getCountByRank(Rank.SPECIES);
  }

  public Integer getColSpecies() {
    return colMetrics.getCountByRank(Rank.SPECIES);
  }

  public DatasetMetrics getColMetrics() {
    return colMetrics;
  }

  public static UUID getColKey() {
    return COL_KEY;
  }
}
