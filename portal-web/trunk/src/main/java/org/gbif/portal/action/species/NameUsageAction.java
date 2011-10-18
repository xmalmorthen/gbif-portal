package org.gbif.portal.action.species;

import org.gbif.api.paging.Pageable;
import org.gbif.api.paging.PagingRequest;
import org.gbif.api.paging.PagingResponse;
import org.gbif.checklistbank.api.model.Checklist;
import org.gbif.checklistbank.api.model.ChecklistUsage;
import org.gbif.checklistbank.api.model.Reference;
import org.gbif.checklistbank.api.model.VernacularName;
import org.gbif.checklistbank.api.service.ChecklistService;
import org.gbif.checklistbank.api.service.ChecklistUsageService;
import org.gbif.checklistbank.api.service.ReferenceService;
import org.gbif.checklistbank.api.service.VernacularNameService;
import org.gbif.portal.action.BaseAction;

import java.util.List;

import com.google.inject.Inject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class NameUsageAction extends BaseAction {

  private static final Logger LOG = LoggerFactory.getLogger(NameUsageAction.class);

  @Inject
  private ChecklistUsageService usageService;
  @Inject
  private ChecklistService checklistService;
  @Inject
  private VernacularNameService vernacularNameService;
  @Inject
  private ReferenceService referenceService;

  private Integer id;
  private Checklist checklist;
  private ChecklistUsage usage;
  private ChecklistUsage basionym;
  // TODO: remove the children property once the taxonomic browser is working via ajax
  private List<ChecklistUsage> children;

  @Override
  public String execute() {
    if (id == null) {
      LOG.error("No checklist usage id given");
      return ERROR;
    }
    usage = usageService.get(id, getLocale());
    if (usage == null) {
      return HTTP_NOT_FOUND;
    }

    LOG.debug("Usage found ID={}, NAME={}", id, usage.getScientificName());
    LOG.info("Usage found ID={}, NAME={}", id, usage.getScientificName());

    // checklist
    checklist = checklistService.get(usage.getChecklistKey());
    // basionym
    if (usage.getBasionymKey() != null) {
      basionym = usageService.get(usage.getBasionymKey(), getLocale());
    }
    // get children
    PagingResponse<ChecklistUsage> childrenResponse = usageService.listChildren(id, getLocale(), null);
    if (childrenResponse != null) {
      LOG.debug("{} children found for usage {}", childrenResponse.getResults().size(), id);
      children = childrenResponse.getResults();
    }
    // load subresources with small page size = 10
    Pageable page10 = new PagingRequest(0, 10);
    // get synonyms
    PagingResponse<ChecklistUsage> synonymResponse = usageService.listSynonyms(id, getLocale(), page10);
    if (synonymResponse != null) {
      LOG.debug("{} synonyms found for usage {}", synonymResponse.getResults().size(), id);
      usage.setSynonyms(synonymResponse.getResults());
    }
    // get vernacular names
    PagingResponse<VernacularName> vernacularResponse = vernacularNameService.listByChecklistUsage(id, page10);
    if (vernacularResponse != null) {
      LOG.debug("{} vernacular names found for usage {}", vernacularResponse.getResults().size(), id);
      usage.setVernacularNames(vernacularResponse.getResults());
    }
    // get references
    PagingResponse<Reference> referenceResponse = referenceService.listByChecklistUsage(id, page10);
    if (referenceResponse != null) {
      LOG.info("{} references found for usage {} : "+referenceResponse.toString(), referenceResponse.getResults().size(), id);
      usage.setReferences(referenceResponse.getResults());
    }

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

  public List<ChecklistUsage> getChildren() {
    return children;
  }
}
