package org.gbif.portal.action.country;

import org.gbif.api.model.checklistbank.DatasetMetrics;
import org.gbif.api.model.common.paging.PagingRequest;
import org.gbif.api.model.common.paging.PagingResponse;
import org.gbif.api.model.common.search.SearchResponse;
import org.gbif.api.model.metrics.cube.OccurrenceCube;
import org.gbif.api.model.metrics.cube.ReadBuilder;
import org.gbif.api.model.registry2.Dataset;
import org.gbif.api.model.registry2.search.DatasetSearchParameter;
import org.gbif.api.model.registry2.search.DatasetSearchRequest;
import org.gbif.api.model.registry2.search.DatasetSearchResult;
import org.gbif.api.service.checklistbank.DatasetMetricsService;
import org.gbif.api.service.metrics.CubeService;
import org.gbif.api.service.occurrence.OccurrenceCountryIndexService;
import org.gbif.api.service.occurrence.OccurrenceDatasetIndexService;
import org.gbif.api.service.registry2.DatasetSearchService;
import org.gbif.api.service.registry2.DatasetService;
import org.gbif.api.service.registry2.NodeService;
import org.gbif.api.vocabulary.Country;
import org.gbif.api.vocabulary.registry2.DatasetType;
import org.gbif.portal.action.node.DetailAction;
import org.gbif.portal.exception.NotFoundException;
import org.gbif.portal.model.CountWrapper;
import org.gbif.portal.model.CountryMetrics;

import java.util.List;
import java.util.Map;
import java.util.UUID;

import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.google.inject.Inject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class CountryBaseAction extends DetailAction {
  private static Logger LOG = LoggerFactory.getLogger(CountryBaseAction.class);

  private String id;
  protected Country country;
  private CountryMetrics about;
  private CountryMetrics by;
  private List<CountWrapper<Country>> countries = Lists.newArrayList();
  private PagingResponse<Country> countryPage;

  protected OccurrenceDatasetIndexService datasetIndexService;
  protected OccurrenceCountryIndexService countryIndexService;
  protected DatasetService datasetService;
  protected DatasetSearchService datasetSearchService;
  protected DatasetMetricsService datasetMetricsService;

  @Inject
  public CountryBaseAction(NodeService nodeService, CubeService cubeService, OccurrenceDatasetIndexService datasetIndexService, OccurrenceCountryIndexService countryIndexService, DatasetService datasetService, DatasetSearchService datasetSearchService, DatasetMetricsService datasetMetricsService) {
    super(nodeService, cubeService);
    this.datasetIndexService = datasetIndexService;
    this.countryIndexService = countryIndexService;
    this.datasetService = datasetService;
    this.datasetSearchService = datasetSearchService;
    this.datasetMetricsService = datasetMetricsService;
  }

  @Override
  public String execute() throws Exception {
    country = Country.fromIsoCode(id);
    if (country == null) {
      throw new NotFoundException("No country found with ISO code [" + id + ']');
    }

    member = nodeService.getByCountry(country);
    sortContacts();

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
    final int organizations = -1;

    final long occRecords = cubeService.get(new ReadBuilder().at(OccurrenceCube.COUNTRY, country));

    final long occDatasets = loadAboutDatasetsPage(numDatasetsToLoad);

    // find number of external datasets
    DatasetSearchRequest search = new DatasetSearchRequest();
    search.addTypeFilter(DatasetType.METADATA);
    search.addCountryFilter(country);
    search.setLimit(0);
    SearchResponse<DatasetSearchResult, DatasetSearchParameter> resp  = datasetSearchService.search(search);
    final long extDatasets = resp.getCount();

    int countryCount = loadCountryPage(true, numCountriesToLoad);

    about = new CountryMetrics(occDatasets, occRecords, chkDatasets, chkRecords, extDatasets, organizations, countryCount);
  }

  protected void buildByMetrics(int numDatasetsToLoad, int numCountriesToLoad) {
    final long occRecords = cubeService.get(new ReadBuilder().at(OccurrenceCube.HOST_COUNTRY, country));

    // we only want the counts here
    PagingRequest p = new PagingRequest(0, 0);
    final long occDatasets = datasetService.listByCountry(country, DatasetType.OCCURRENCE, p).getCount();
    final long chkDatasets = datasetService.listByCountry(country, DatasetType.CHECKLIST, p).getCount();
    final long extDatasets = datasetService.listByCountry(country, DatasetType.METADATA, p).getCount();
    final int organizations = -1;

    long chkRecords = 0;
    // for total checklist counts we need to retrieve the stats for every single checklist
    // we do not have a checklist cube yet

    // quick checklist count cache as checklist metrics are performance critical
    Map<UUID, Integer> checklistCounts = Maps.newHashMap();

    p = new PagingRequest(0, 200);  // there are only 100 checklists alltogether!
    for (Dataset chkl : datasetService.listByCountry(country, DatasetType.CHECKLIST, p).getResults()) {
      DatasetMetrics metric = datasetMetricsService.get(chkl.getKey());
      if (metric != null) {
        checklistCounts.put(chkl.getKey(), metric.getCountIndexed());
        // count them all
        chkRecords += metric.getCountIndexed();
      } else {
        checklistCounts.put(chkl.getKey(), 0);
      }
    }

    // load full datasets preview if requested
    if (numDatasetsToLoad > 0) {
      p = new PagingRequest(0, numDatasetsToLoad);
      for (Dataset d : datasetService.listByCountry(country, null, p).getResults()) {
        final long dsCnt;
        final long dsGeoCnt;
        if (DatasetType.OCCURRENCE == d.getType()) {
          dsCnt = cubeService.get(new ReadBuilder().at(OccurrenceCube.DATASET_KEY, d.getKey()));
          dsGeoCnt = cubeService.get(new ReadBuilder().at(OccurrenceCube.DATASET_KEY, d.getKey()).at(OccurrenceCube.IS_GEOREFERENCED, true));

        } else if (DatasetType.CHECKLIST == d.getType()) {
          // we have all checklist counts cached
          dsCnt = checklistCounts.get(d.getKey());
          dsGeoCnt = 0;

        } else {
          dsCnt = 0;
          dsGeoCnt= 0;
        }
        datasets.add(new CountWrapper<Dataset>(d, dsCnt, dsGeoCnt));
      }
    }

    int countryCount = loadCountryPage(false, numCountriesToLoad);

    by = new CountryMetrics(occDatasets, occRecords, chkDatasets, chkRecords, extDatasets, organizations, countryCount);
  }

  protected int loadCountryPage(boolean isAboutCountry, int limit) {
    try {
      Map<Country, Long> cMap;
      if (isAboutCountry) {
        cMap = countryIndexService.publishingCountriesForCountry(country);
      } else {
        cMap = countryIndexService.countriesForPublishingCountry(country);
      }

      countryPage = new PagingResponse<Country>(getOffset(), limit, (long) cMap.size());
      loadCountryList(cMap, isAboutCountry, limit);

      return cMap.size();

    } catch (RuntimeException e) {
      LOG.error("Cannot get country metrics", e);
    }
    return 0;
  }

  /**
   * Honors the offset paging parameter.
   * @return the number of all datasets having data about this country
   */
  protected int loadAboutDatasetsPage(int limit) {
    Map<UUID, Integer> dsMetrics = datasetIndexService.occurrenceDatasetsForCountry(country);
    int idx = 0;
    for (Map.Entry<UUID, Integer> metric : dsMetrics.entrySet()) {
      if (idx >= getOffset() + limit) {
        break;
      }
      // only load the requested page
      if (idx >= getOffset()) {
        Dataset d = datasetService.get(metric.getKey());
        if (d == null) {
          LOG.warn("Dataset in cube, but not in registry; {}", metric.getKey());

        } else {
          long total = cubeService.get(new ReadBuilder()
            .at(OccurrenceCube.DATASET_KEY, d.getKey()));
          datasets.add(new CountWrapper(d, metric.getValue(), total));
        }
      }
      idx++;
    }

    datasetPage = new PagingResponse<Dataset>(getOffset(), limit, (long) dsMetrics.size());

    return dsMetrics.size();
  }

  private void loadCountryList(Map<Country, Long> cMetrics, boolean isAboutCountry, int limit) {
    ReadBuilder rb = new ReadBuilder().at(OccurrenceCube.IS_GEOREFERENCED, true);
    if (isAboutCountry) {
      rb.at(OccurrenceCube.COUNTRY, country);
    } else {
      rb.at(OccurrenceCube.HOST_COUNTRY, country);
    }

    int idx = 0;
    for (Map.Entry<Country, Long> metric : cMetrics.entrySet()) {
      if (idx >= getOffset() + limit) {
        break;
      }

      // only load the requested page
      if (idx >= getOffset()) {
        if (isAboutCountry) {
          rb.at(OccurrenceCube.HOST_COUNTRY, metric.getKey());
        } else {
          rb.at(OccurrenceCube.COUNTRY, metric.getKey());
        }

        long geoCnt = cubeService.get(rb);
        countries.add(new CountWrapper(metric.getKey(), metric.getValue(), geoCnt));
      }

      idx++;
    }
  }

  public void setId(String id) {
    this.id = id;
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

  public List<CountWrapper<Country>> getCountries() {
    return countries;
  }

  public String getIsocode() {
    return country.getIso2LetterCode();
  }

  public PagingResponse<Country> getCountryPage() {
    return countryPage;
  }
}
