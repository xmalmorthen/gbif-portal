package org.gbif.portal.action.dataset;

import org.gbif.api.model.common.InterpretedEnum;
import org.gbif.api.model.registry.taxonomic.TaxonomicCoverage;
import org.gbif.api.model.registry.taxonomic.TaxonomicCoverages;
import org.gbif.api.vocabulary.Rank;
import org.gbif.portal.action.dataset.util.DisplayableTaxonomicCoverage;
import org.gbif.portal.action.dataset.util.OrganizedTaxonomicCoverage;
import org.gbif.portal.action.dataset.util.OrganizedTaxonomicCoverages;

import java.util.ArrayList;
import java.util.List;

import org.junit.Test;

import static junit.framework.Assert.assertEquals;

public class DatasetBaseActionTest {

  @Test
  public void testPopulateOrganizedCoverages() {
    DatasetBaseAction action = new DatasetBaseAction();

    // create coverages #1
    TaxonomicCoverages coverages1 = new TaxonomicCoverages();
    List<TaxonomicCoverages> coveragesList = new ArrayList<TaxonomicCoverages>();

    TaxonomicCoverage coverage1 = new TaxonomicCoverage();
    coverage1.setCommonName("Plants");
    coverage1.setScientificName("Plantae");
    coverage1.setRank(new InterpretedEnum("kingdom", Rank.KINGDOM));


    TaxonomicCoverage coverage2 = new TaxonomicCoverage();
    coverage2.setCommonName("Animals");
    coverage2.setScientificName("Animalia");
    coverage2.setRank(new InterpretedEnum("kingdom", Rank.KINGDOM));

    List<TaxonomicCoverage> coverageList = new ArrayList<TaxonomicCoverage>();
    coverageList.add(coverage1);
    coverageList.add(coverage2);

    coverages1.setCoverages(coverageList);
    coverages1.setDescription("Coverages #1 description");

    coveragesList.add(coverages1);

    // create coverages #2
    TaxonomicCoverages coverages2 = new TaxonomicCoverages();

    TaxonomicCoverage coverage_2_1 = new TaxonomicCoverage();
    coverage_2_1.setScientificName("Equisetophyta");
    coverage_2_1.setRank(new InterpretedEnum("phylum", Rank.PHYLUM));

    TaxonomicCoverage coverage_2_2 = new TaxonomicCoverage();
    coverage_2_2.setScientificName("Pteridophyta");
    coverage_2_2.setRank(new InterpretedEnum("phylum", Rank.PHYLUM));

    List<TaxonomicCoverage> coverageList2 = new ArrayList<TaxonomicCoverage>();
    coverageList2.add(coverage_2_1);
    coverageList2.add(coverage_2_2);

    coverages2.setCoverages(coverageList2);
    coverages2.setDescription("Coverages #2 description");

    // add 2 coverages to list
    coveragesList.add(coverages2);
    coveragesList.add(coverages1);

    // return organized coverages
    List<OrganizedTaxonomicCoverages> organizedCoverages = action.constructOrganizedTaxonomicCoverages(coveragesList);

    // assert some things about 1st coverages
    assertEquals("Coverages #1 description", organizedCoverages.get(0).getDescription());

    OrganizedTaxonomicCoverage organizedCoverage = organizedCoverages.get(0).getCoverages().get(0);
    assertEquals(2, organizedCoverage.getDisplayableNames().size());

    DisplayableTaxonomicCoverage displayableCoverage1 = organizedCoverage.getDisplayableNames().get(0);
    assertEquals("Plantae (Plants)", displayableCoverage1.getDisplayName());
    assertEquals("Plantae", displayableCoverage1.getScientificName());
    assertEquals("Plants", displayableCoverage1.getCommonName());

    DisplayableTaxonomicCoverage displayableCoverage2 = organizedCoverage.getDisplayableNames().get(1);
    assertEquals("Animalia (Animals)", displayableCoverage2.getDisplayName());
    assertEquals("Animalia", displayableCoverage2.getScientificName());
    assertEquals("Animals", displayableCoverage2.getCommonName());

    // assert some things about 2nd coverages
    assertEquals("Coverages #2 description", organizedCoverages.get(1).getDescription());

    OrganizedTaxonomicCoverage organizedCoverage2 = organizedCoverages.get(1).getCoverages().get(0);
    assertEquals(2, organizedCoverage2.getDisplayableNames().size());
  }

}
