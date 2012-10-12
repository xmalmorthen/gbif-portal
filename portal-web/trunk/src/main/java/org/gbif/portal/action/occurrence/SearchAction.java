package org.gbif.portal.action.occurrence;

import org.gbif.api.model.checklistbank.Constants;
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

  @Override
  public String execute() {
    return super.execute();
  }

  public BasisOfRecord[] getBasisOfRecords() {
    return BasisOfRecord.values();
  }

  /**
   * Gets the title of a data set byt its key.
   * TODO: should this not be cached? or be a prepopulated map like we have in other places like UsageBaseAction?
   */
  public String getDatasetTitle(String datasetKey) {
    Dataset dataset = datasetService.get(datasetKey);
    return dataset.getTitle();
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

}
