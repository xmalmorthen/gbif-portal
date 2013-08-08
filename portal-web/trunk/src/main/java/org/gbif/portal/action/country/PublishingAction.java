package org.gbif.portal.action.country;

import org.gbif.api.model.metrics.cube.OccurrenceCube;
import org.gbif.api.model.metrics.cube.ReadBuilder;
import org.gbif.api.service.checklistbank.DatasetMetricsService;
import org.gbif.api.service.metrics.CubeService;
import org.gbif.api.service.occurrence.OccurrenceCountryIndexService;
import org.gbif.api.service.occurrence.OccurrenceDatasetIndexService;
import org.gbif.api.service.registry.DatasetSearchService;
import org.gbif.api.service.registry.DatasetService;
import org.gbif.api.service.registry.NodeService;

import com.google.inject.Inject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class PublishingAction extends CountryBaseAction {
  private static Logger LOG = LoggerFactory.getLogger(PublishingAction.class);

  private int otherCountries;
  private long otherCountryRecords;
  private double otherCountryPercentage;

  @Inject
  public PublishingAction(NodeService nodeService, CubeService cubeService,
    OccurrenceDatasetIndexService datasetIndexService, OccurrenceCountryIndexService countryIndexService,
    DatasetService datasetService, DatasetSearchService datasetSearchService,
    DatasetMetricsService datasetMetricsService) {
    super(nodeService, cubeService, datasetIndexService, countryIndexService, datasetService, datasetSearchService,
      datasetMetricsService);
  }

  @Override
  public String execute() throws Exception {
    super.execute();

    buildByMetrics(7, 7);

    // calc other countries metrics
    long inCountryRecords = cubeService.get(
      new ReadBuilder().at(OccurrenceCube.HOST_COUNTRY, country).at(OccurrenceCube.COUNTRY, country)
    );
    otherCountryRecords = getBy().getOccurrenceRecords() - inCountryRecords;
    otherCountryPercentage = 100d * (double) otherCountryRecords / getBy().getOccurrenceRecords();
    otherCountries = getBy().getCountries() - 1;

    return SUCCESS;
  }

  public int getOtherCountries() {
    return otherCountries;
  }

  public long getOtherCountryRecords() {
    return otherCountryRecords;
  }

  public double getOtherCountryPercentage() {
    return otherCountryPercentage;
  }

  public static void main (String[] args) {
    long all = 14721982;
    long home = 446987;
    double perc = (double) home / all;

    System.out.print(perc);
  }
}
