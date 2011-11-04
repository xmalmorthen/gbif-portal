package org.gbif.portal.action.species;

import org.gbif.checklistbank.api.model.Checklist;
import org.gbif.checklistbank.api.model.NameUsage;
import org.gbif.checklistbank.api.service.ChecklistService;
import org.gbif.checklistbank.api.service.NameUsageService;
import org.gbif.portal.action.BaseAction;

import java.util.Collection;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

import com.google.inject.Inject;

public class UsageAction extends BaseAction{
  @Inject
  protected NameUsageService usageService;
  @Inject
  protected ChecklistService checklistService;

  protected Integer id;
  protected NameUsage usage;
  protected Checklist checklist;
  protected Map<UUID, Checklist> checklists = new HashMap<UUID, Checklist>();

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

  /**
   * Populates the checklists map with the checklists for the given keys.
   * The method does not remove existing entries and can be called many times to add additional, new checklists.
   * @param checklistKeys
   */
  protected void loadChecklists(Collection<UUID> checklistKeys) {
    for (UUID u : checklistKeys) {
      loadChecklist(u);
    }
  }

  protected void loadChecklist(UUID checklistKey) {
    if (!checklists.containsKey(checklistKey)){
      checklists.put(checklistKey, checklistService.get(checklistKey));
    }
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

  public Map<UUID, Checklist> getChecklists() {
    return checklists;
  }
}
