package org.gbif.portal.action.country;

import org.gbif.api.service.checklistbank.DatasetMetricsService;
import org.gbif.api.service.metrics.CubeService;
import org.gbif.api.service.occurrence.OccurrenceCountryIndexService;
import org.gbif.api.service.occurrence.OccurrenceDatasetIndexService;
import org.gbif.api.service.registry2.DatasetSearchService;
import org.gbif.api.service.registry2.DatasetService;
import org.gbif.api.service.registry2.NodeService;

import com.google.inject.Inject;

public class SeeMoreAction extends CountryBaseAction {

  private boolean about = false;

  @Inject
  public SeeMoreAction(NodeService nodeService, CubeService cubeService,
    OccurrenceDatasetIndexService datasetIndexService, OccurrenceCountryIndexService countryIndexService,
    DatasetService datasetService, DatasetSearchService datasetSearchService,
    DatasetMetricsService datasetMetricsService) {
    super(nodeService, cubeService, datasetIndexService, countryIndexService, datasetService, datasetSearchService,
      datasetMetricsService);
  }

  public String datasets() throws Exception {
    super.execute();

    loadAboutDatasetsPage(25);

    return SUCCESS;
  }

  public String countriesPublished() throws Exception {
    super.execute();

    loadCountryPage(about, 25);

    return SUCCESS;
  }

  public String countriesAbout() throws Exception {
    about=true;
    return countriesPublished();
  }

  public String publishers() throws Exception {
    super.execute();

    loadPublishers(25);

    return SUCCESS;
  }

  public boolean isAbout() {
    return about;
  }
}
