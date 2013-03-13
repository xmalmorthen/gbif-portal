package org.gbif.portal.action.occurrence;

import org.gbif.api.model.metrics.cube.OccurrenceCube;
import org.gbif.api.model.metrics.cube.ReadBuilder;
import org.gbif.api.service.metrics.CubeService;
import org.gbif.portal.action.BaseAction;

import com.google.inject.Inject;


/**
 * Occurrence search home action.
 */
public class HomeAction extends BaseAction {

  private static final long serialVersionUID = 374193477998601641L;

  protected CubeService occurrenceCubeService;

  private Integer numGeoreferenced;

  private Integer numOccurrences;

  @Inject
  public HomeAction(CubeService occurrenceCubeService) {
    this.occurrenceCubeService = occurrenceCubeService;
  }

  @Override
  public String execute() {
    numGeoreferenced = (int) occurrenceCubeService.get(new ReadBuilder().at(OccurrenceCube.IS_GEOREFERENCED, true));
    numOccurrences = (int) occurrenceCubeService.get(new ReadBuilder());
    return SUCCESS;
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

}
