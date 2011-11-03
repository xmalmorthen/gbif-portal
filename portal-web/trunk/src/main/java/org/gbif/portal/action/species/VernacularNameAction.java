package org.gbif.portal.action.species;

import org.gbif.api.paging.PagingRequest;
import org.gbif.checklistbank.api.model.VernacularName;
import org.gbif.checklistbank.api.service.VernacularNameService;

import java.util.List;

import com.google.inject.Inject;

public class VernacularNameAction extends UsageAction {
  private List<VernacularName> vernaculars;
  private PagingRequest page = new PagingRequest(0, 100);
  @Inject
  private VernacularNameService vernacularNameService;

  @Override
  public String execute() {
    if (!loadUsage()){
      return HTTP_NOT_FOUND;
    }

    vernaculars = vernacularNameService.listByUsage(id, page).getResults();
    return SUCCESS;
  }

  public List<VernacularName> getVernaculars() {
    return vernaculars;
  }
}
