package org.gbif.portal.action.species;

import org.gbif.api.paging.PagingRequest;
import org.gbif.api.paging.PagingResponse;
import org.gbif.checklistbank.api.model.NameUsageComponent;
import org.gbif.checklistbank.api.service.NameUsageComponentService;

import java.util.HashSet;
import java.util.Set;
import java.util.UUID;

public class SeeMoreAction<T extends NameUsageComponent> extends UsageAction {

  private PagingResponse<T> page;
  private long offset = 0;
  private final NameUsageComponentService<T> service;

  public SeeMoreAction(NameUsageComponentService<T> service) {
    this.service = service;
  }

  @Override
  public String execute() {
    loadUsage();

    PagingRequest p = new PagingRequest(offset, 25);
    page = service.listByUsage(id, p);

    // load checklist lookup map if its a nub usage
    if (usage.isNub()) {
      Set<UUID> cids = new HashSet<UUID>();
      for (T comp : page.getResults()) {
        cids.add(comp.getDatasetKey());
      }
      loadChecklists(cids);
    }

    return SUCCESS;
  }

  public void setOffset(long offset) {
    this.offset = offset;
  }

  public PagingResponse<T> getPage() {
    return page;
  }
}
