package org.gbif.portal.action.species;

import org.gbif.checklistbank.api.model.Checklist;
import org.gbif.checklistbank.api.model.NameUsage;
import org.gbif.checklistbank.api.service.ChecklistService;
import org.gbif.checklistbank.api.service.NameUsageService;
import org.gbif.portal.action.BaseAction;

import com.google.inject.Inject;

public class UsageAction extends BaseAction{
  @Inject
  protected NameUsageService usageService;
  @Inject
  protected ChecklistService checklistService;

  protected Integer id;
  protected NameUsage usage;
  protected Checklist checklist;

  public boolean loadUsage() {
    if (id == null) {
      LOG.error("No checklist usage id given");
      return false;
    }
    usage = usageService.get(id, getLocale());
    if (usage == null) {
      LOG.error("No usage found with id {}", id);
      return false;
    }
    // load checklist
    checklist = checklistService.get(usage.getChecklistKey());
    return true;
  }

  public void setId(Integer id) {
    this.id = id;
  }

  public Integer getId() {
    return id;
  }

  public NameUsage getUsage() {
    return usage;
  }

  public Checklist getChecklist() {
    return checklist;
  }
}
