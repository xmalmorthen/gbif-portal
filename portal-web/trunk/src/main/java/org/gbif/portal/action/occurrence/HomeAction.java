package org.gbif.portal.action.occurrence;

import org.gbif.api.model.metrics.cube.OccurrenceCube;
import org.gbif.api.model.metrics.cube.ReadBuilder;
import org.gbif.api.service.metrics.CubeService;
import org.gbif.api.service.occurrence.OccurrenceDistributionIndexService;
import org.gbif.api.vocabulary.BasisOfRecord;
import org.gbif.api.vocabulary.Kingdom;
import org.gbif.portal.action.BaseAction;

import java.util.Calendar;
import java.util.Map;

import com.google.common.base.Enums;
import com.google.common.base.Optional;
import com.google.inject.Inject;


/**
 * Occurrence search home action.
 */
public class HomeAction extends BaseAction {

  private static final long serialVersionUID = 374193477998601641L;

  private static final int MIN_YEAR = 1950;

  private static final int maxYear = Calendar.getInstance().get(Calendar.YEAR); // this year

  protected CubeService occurrenceCubeService;

  private final OccurrenceDistributionIndexService occurrenceDistributionIndexService;

  private Integer numGeoreferenced;

  private Integer numOccurrences;

  @Inject
  public HomeAction(CubeService occurrenceCubeService,
    OccurrenceDistributionIndexService occurrenceDistributionIndexService) {
    this.occurrenceCubeService = occurrenceCubeService;
    this.occurrenceDistributionIndexService = occurrenceDistributionIndexService;
  }

  @Override
  public String execute() {
    numGeoreferenced = (int) occurrenceCubeService.get(new ReadBuilder().at(OccurrenceCube.IS_GEOREFERENCED, true));
    numOccurrences = (int) occurrenceCubeService.get(new ReadBuilder());
    return SUCCESS;
  }

  public Map<BasisOfRecord, Long> getBasisOfRecordCounts() {
    return occurrenceDistributionIndexService.getBasisOfRecordCounts();
  }

  public Map<Kingdom, Long> getKingdomCounts() {
    return occurrenceDistributionIndexService.getKingdomCounts();
  }


  public String getKingdomNubUsageId(String kingdom) {
    Optional<Kingdom> opKingdom = Enums.getIfPresent(Kingdom.class, kingdom);
    if (opKingdom.isPresent()) {
      return opKingdom.get().nubUsageID().toString();
    }
    return kingdom;
  }

  public Integer getMaxYear() {
    return maxYear;
  }


  public Integer getMinYear() {
    return MIN_YEAR;
  }

  /**
   * @return the numGeoreferenced
   */
  public Integer getNumGeoreferenced() {
    return numGeoreferenced;
  }

  /**
   * @return the numOccurrences
   */
  public Integer getNumOccurrences() {
    return numOccurrences;
  }

  public Map<Integer, Long> getYearCounts() {
    return occurrenceDistributionIndexService.getYearCounts(MIN_YEAR, maxYear);
  }
}
