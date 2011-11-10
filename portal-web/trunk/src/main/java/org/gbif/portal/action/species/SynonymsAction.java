package org.gbif.portal.action.species;

import org.gbif.api.paging.PagingRequest;
import org.gbif.checklistbank.api.model.NameUsage;

import java.util.List;

public class SynonymsAction extends UsageAction {
  private List<NameUsage> synonyms;
  private PagingRequest page;
  private long offset = 0;

  @Override
  public String execute() {
    loadUsage();

    page = new PagingRequest(offset, 50);
    synonyms = usageService.listSynonyms(id, getLocale(), page).getResults();
    return SUCCESS;
  }

  public List<NameUsage> getSynonyms() {
    return synonyms;
  }

  public void setOffset(int offset) {
    this.offset = offset;
  }

  public PagingRequest getPage() {
    return page;
  }
}
