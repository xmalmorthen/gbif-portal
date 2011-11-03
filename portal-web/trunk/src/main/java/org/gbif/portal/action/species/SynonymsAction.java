package org.gbif.portal.action.species;

import org.gbif.api.paging.PagingRequest;
import org.gbif.checklistbank.api.model.NameUsage;

import java.util.List;

public class SynonymsAction extends UsageAction {
  private List<NameUsage> synonyms;
  private PagingRequest page = new PagingRequest(0, 100);

  @Override
  public String execute() {
    if (!loadUsage()){
      return HTTP_NOT_FOUND;
    }
    synonyms = usageService.listSynonyms(id, getLocale(), page).getResults();
    return SUCCESS;
  }

  public List<NameUsage> getSynonyms() {
    return synonyms;
  }
}
