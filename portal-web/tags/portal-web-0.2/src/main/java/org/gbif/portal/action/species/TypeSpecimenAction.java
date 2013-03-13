package org.gbif.portal.action.species;

import org.gbif.api.model.checklistbank.TypeSpecimen;
import org.gbif.api.service.checklistbank.TypeSpecimenService;

import com.google.inject.Inject;


public class TypeSpecimenAction extends SeeMoreAction<TypeSpecimen> {

  @Inject
  public TypeSpecimenAction(TypeSpecimenService service) {
    super(service);
  }
}