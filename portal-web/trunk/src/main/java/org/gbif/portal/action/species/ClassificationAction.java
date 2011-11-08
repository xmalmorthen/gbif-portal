package org.gbif.portal.action.species;

import org.gbif.checklistbank.api.model.NameUsage;

import java.util.List;

public class ClassificationAction extends UsageAction {

  private List<NameUsage> parents;

  @Override
  public String execute() {
    if (!loadUsage()) {
      return HTTP_NOT_FOUND;
    }
    parents = usageService.listParents(id, getLocale());
    return SUCCESS;
  }

  public List<NameUsage> getParents() {
    return parents;
  }
}
