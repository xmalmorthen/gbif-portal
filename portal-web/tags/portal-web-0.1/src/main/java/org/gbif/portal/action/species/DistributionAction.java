package org.gbif.portal.action.species;

import org.gbif.checklistbank.api.model.Distribution;
import org.gbif.checklistbank.api.service.DistributionService;

import com.google.inject.Inject;

public class DistributionAction extends SeeMoreAction<Distribution> {

  @Inject
  public DistributionAction(DistributionService service) {
    super(service);
  }
}
