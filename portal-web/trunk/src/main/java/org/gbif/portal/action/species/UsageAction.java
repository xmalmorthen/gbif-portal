package org.gbif.portal.action.species;

import org.gbif.checklistbank.api.model.NameUsage;
import org.gbif.checklistbank.api.service.NameUsageService;
import org.gbif.portal.action.BaseAction;

import com.google.inject.Inject;

public class UsageAction extends BaseAction{
  protected Integer id;
  protected NameUsage usage;
  @Inject
  protected NameUsageService usageService;

  public boolean loadUsage() {
    usage = usageService.get(id, getLocale());
    return usage != null;
  }

  public void setId(Integer id) {
    this.id = id;
  }

  public Integer getId() {
    return id;
  }
}
