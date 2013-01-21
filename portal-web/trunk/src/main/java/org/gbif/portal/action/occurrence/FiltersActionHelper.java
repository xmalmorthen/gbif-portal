package org.gbif.portal.action.occurrence;

import org.gbif.api.model.Constants;
import org.gbif.api.model.checklistbank.NameUsage;
import org.gbif.api.model.checklistbank.NameUsageMatch;
import org.gbif.api.model.checklistbank.NameUsageMatch.MatchType;
import org.gbif.api.model.checklistbank.search.NameUsageSearchParameter;
import org.gbif.api.model.checklistbank.search.NameUsageSearchResult;
import org.gbif.api.model.checklistbank.search.NameUsageSuggestRequest;
import org.gbif.api.model.common.search.SearchRequest;
import org.gbif.api.model.occurrence.search.OccurrenceSearchParameter;
import org.gbif.api.model.registry.Dataset;
import org.gbif.api.service.checklistbank.NameUsageMatchingService;
import org.gbif.api.service.checklistbank.NameUsageSearchService;
import org.gbif.api.service.checklistbank.NameUsageService;
import org.gbif.api.service.registry.DatasetService;
import org.gbif.api.util.SearchTypeValidator;
import org.gbif.api.util.VocabularyUtils;
import org.gbif.api.vocabulary.BasisOfRecord;
import org.gbif.api.vocabulary.Country;
import org.gbif.portal.action.BaseAction;
import org.gbif.portal.model.NameUsageSearchSuggestions;

import java.lang.reflect.InvocationTargetException;
import java.util.Enumeration;
import java.util.List;
import java.util.Locale;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;

import com.google.common.base.Predicate;
import com.google.common.collect.Lists;
import com.google.common.collect.Sets;
import com.google.common.primitives.Ints;
import com.google.inject.Inject;
import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.util.LocalizedTextUtil;
import org.apache.commons.beanutils.PropertyUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Utility class for common operations of SearchAction and DownloadHomeAction.
 */
public class FiltersActionHelper {

  private final DatasetService datasetService;
  private final NameUsageService nameUsageService;
  private final NameUsageSearchService nameUsageSearchService;
  private final NameUsageMatchingService nameUsageMatchingService;
  private static final int SUGGESTIONS_LIMIT = 10;
  private static final Logger LOG = LoggerFactory.getLogger(FiltersActionHelper.class);

  private static final String GEOREFERENCING_LEGEND = "Georeferenced records only";

  private static final Set<Country> countries = Sets.immutableEnumSet(Sets.filter(
    Sets.newHashSet(Country.values()),
    new Predicate<Country>() {

      @Override
      public boolean apply(Country country) {
        return country.isOfficial();
      }
    }));
  /**
   * Constant that contains the prefix of a key to get a Basis of record name from the resource bundle file.
   */
  private static final String BASIS_OF_RECORD_KEY = "enum.basisofrecord.";

  @Inject
  public FiltersActionHelper(DatasetService datasetService, NameUsageService nameUsageService,
    NameUsageSearchService nameUsageSearchService, NameUsageMatchingService nameUsageMatchingService) {
    this.datasetService = datasetService;
    this.nameUsageService = nameUsageService;
    this.nameUsageSearchService = nameUsageSearchService;
    this.nameUsageMatchingService = nameUsageMatchingService;
  }

  /**
   * Returns the list of {@link BasisOfRecord} literals.
   */
  public BasisOfRecord[] getBasisOfRecords() {
    return BasisOfRecord.values();
  }

  /**
   * Returns the list of {@link Country} literals.
   */
  public Set<Country> getCountries() {
    return countries;
  }

  public String getCountryTitle(String value) {
    Country country = Country.fromIsoCode(value);
    if (country != null) {
      return country.getTitle();
    }
    return value;
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

  /**
   * Gets the displayable value of filter parameter.
   */
  public String getFilterTitle(String filterKey, String filterValue) {
    OccurrenceSearchParameter parameter =
      (OccurrenceSearchParameter) VocabularyUtils.lookupEnum(filterKey, OccurrenceSearchParameter.class);
    if (parameter != null) {
      if (parameter == OccurrenceSearchParameter.TAXON_KEY) {
        return getScientificName(filterValue);
      } else if (parameter == OccurrenceSearchParameter.BASIS_OF_RECORD) {
        return LocalizedTextUtil.findDefaultText(BASIS_OF_RECORD_KEY + filterValue, getLocale());
      } else if (parameter == OccurrenceSearchParameter.DATASET_KEY) {
        return getDatasetTitle(filterValue);
      } else if (parameter == OccurrenceSearchParameter.DATE) {
        return getDateTitle(filterValue);
      } else if (parameter == OccurrenceSearchParameter.BOUNDING_BOX) {
        return getBoundingBoxTitle(filterValue);
      } else if (parameter == OccurrenceSearchParameter.GEOREFERENCED) {
        return getGeoreferencedTitle(filterValue);
      } else if (parameter == OccurrenceSearchParameter.COUNTRY) {
        return getCountryTitle(filterValue);
      }
    }
    return filterValue;
  }

  public String getGeoreferencedTitle(String value) {
    if (Boolean.parseBoolean(value)) {
      return GEOREFERENCING_LEGEND;
    } else {
      return "Non " + GEOREFERENCING_LEGEND;
    }
  }

  /**
   * Gets the locale from the current web context.
   */
  public Locale getLocale() {
    ActionContext ctx = ActionContext.getContext();
    if (ctx != null) {
      return ctx.getLocale();
    } else {
      if (LOG.isDebugEnabled()) {
        LOG.debug("Action context not initialized");
      }
      return null;
    }
  }

  /**
   * Gets a scientific name associated to the taxon key parameter.
   * If a name usage doesn't exist for that taxon key, the same key is returned.
   */
  public String getScientificName(String taxonKey) {
    Integer taxonKeyInt = Ints.tryParse(taxonKey);
    if (taxonKeyInt != null) {
      NameUsage nameUsage = nameUsageService.get(taxonKeyInt, null);
      if (nameUsage != null && nameUsage.getScientificName() != null) {
        return nameUsage.getScientificName();
      }
    }
    return taxonKey;
  }

  /**
   * Validates if a string (not a number) value was sent for the TAXON_KEY parameter.
   * If the value is not a number, a search by scientific name is performed and, if any, the available suggestions are
   * returned.
   */
  public NameUsageSearchSuggestions processNameUsagesSuggestions(HttpServletRequest request) {
    String[] values = request.getParameterValues(OccurrenceSearchParameter.TAXON_KEY.name());
    NameUsageSearchSuggestions nameUsagesSuggestion = new NameUsageSearchSuggestions();
    if (values != null) { // there are not value
      // request instance is created here for future reuse
      NameUsageSuggestRequest suggestRequest = new NameUsageSuggestRequest();
      suggestRequest.setLimit(SUGGESTIONS_LIMIT);
      suggestRequest.addParameter(NameUsageSearchParameter.DATASET_KEY, Constants.NUB_TAXONOMY_KEY.toString());
      for (String value : values) {
        if (Ints.tryParse(value) == null) { // Is not a integer
          NameUsageMatch nameUsageMatch =
            nameUsageMatchingService.match(value, null, null, null, null, null, null, null);
          List<NameUsageSearchResult> suggestions = Lists.newArrayList();
          if (nameUsageMatch.getMatchType() == MatchType.NONE) {
            suggestRequest.setQ(value);
            suggestions = nameUsageSearchService.suggest(suggestRequest);
            // suggestions are stored in map: "parameter value" -> list of suggestions
            nameUsagesSuggestion.getNameUsagesSuggestions().put(value, suggestions);
          } else {
            NameUsageSearchResult nameUsageSearchResult = toNameUsageResult(nameUsageMatch);
            nameUsagesSuggestion.getNameUsagesReplacements().put(value, nameUsageSearchResult);
          }
        }
      }
    }
    return nameUsagesSuggestion;
  }

  /**
   * Replace the taxon_key parameters that have a scientific name that could be interpreted directly.
   */
  public void replaceKnownNameUsages(SearchRequest<OccurrenceSearchParameter> searchRequest,
    NameUsageSearchSuggestions nameUsagesSuggestions) {
    if (nameUsagesSuggestions.hasReplacements()) {
      List<String> paramValues =
        Lists.newArrayList(searchRequest.getParameters().get(OccurrenceSearchParameter.TAXON_KEY));
      for (String paramValue : paramValues) {
        if (nameUsagesSuggestions.getNameUsagesReplacements().containsKey(paramValue)) {
          searchRequest.getParameters().remove(OccurrenceSearchParameter.TAXON_KEY, paramValue);
          searchRequest.addParameter(OccurrenceSearchParameter.TAXON_KEY, nameUsagesSuggestions
            .getNameUsagesReplacements().get(paramValue).getKey());
        }
      }
    }
  }

  /**
   * Checks if the search parameter contains correct values.
   */
  public boolean validateSearchParameters(BaseAction action, HttpServletRequest request) {
    boolean valid = true;
    for (Enumeration<String> params = request.getParameterNames(); params.hasMoreElements();) {
      String param = params.nextElement();
      Enum<?> occParam = null;
      try {
        occParam = VocabularyUtils.lookupEnum(param, OccurrenceSearchParameter.class);
        if (occParam != null) {
          for (String value : request.getParameterValues(param)) {
            try {
              if (OccurrenceSearchParameter.TAXON_KEY != occParam) {
                // TAXON_KEY is not validated since it could be an integer or a string (scientific name)
                SearchTypeValidator.validate((OccurrenceSearchParameter) occParam, value);
              }
            } catch (IllegalArgumentException ex) {
              action.addFieldError(param, "Wrong parameter value " + value);
              valid = false;
            }
          }
        }
      } catch (IllegalArgumentException e) {
        // ignore paging params for example
      }
    }
    return valid;
  }

  /**
   * Returns the displayable label/value of bounding box filter.
   */
  private String getBoundingBoxTitle(String bboxValue) {
    String[] coordinates = bboxValue.split(",");
    String label = "FROM " + coordinates[0] + " TO " + coordinates[1];
    return label;
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
   * Converts a NameUsageMatch into a NameUsageSearchResult.
   */
  private NameUsageSearchResult toNameUsageResult(NameUsageMatch nameUsageMatch) {
    NameUsageSearchResult nameUsageSearchResult = null;

    try {
      nameUsageSearchResult = new NameUsageSearchResult();
      PropertyUtils.copyProperties(nameUsageSearchResult, nameUsageMatch);
      nameUsageSearchResult.setKey(nameUsageMatch.getUsageKey());
    } catch (IllegalAccessException e) {
      LOG.error("Error converting NameUsageMatch to NameUsageSearchResult", e);
    } catch (InvocationTargetException e) {
      LOG.error("Error converting NameUsageMatch to NameUsageSearchResult", e);
    } catch (NoSuchMethodException e) {
      LOG.error("Error converting NameUsageMatch to NameUsageSearchResult", e);
    }

    return nameUsageSearchResult;
  }

}
