package org.gbif.portal.action.species;

import org.gbif.api.exception.NotFoundException;
import org.gbif.checklistbank.api.model.NameUsage;
import org.gbif.checklistbank.api.model.NameUsageContainer;
import org.gbif.checklistbank.api.service.NameUsageService;
import org.gbif.portal.action.BaseAction;
import org.gbif.registry.api.model.Dataset;
import org.gbif.registry.api.service.DatasetService;

import java.util.Collection;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

import com.google.inject.Inject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class UsageAction extends BaseAction {

  private static final Logger LOG = LoggerFactory.getLogger(UsageAction.class);

  @Inject
  protected NameUsageService usageService;
  @Inject
  protected DatasetService checklistService;

  protected Integer id;
  protected NameUsageContainer usage;
  protected Dataset checklist;
  protected Map<UUID, Dataset> checklists = new HashMap<UUID, Dataset>();

  /**
   * Loads a name usage and its checklist by the id parameter.
   *
   * @throws NotFoundException if no usage for the given id can be found
   */
  public void loadUsage() {
    if (id == null) {
      LOG.error("No checklist usage id given");
      throw new NotFoundException();
    }
    NameUsage u = usageService.get(id, getLocale());
    if (u == null) {
      LOG.error("No usage found with id {}", id);
      throw new NotFoundException();
    }
    usage = new NameUsageContainer(u);
    // load checklist
    checklist = checklistService.get(usage.getChecklistKey());
  }

  /**
   * Populates the checklists map with the checklists for the given keys.
   * The method does not remove existing entries and can be called many times to add additional, new checklists.
   */
  protected void loadChecklists(Collection<UUID> checklistKeys) {
    for (UUID u : checklistKeys) {
      loadChecklist(u);
    }
  }

  protected void loadChecklist(UUID checklistKey) {
    if (!checklists.containsKey(checklistKey)) {
      checklists.put(checklistKey, checklistService.get(checklistKey));
    }
  }

  public void setId(Integer id) {
    this.id = id;
  }

  public Integer getId() {
    return id;
  }

  public NameUsageContainer getUsage() {
    return usage;
  }

  public Dataset getChecklist() {
    return checklist;
  }

  public Map<UUID, Dataset> getChecklists() {
    return checklists;
  }

  public String getChecklistName(UUID key) {
    if (key != null && checklists.containsKey(key)) {
      return checklists.get(key).getTitle();
    }
    return "";
  }
}
