package org.gbif.portal.action.occurrence;

import org.gbif.api.model.Constants;
import org.gbif.api.model.occurrence.Occurrence;
import org.gbif.api.model.occurrence.search.OccurrenceSearchParameter;
import org.gbif.api.model.occurrence.search.OccurrenceSearchRequest;
import org.gbif.api.model.registry.Dataset;
import org.gbif.api.service.checklistbank.NameUsageService;
import org.gbif.api.service.occurrence.OccurrenceSearchService;
import org.gbif.api.service.registry.DatasetService;
import org.gbif.api.util.VocabularyUtils;
import org.gbif.api.vocabulary.BasisOfRecord;
import org.gbif.portal.action.BaseSearchAction;

import com.google.common.collect.Multimap;
import com.google.inject.Inject;

import static org.gbif.api.model.common.paging.PagingConstants.DEFAULT_PARAM_LIMIT;
import static org.gbif.api.model.common.paging.PagingConstants.DEFAULT_PARAM_OFFSET;

/**
 * Search action class for occurrence search page.
 */
public class SearchAction extends BaseSearchAction<Occurrence, OccurrenceSearchParameter, OccurrenceSearchRequest> {

  private static final long serialVersionUID = 4064512946598688405L;

  private final DatasetService datasetService;
  private final NameUsageService nameUsageService;


  /**
   * Constant that contains the prefix of a key to get a Basis of record name from the resource bundle file.
   */
  private static final String BASIS_OF_RECORD_KEY = "enum.basisofrecord.";

  @Inject
  public SearchAction(OccurrenceSearchService occurrenceSearchService, DatasetService datasetService,
    NameUsageService nameUsageService) {
    super(occurrenceSearchService, OccurrenceSearchParameter.class, new OccurrenceSearchRequest(DEFAULT_PARAM_OFFSET,
      DEFAULT_PARAM_LIMIT));
    this.datasetService = datasetService;
    this.nameUsageService = nameUsageService;
  }

  public BasisOfRecord[] getBasisOfRecords() {
    return BasisOfRecord.values();
  }

  /**
   * Gets the Dataset title, the key parameter is returned if either the Dataset doesn't exists or it
   * doesn't have a title.
   */
  public String getDatasetTitle(String key) {
    Dataset dataset = datasetService.get(key);
    if (dataset != null && dataset.getTitle() != null) {
      return dataset.getTitle();
    }
    return key;
  }


  // this method is only a convenience one exposing the request filters so the ftl templates dont need to be adapted
  public Multimap<OccurrenceSearchParameter, String> getFilters() {
    return searchRequest.getParameters();
  }

  /**
   * Gets the displayable value of filter parameter.
   */
  public String getFilterTitle(String filterKey, String filterValue) {
    OccurrenceSearchParameter parameter =
      (OccurrenceSearchParameter) VocabularyUtils.lookupEnum(filterKey, OccurrenceSearchParameter.class);
    if (parameter != null) {
      if (parameter == OccurrenceSearchParameter.TAXON_KEY) {
        return nameUsageService.get(Integer.parseInt(filterValue), null).getScientificName();
      } else if (parameter == OccurrenceSearchParameter.BASIS_OF_RECORD) {
        return getText(BASIS_OF_RECORD_KEY + filterValue);
      } else if (parameter == OccurrenceSearchParameter.DATASET_KEY) {
        return getDatasetTitle(filterValue);
      } else if (parameter == OccurrenceSearchParameter.DATE) {
        return getDateTitle(filterValue);
      } else if (parameter == OccurrenceSearchParameter.BOUNDING_BOX) {
        return getBoundingBoxTitle(filterValue);
      }
    }
    return filterValue;
  }

  /**
   * Gets the NUB key value.
   */
  public String getNubTaxonomyKey() {
    return Constants.NUB_TAXONOMY_KEY.toString();
  }

  /**
   * Returns the displayable label/value of date filter.
   */
  private String getDateTitle(String dateValue) {
    String label = dateValue;
    if (dateValue.contains(",")) {
      String[] dates = dateValue.split(",");
      label = "FROM " + dates[0] + " TO " + dates[1];
    }
    return label;
  }

  /**
   * Returns the displayable label/value of bounding box filter.
   */
  private String getBoundingBoxTitle(String bboxValue) {
    String[] coordinates = bboxValue.split(",");
    String label = "FROM " + coordinates[0] + " TO " + coordinates[1];
    return label;
  }

}
