package org.gbif.portal.action.dataset;

import org.gbif.api.exception.NotFoundException;
import org.gbif.api.model.checklistbank.DatasetMetrics;
import org.gbif.api.model.registry.Dataset;
import org.gbif.api.model.registry.Network;
import org.gbif.api.model.registry.Organization;
import org.gbif.api.model.registry.taxonomic.TaxonomicCoverage;
import org.gbif.api.model.registry.taxonomic.TaxonomicCoverages;
import org.gbif.api.service.checklistbank.DatasetMetricsService;
import org.gbif.api.service.registry.DatasetService;
import org.gbif.api.service.registry.NetworkService;
import org.gbif.api.service.registry.OrganizationService;
import org.gbif.api.vocabulary.Rank;
import org.gbif.portal.action.BaseAction;
import org.gbif.portal.action.dataset.util.DisplayableTaxonomicCoverage;
import org.gbif.portal.action.dataset.util.OrganizedTaxonomicCoverage;
import org.gbif.portal.action.dataset.util.OrganizedTaxonomicCoverages;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.UUID;

import com.google.common.base.Strings;
import com.google.inject.Inject;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class DatasetBaseAction extends BaseAction {

  private static final Logger LOG = LoggerFactory.getLogger(DatasetBaseAction.class);

  protected String id;
  protected UUID key;
  protected Dataset dataset;
  protected DatasetMetrics metrics;
  @Inject
  protected DatasetService datasetService;
  @Inject
  protected DatasetMetricsService metricsService;
  // detail
  protected Organization owningOrganization;
  // detail
  protected Network networkOfOrigin;
  @Inject
  protected OrganizationService organizationService;
  @Inject
  protected NetworkService networkService;
  // for conveniently displaying the dataset's TaxonomicCoverages in freemarker template
  private List<OrganizedTaxonomicCoverages> organizedCoverages;

  public Dataset getDataset() {
    return dataset;
  }

  public DatasetService getDatasetService() {
    return datasetService;
  }

  public String getId() {
    return id;
  }

  public UUID getKey() {
    return key;
  }

  public Dataset getMember() {
    return dataset;
  }

  public DatasetMetrics getMetrics() {
    return metrics;
  }

  /**
   * @return the dataset's owningOrganization
   */
  public Organization getOwningOrganization() {
    return owningOrganization;
  }

  /**
   * @return the Dataset's Network of origin.
   */
  public Network getNetworkOfOrigin() {
    return networkOfOrigin;
  }

  /**
   * @return the Dataset's taxonomic coverages organized by rank
   */
  public List<OrganizedTaxonomicCoverages> getOrganizedCoverages() {
    return organizedCoverages;
  }

  protected void loadDetail() {
    LOG.debug("Fetching detail for dataset id [{}]", id);
    if (Strings.isNullOrEmpty(id)) {
      throw new NotFoundException();
    }

    dataset = datasetService.get(id);
    if (dataset == null) {
      LOG.error("No dataset found with id {}", id);
      throw new NotFoundException();
    }

    // gets the owning organization
    if (dataset.getOwningOrganizationKey() != null) {
      owningOrganization = organizationService.get(dataset.getOwningOrganizationKey());
    }

    // get the network of origin
    if (dataset.getNetworkOfOriginKey() != null) {
      networkOfOrigin = networkService.get(dataset.getNetworkOfOriginKey());
    }

    // get metrics
    try {
      key = UUID.fromString(id);
      metrics = metricsService.get(key);
    } catch (NotFoundException e) {
      LOG.warn("Cant get metrics for dataset {}", key, e);
    } catch (IllegalArgumentException e) {
      // ignore external datasets without a uuid
    } catch (Exception e) {
      LOG.warn("Cant get metrics for dataset {}", key, e);
    }

    // construct organized list of TaxonomicCoverages for simple display in UI
    if (dataset.getTaxonomicCoverages() != null) {
      organizedCoverages = constructOrganizedTaxonomicCoverages(dataset.getTaxonomicCoverages());
    }
  }

  public void setId(String id) {
    this.id = id;
  }

  /**
   * Takes a list of the resource's TaxonomicCoverages, and for each one, creates a new OrganizedTaxonomicCoverage
   * that gets added to this class' list of OrganizedTaxonomicCoverage.
   *
   * @param coverages list of resource's OrganizedTaxonomicCoverage
   */
  List<OrganizedTaxonomicCoverages> constructOrganizedTaxonomicCoverages(List<TaxonomicCoverages> coverages) {
    List<OrganizedTaxonomicCoverages> organizedCoverages = new ArrayList<OrganizedTaxonomicCoverages>();
    for (TaxonomicCoverages coverage : coverages) {
      OrganizedTaxonomicCoverages organizedCoverage = new OrganizedTaxonomicCoverages();
      organizedCoverage.setDescription(coverage.getDescription());
      organizedCoverage.setCoverages(setOrganizedTaxonomicCoverages(coverage.getCoverages()));
      organizedCoverages.add(organizedCoverage);
    }
    return organizedCoverages;
  }

  /**
   * This method iterates through a list of TaxonomicCoverage, and groups them all by rank. For each unique rank
   * represented in the list, there will be 1 OrganizedTaxonomicCoverage, that has a list of
   * DisplayableTaxonomicCoverage. A DisplayableTaxonomicCoverage is basically the same as TaxonomicCoverage, only that
   * it has a field called display name. The display name is the way the TaxonomicCoverage should be showin in the UI.
   *
   * @param coverages list of TaxonomicCoverages' TaxonomicCoverage
   *
   * @return list of OrganizedTaxonomicCoverage (one for each unique rank represented in the list of
   *         TaxonomicCoverage), or an empty list if none were added
   */
  private List<OrganizedTaxonomicCoverage> setOrganizedTaxonomicCoverages(List<TaxonomicCoverage> coverages) {
    List<OrganizedTaxonomicCoverage> organizedTaxonomicCoveragesList = new ArrayList<OrganizedTaxonomicCoverage>();

    // create Rank name list, made from Rank vocab names + uninterpreted rank names discovered from coverages list
    List<String> rankNames = createRankNameList(coverages);

    for (String rankName : rankNames) {
      // initiate a new OrganizedTaxonomicCoverage for each rank
      OrganizedTaxonomicCoverage organizedCoverage = new OrganizedTaxonomicCoverage();
      organizedCoverage.setRank(rankName);
      // iterate through all coverages, and match all with same rank
      for (TaxonomicCoverage coverage : coverages) {
        // proceed if rank is not null
        if (coverage.getRank() != null) {
          // create display name
          String displayName = createDisplayNameForCoverage(coverage);
          // proceed if display name created (meaning coverage has at least a scientific name)
          if (!Strings.isNullOrEmpty(displayName)) {
            // if the interpreted rank or the verbatim rank matches..
            Rank interpreted = coverage.getRank().getInterpreted();
            String verbatim = coverage.getRank().getVerbatim();
            if ((interpreted != null && rankName.equalsIgnoreCase(interpreted.name())) || (verbatim != null && rankName
              .equalsIgnoreCase(verbatim))) {
              // add DisplayableTaxonomicCoverage into OrganizedTaxonomicCoverage
              DisplayableTaxonomicCoverage displayable = new DisplayableTaxonomicCoverage(coverage);
              displayable.setDisplayName(displayName);
              organizedCoverage.getDisplayableNames().add(displayable);
            }
          }
        }
      }
      // add to list if OrganizedTaxonomicCoverage contained at least one DisplayableTaxonomicCoverage
      if (organizedCoverage.getDisplayableNames().size() > 0) {
        organizedTaxonomicCoveragesList.add(organizedCoverage);
      }
    }
    // return list
    return organizedTaxonomicCoveragesList;
  }

  /**
   * Create the complete list of Rank names from the complete list of Rank names coming from the Rank vocabulary, plus
   * the list of uninterpreted Rank names used in the incoming list of TaxonomicCoverage. Each name must be in upper
   * case.
   *
   * @param coverages TaxonomicCoverage list
   * @return complete list of Rank names taking into consideration any uninterpreted Rank names from incoming list
   */
  private List<String> createRankNameList(List<TaxonomicCoverage> coverages) {
    // collect all uninterpreted rank names
    Set<String> uninterpreted = new HashSet<String>();
    for (TaxonomicCoverage cov : coverages) {
      if (cov.getRank() != null) {
        Rank interpreted = cov.getRank().getInterpreted();
        String verbatim = cov.getRank().getVerbatim();
        if (interpreted == null && verbatim != null) {
          if (!uninterpreted.contains(verbatim)) {
            // add uninterpreted name, in upper case
            uninterpreted.add(verbatim.toUpperCase());
          }
        }
      }
    }

    // collect all Rank names from vocabulary
    List<String> rankNames = new ArrayList<String>();
    for (Rank rank: Rank.values()) {
      // add name, in upper case
      rankNames.add(rank.name().toUpperCase());
    }

    // add all uninterpreted rank names
    if (!uninterpreted.isEmpty()) {
      rankNames.addAll(uninterpreted);
    }

    // return complete list
    return rankNames;
  }

  /**
   * Construct the display name from TaxonomicCoverage's scientific name and common name properties. It will look like:
   * scientific name (common name) provided both properties are not null. Otherwise, it will be either the scientific
   * name or common name by themselves.
   *
   * @return constructed display name or an empty string if none could be constructed
   */
  private String createDisplayNameForCoverage(TaxonomicCoverage coverage) {
    String combined = null;
    if (coverage != null) {
      String scientificName = StringUtils.trimToNull(coverage.getScientificName());
      String commonName = StringUtils.trimToNull(coverage.getCommonName());
      if (scientificName != null && commonName != null) {
        combined = scientificName + " (" + commonName + ")";
      } else if (scientificName != null) {
        combined = scientificName;
      } else if (commonName != null) {
        combined = commonName;
      }
    }
    return combined;
  }
}
