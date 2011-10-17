package org.gbif.portal.action.species;

import org.gbif.api.paging.Pageable;
import org.gbif.api.paging.PagingRequest;
import org.gbif.checklistbank.api.model.Checklist;
import org.gbif.checklistbank.api.model.ChecklistUsage;
import org.gbif.checklistbank.api.service.ChecklistService;
import org.gbif.checklistbank.api.service.ChecklistUsageService;
import org.gbif.checklistbank.api.service.VernacularNameService;
import org.gbif.portal.action.BaseAction;

import com.google.inject.Inject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class NameUsageAction extends BaseAction {

  private static final Logger LOG = LoggerFactory.getLogger(NameUsageAction.class);

  @Inject
  private ChecklistUsageService usageService;
  @Inject
  private ChecklistService checklistService;
  //TODO: remove comments once ws client exist and is wired up
  //@Inject
  private VernacularNameService vernacularNameService;

  private Integer id;
  private Checklist checklist;
  private ChecklistUsage usage;
  private ChecklistUsage basionym;

  @Override
  public String execute() {
    if (id == null){
      LOG.error("No checklist usage id given");
      return ERROR;
    }
    usage = usageService.get(id, getLocale());
    if (usage == null){
      return HTTP_NOT_FOUND;
    }
    // checklist
    checklist = checklistService.get(usage.getChecklistKey());
    // basionym
    if (usage.getBasionymKey() != null){
      basionym = usageService.get(usage.getBasionymKey(), getLocale());
    }
    // load subresources with small page size = 10
    Pageable page10 = new PagingRequest(0,10);
    usage.setSynonyms(usageService.listSynonyms(id, getLocale(), page10));
    //usage.setVernacularNames(vernacularNameService.listByChecklistUsage(id, page10));
    return SUCCESS;
  }

  public void setId(Integer id) {
    this.id = id;
  }

  public Integer getId() {
    return id;
  }

  public Checklist getChecklist() {
    return checklist;
  }

  public ChecklistUsage getUsage() {
    return usage;
  }

  public ChecklistUsage getBasionym() {
    return basionym;
  }
}
