package org.gbif.portal.action.species;

import org.gbif.api.paging.PagingRequest;
import org.gbif.api.paging.PagingResponse;
import org.gbif.checklistbank.api.model.NameUsage;

public class SynonymsAction extends UsageBaseAction {

  private PagingResponse<NameUsage> page;
  private long offset = 0;

  @Override
  public String execute() {
    loadUsage();

    PagingRequest p = new PagingRequest(offset, 25);
    page = usageService.listSynonyms(id, getLocale(), p);

    return SUCCESS;
  }

  public void setOffset(int offset) {
    this.offset = offset;
  }

  public PagingResponse<NameUsage> getPage() {
    return page;
  }
}
