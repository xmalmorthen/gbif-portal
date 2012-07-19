package org.gbif.portal.action.species;

import org.gbif.checklistbank.api.model.Reference;
import org.gbif.checklistbank.api.service.ReferenceService;

import com.google.inject.Inject;

public class ReferenceAction extends SeeMoreAction<Reference> {

  @Inject
  public ReferenceAction(ReferenceService service) {
    super(service);
  }
}

