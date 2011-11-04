package org.gbif.portal.action.species;

import org.gbif.checklistbank.api.model.TypeSpecimen;
import org.gbif.checklistbank.api.service.TypeSpecimenService;

import com.google.inject.Inject;


public class TypeSpecimenAction extends SeeMoreAction<TypeSpecimen> {

  @Inject
  public TypeSpecimenAction(TypeSpecimenService service) {
    super(service);
  }
}