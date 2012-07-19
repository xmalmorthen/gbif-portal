package org.gbif.portal.action.species;

import org.gbif.checklistbank.api.model.VernacularName;
import org.gbif.checklistbank.api.service.VernacularNameService;

import com.google.inject.Inject;

public class VernacularNameAction extends SeeMoreAction<VernacularName> {

  @Inject
  public VernacularNameAction(VernacularNameService service) {
    super(service);
  }
}