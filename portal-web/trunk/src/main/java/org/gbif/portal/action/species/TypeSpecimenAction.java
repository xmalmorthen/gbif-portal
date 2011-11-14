package org.gbif.portal.action.species;

import org.gbif.api.paging.PagingRequest;
import org.gbif.api.paging.PagingResponse;
import org.gbif.checklistbank.api.model.TypeSpecimen;
import org.gbif.checklistbank.api.service.TypeSpecimenService;

import java.util.HashSet;
import java.util.Set;
import java.util.UUID;

import com.google.inject.Inject;


public class TypeSpecimenAction extends SeeMoreAction<TypeSpecimen> {
  private PagingResponse<TypeSpecimen> page;
  private long offset = 0;
  private TypeSpecimenService service;

  @Inject
  public TypeSpecimenAction(TypeSpecimenService service) {
     super(service);
    this.service = service;
  }

  @Override
  public String execute() {
    loadUsage();

    // get typeStatus parameter value
    String typeStatus = request.getParameter("type");
    // add parameter(s) to their corresponding field on TypeSpecimen object, later used to filter search
    // additional parameters used as filters can be added in this way, but be sure special parameters like typeStatus,
    // that are derived from fk joins on other tables are handled properly in the BaseExample MyBatis util class.
    TypeSpecimen typeSpecimen = new TypeSpecimen();
    typeSpecimen.setUsageKey(id);
    typeSpecimen.setTypeStatus(typeStatus);

    PagingRequest p = new PagingRequest(offset, 25);
    page = service.selectByExample(id, typeSpecimen, p);

    // load checklist lookup map if its a nub usage
    if (usage.isNub()){
      Set<UUID> cids = new HashSet<UUID>();
      for (TypeSpecimen comp: page.getResults()) {
        cids.add(comp.getChecklistKey());
      }
      loadChecklists(cids);
    }

    return SUCCESS;
  }

  public void setOffset(long offset) {
    this.offset = offset;
  }

  public PagingResponse<TypeSpecimen> getPage() {
    return page;
  }
}