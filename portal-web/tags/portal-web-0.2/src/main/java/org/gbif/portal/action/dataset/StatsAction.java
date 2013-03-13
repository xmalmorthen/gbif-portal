package org.gbif.portal.action.dataset;

import org.gbif.api.model.Constants;
import org.gbif.api.vocabulary.DatasetType;
import org.gbif.portal.exception.NotFoundException;
import org.gbif.portal.action.species.HomeAction;

import java.util.UUID;

/**
 * Extends the details action to return a different result name based on the dataset type, so we can use
 * different freemarker templates for them as they are very different.
 *
 * For external datasets the page is not found.
 */
public class StatsAction extends DetailAction {
  private static final String OCCURRENCE_RESULT = "occurrence";
  private static final String CHECKLIST_RESULT = "checklist";

  @Override
  public String execute() {
    super.execute();

    if (DatasetType.OCCURRENCE == dataset.getType()) {
      return OCCURRENCE_RESULT;
    } else if (DatasetType.CHECKLIST == dataset.getType()) {
      return CHECKLIST_RESULT;
    } else {
      throw new NotFoundException("External datasets don't have a stats page");
    }
  }

  public UUID getColKey() {
    return HomeAction.COL_KEY;
  }

  public UUID getNubKey() {
    return Constants.NUB_TAXONOMY_KEY;
  }
}
