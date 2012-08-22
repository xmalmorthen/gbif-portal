package org.gbif.portal.action.species;

import org.gbif.api.model.vocabulary.Rank;
import org.gbif.checklistbank.api.Constants;
import org.gbif.checklistbank.api.model.DatasetMetrics;
import org.gbif.checklistbank.api.model.vocabulary.Extension;
import org.gbif.checklistbank.api.service.DatasetMetricsService;
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

  public Integer getNumSpecies() {
    return numSpecies;
  }

  public Integer getNumInfraSpecies() {
    return numInfraSpecies;
  }

  public Integer getNumCommonNames() {
    return numCommonNames;
  }

  public Integer getNumLanguages() {
    return numLanguages;
  }
}
