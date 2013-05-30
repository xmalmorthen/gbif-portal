package org.gbif.portal.action.country;

import org.gbif.api.model.checklistbank.DatasetMetrics;
import org.gbif.api.model.common.paging.PagingRequest;
import org.gbif.api.model.common.search.SearchResponse;
import org.gbif.api.model.metrics.cube.Dimension;
import org.gbif.api.model.metrics.cube.OccurrenceCube;
import org.gbif.api.model.metrics.cube.ReadBuilder;
import org.gbif.api.model.registry2.Dataset;
import org.gbif.api.model.registry2.Endpoint;
import org.gbif.api.model.registry2.Node;
import org.gbif.api.model.registry2.search.DatasetSearchParameter;
import org.gbif.api.model.registry2.search.DatasetSearchRequest;
import org.gbif.api.model.registry2.search.DatasetSearchResult;
import org.gbif.api.service.checklistbank.DatasetMetricsService;
import org.gbif.api.service.metrics.CubeService;
import org.gbif.api.service.occurrence.OccurrenceDatasetIndexService;
import org.gbif.api.service.registry2.DatasetSearchService;
import org.gbif.api.service.registry2.DatasetService;
import org.gbif.api.service.registry2.NodeService;
import org.gbif.api.service.registry2.OrganizationService;
import org.gbif.api.vocabulary.Country;
import org.gbif.api.vocabulary.registry2.DatasetType;
import org.gbif.api.vocabulary.registry2.EndpointType;
import org.gbif.portal.exception.NotFoundException;
import org.gbif.portal.model.CountWrapper;
import org.gbif.portal.model.CountryMetrics;

import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.SortedMap;
import java.util.UUID;

import com.google.common.collect.Lists;
import com.google.inject.Inject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class CountryBaseAction extends org.gbif.portal.action.BaseAction {
  private static Logger LOG = LoggerFactory.getLogger(CountryBaseAction.class);

  private String id;
  protected Country country;
  protected Node node;
  private List<CountWrapper<Dataset>> datasets = Lists.newArrayList();
  private List<CountWrapper<Country>> countries = Lists.newArrayList();
  private CountryMetrics about;
  private CountryMetrics by;

  @Inject
  protected NodeService nodeService;
  @Inject
  protected CubeService cubeService;
  @Inject
  protected OccurrenceDatasetIndexService indexService;
  @Inject
  protected DatasetService datasetService;
  @Inject
  protected DatasetSearchService datasetSearchService;
  @Inject
  protected OrganizationService organizationService;
  @Inject
  protected DatasetMetricsService datasetMetricsService;

  @Override
  public String execute() throws Exception {
    country = Country.fromIsoCode(id);
    if (country == null) {
      throw new NotFoundException("No country found with ISO code" + id);
    }

    node = nodeService.getByCountry(country);
    return SUCCESS;
  }

  /**
   * populates the about field and optionally also loads the first requested datasets into the datasets property.
   * This allows to only call the index service once effectively and process its response.
   * @param numDatasetsToLoad number of datasets to load, if zero or negative doesnt load any
   */
  protected void buildAboutMetrics(int numDatasetsToLoad, int numCountriesToLoad) {
    //TODO: use checklist search to populate this???
    final long chkRecords = -1;
    final long chkDatasets = -1;
    final int institutions = -1;

    final long occRecords = cubeService.get(new ReadBuilder().at(OccurrenceCube.COUNTRY, country));

    SortedMap<UUID, Integer> datasetIndex = indexService.occurrenceDatasetsForCountry(country);
    final long occDatasets = datasetIndex.size();
    loadDatasets(datasetIndex, numDatasetsToLoad);

    // find number of external datasets
    DatasetSearchRequest search = new DatasetSearchRequest();
    search.addTypeFilter(DatasetType.METADATA);
    search.addCountryFilter(country);
    search.setLimit(0);
    SearchResponse<DatasetSearchResult, DatasetSearchParameter> resp  = datasetSearchService.search(search);
    final long extDatasets = resp.getCount();

    int countryCount = getCountryMetrics(true, numCountriesToLoad);

    about = new CountryMetrics(occDatasets, occRecords, chkDatasets, chkRecords, extDatasets, institutions, countryCount);
  }

  protected void buildByMetrics(int numDatasetsToLoad, int numCountriesToLoad) {
    final long occRecords = cubeService.get(new ReadBuilder().at(OccurrenceCube.HOST_COUNTRY, country));
    //TODO: load all checklist metrics to populate this???
    final long chkRecords = -1;

    // we only want the counts here
    PagingRequest p = new PagingRequest(0, 0);
    final long occDatasets = datasetService.listByCountry(country, DatasetType.OCCURRENCE, p).getCount();
    final long chkDatasets = datasetService.listByCountry(country, DatasetType.CHECKLIST, p).getCount();
    final long extDatasets = datasetService.listByCountry(country, DatasetType.METADATA, p).getCount();
    final int institutions = -1;

    // load full datasets preview if requested
    if (numCountriesToLoad > 0) {
      p = new PagingRequest(0, numDatasetsToLoad);
      for (Dataset d : datasetService.listByCountry(country, null, p).getResults()) {
        final long dsCnt;
        final long dsGeoCnt;
        if (DatasetType.OCCURRENCE == d.getType()) {
          dsCnt = cubeService.get(new ReadBuilder().at(OccurrenceCube.DATASET_KEY, d.getKey()));
          dsGeoCnt = cubeService.get(new ReadBuilder().at(OccurrenceCube.DATASET_KEY, d.getKey()).at(OccurrenceCube.IS_GEOREFERENCED, true));

        } else if (DatasetType.CHECKLIST == d.getType()) {
          DatasetMetrics checklistMetric = datasetMetricsService.get(d.getKey());
          dsCnt = checklistMetric.getCountIndexed();
          dsGeoCnt = -1;

        } else {
          dsCnt = 0;
          dsGeoCnt= 0;
        }
        datasets.add(new CountWrapper<Dataset>(d, dsCnt, dsGeoCnt));
      }
    }

    int countryCount = getCountryMetrics(false, numCountriesToLoad);

    by = new CountryMetrics(occDatasets, occRecords, chkDatasets, chkRecords, extDatasets, institutions, countryCount);
  }

  private int getCountryMetrics(boolean isAboutCountry, int numCountriesToLoad) {
    final Dimension<Country> staticFilter;
    final Dimension<Country> dynamicFilter;
    if (isAboutCountry) {
      staticFilter = OccurrenceCube.COUNTRY;
      dynamicFilter = OccurrenceCube.HOST_COUNTRY;
    } else {
      staticFilter = OccurrenceCube.HOST_COUNTRY;
      dynamicFilter = OccurrenceCube.COUNTRY;
    }

    int count = 0;
    try {
      // load metrics for all countries so we can sort them :(
      for (Country c : Country.values()) {
        if (c.isOfficial()) {
          long cnt = cubeService.get(new ReadBuilder().at(staticFilter, country).at(dynamicFilter, c));
          if (cnt > 0) {
            count++;
            if (numCountriesToLoad > 0) {
              countries.add(new CountWrapper<Country>(c, cnt));
            }
          }
        }
      }
      Collections.sort(countries);

      // load geo ref counts for first x records
      for (int idx = 0; idx < numCountriesToLoad && idx < countries.size(); idx++) {
        CountWrapper<Country> cw = countries.get(idx);
        cw.setGeoCount(cubeService.get(new ReadBuilder()
          .at(staticFilter, country).at(dynamicFilter, cw.getObj()).at(OccurrenceCube.IS_GEOREFERENCED, true)
        ));
      }
    } catch (RuntimeException e) {
      LOG.error("Cannot get country metrics", e);
    }

    return count;
  }

  private void loadDatasets(SortedMap<UUID, Integer> dsMetrics, int numberToLoad) {
    for (Map.Entry<UUID, Integer> metric : dsMetrics.entrySet()) {
      if (numberToLoad <= 0) {
        break;
      }
      numberToLoad--;
      Dataset d = datasetService.get(metric.getKey());
      long geoCnt = cubeService.get(new ReadBuilder()
        .at(OccurrenceCube.DATASET_KEY, d.getKey())
        .at(OccurrenceCube.IS_GEOREFERENCED, true));
      datasets.add(new CountWrapper(d, metric.getValue(), geoCnt));
    }
  }

  public String getId() {
    return country == null ? null : country.getIso2LetterCode();
  }

  public void setId(String id) {
    this.id = id;
  }

  public Node getNode() {
    return node;
  }

  public Country getCountry() {
    return country;
  }

  public CountryMetrics getAbout() {
    return about;
  }

  public CountryMetrics getBy() {
    return by;
  }

  public List<CountWrapper<Dataset>> getDatasets() {
    return datasets;
  }

  public List<CountWrapper<Country>> getCountries() {
    return countries;
  }

  public String getFeed() {
    //TODO: use real endpoints when available in API
    if (node != null && !node.getEndpoints().isEmpty()) {
      for (Endpoint e : node.getEndpoints()) {
        if (EndpointType.FEED == e.getType()) {
          return e.getUrl();
        }
      }
    }
    return null;
  }
}
