package org.gbif.portal.action.species;

import org.gbif.api.model.checklistbank.Constants;
import org.gbif.api.model.checklistbank.DatasetMetrics;
import org.gbif.api.model.vocabulary.Rank;
import org.gbif.api.service.checklistbank.DatasetMetricsService;
import org.gbif.api.vocabulary.Extension;
import org.gbif.portal.action.BaseAction;

import com.google.inject.Inject;

public class HomeAction extends BaseAction {

  @Inject
  private DatasetMetricsService metricsService;

  private DatasetMetrics nubMetrics;
  private Integer numSpecies;
  private Integer numInfraSpecies;
  private Integer numCommonNames = 0;
  private Integer numLanguages;

  @Override
  public String execute() {
    nubMetrics = metricsService.get(Constants.NUB_TAXONOMY_KEY);

    numSpecies = nubMetrics.getCountByRank(Rank.SPECIES);
    numInfraSpecies = nubMetrics.getCountByRank(Rank.INFRASPECIFIC_NAME);
    numCommonNames += nubMetrics.getExtensionRecordCount(Extension.VERNACULAR_NAME);
    numLanguages = nubMetrics.getCountNamesByLanguage().size();

    return SUCCESS;
  }

  public DatasetMetrics getNubMetrics() {
    return nubMetrics;
  }

  public Integer getNumCommonNames() {
    return numCommonNames;
  }

  public Integer getNumInfraSpecies() {
    return numInfraSpecies;
  }

  public Integer getNumLanguages() {
    return numLanguages;
  }

  public Integer getNumSpecies() {
    return numSpecies;
  }
}
