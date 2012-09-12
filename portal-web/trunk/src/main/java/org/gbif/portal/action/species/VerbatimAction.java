package org.gbif.portal.action.species;

import org.gbif.api.exception.NotFoundException;
import org.gbif.api.model.checklistbank.VerbatimNameUsage;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class VerbatimAction extends UsageBaseAction {
  private static final Logger LOG = LoggerFactory.getLogger(VerbatimAction.class);

  private VerbatimNameUsage verbatim;

  @Override
  public String execute() {

    loadUsage();

    try {
      verbatim = usageService.getVerbatim(id);
    } catch (Exception e) {
      LOG.error("Cant load verbatim data", e);
      throw new NotFoundException();
    }

    return SUCCESS;
  }

  public VerbatimNameUsage getVerbatim() {
    return verbatim;
  }
}
