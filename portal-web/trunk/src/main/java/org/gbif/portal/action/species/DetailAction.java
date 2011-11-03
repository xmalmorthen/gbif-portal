package org.gbif.portal.action.species;

import org.gbif.api.paging.Pageable;
import org.gbif.api.paging.PagingRequest;
import org.gbif.api.paging.PagingResponse;
import org.gbif.checklistbank.api.Constants;
import org.gbif.checklistbank.api.model.Checklist;
import org.gbif.checklistbank.api.model.ChecklistUsage;
import org.gbif.checklistbank.api.model.Identifier;
import org.gbif.checklistbank.api.model.NameUsage;
import org.gbif.checklistbank.api.service.ChecklistService;
import org.gbif.checklistbank.api.service.ChecklistUsageService;
import org.gbif.checklistbank.api.service.DescriptionService;
import org.gbif.checklistbank.api.service.DistributionService;
import org.gbif.checklistbank.api.service.IdentifierService;
import org.gbif.checklistbank.api.service.ImageService;
import org.gbif.checklistbank.api.service.ReferenceService;
import org.gbif.checklistbank.api.service.VernacularNameService;
import org.gbif.portal.action.BaseAction;

import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.UUID;

import com.google.inject.Inject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class DetailAction extends BaseAction {

  private static final Logger LOG = LoggerFactory.getLogger(DetailAction.class);

  @Inject
  private ChecklistUsageService usageService;
  @Inject
  private ChecklistService checklistService;
  @Inject
  private VernacularNameService vernacularNameService;
  @Inject
  private ReferenceService referenceService;
  @Inject
  private DescriptionService descriptionService;
  @Inject
  private IdentifierService identifierService;
  @Inject
  private ImageService imageService;
  @Inject
  private DistributionService distributionService;

  private Integer id;
  private Checklist checklist;
  private ChecklistUsage usage;
  private ChecklistUsage basionym;
  private LinkedList<NameUsage> related = new LinkedList<NameUsage>();
  private Map<UUID, Checklist> checklists = new HashMap<UUID, Checklist>();
  // TODO: remove the children property once the taxonomic browser is working via ajax
  private List<ChecklistUsage> children;

  // various pagesizes used
  private Pageable page20 = new PagingRequest(0, 20);
  private Pageable page10 = new PagingRequest(0, 10);
  private Pageable page7 = new PagingRequest(0, 7);


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

    // load usage details
    loadSharedUsageDetails();

    // is this a nub or simple checklist usage?
    if (Constants.NUB_TAXONOMY_KEY.equals(usage.getChecklistKey())) {
      loadNubUsageSpecifics();
    } else {
      loadChecklistUsageSpecifics();
    }

    // load checklist lookup map
    Set<UUID> cids = new HashSet<UUID>();
    for (NameUsage u : related){
      cids.add(u.getChecklistKey());
    }
    for (UUID u : cids){
      checklists.put(u, checklistService.get(u));
    }

    return SUCCESS;
  }

  private void loadSharedUsageDetails() {
    // checklist
    checklist = checklistService.get(usage.getChecklistKey());

    // basionym
    if (usage.getBasionymKey() != null) {
      basionym = usageService.get(usage.getBasionymKey(), getLocale());
    }

    // get children
    PagingResponse<ChecklistUsage> childrenResponse = usageService.listChildren(id, getLocale(), page20);
    children = childrenResponse.getResults();

    // get non nub related usages
    if (usage.getNubKey() != null){
      PagingResponse<ChecklistUsage> relatedResponse = usageService.listByNubUsage(usage.getNubKey(), getLocale(), page7);
      for (ChecklistUsage u : relatedResponse.getResults()){
        // ignore this usage
        if (!u.getKey().equals(usage.getKey())){
          related.add(u);
        }
      }
    }

    // get synonyms
    PagingResponse<ChecklistUsage> synonymResponse = usageService.listSynonyms(id, getLocale(), page10);
    usage.setSynonyms(synonymResponse.getResults());

    // get identifier
    PagingResponse<Identifier> identifierResponse = identifierService.listByChecklistUsage(id, page10);
    usage.setIdentifiers(identifierResponse.getResults());
  }

  private void loadNubUsageSpecifics() {
    // get vernacular names
    usage.setVernacularNames(vernacularNameService.listByNubUsage(id, page10).getResults());
    // get references
    usage.setReferences(referenceService.listByNubUsage(id, page10).getResults());
    // get descriptions
    usage.setDescriptions(descriptionService.listByNubUsage(id, page10).getResults());
    // get distributions
    usage.setDistributions(distributionService.listByNubUsage(id, page10).getResults());
    // get images
    usage.setImages(imageService.listByNubUsage(id, page10).getResults());
  }

  private void loadChecklistUsageSpecifics() {
    // add nub as first related usage
    if (usage.getNubKey() != null){
      related.addFirst(usageService.get(usage.getNubKey(), getLocale()));
    }
    // get vernacular names
    usage.setVernacularNames(vernacularNameService.listByChecklistUsage(id, page10).getResults());
    // get references
    usage.setReferences(referenceService.listByChecklistUsage(id, page10).getResults());
    // get descriptions
    usage.setDescriptions(descriptionService.listByChecklistUsage(id, page10).getResults());
    // get distributions
    usage.setDistributions(distributionService.listByChecklistUsage(id, page10).getResults());
    // get images
    usage.setImages(imageService.listByChecklistUsage(id, page10).getResults());
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

  public List<NameUsage> getRelated() {
    return related;
  }

  public Map<UUID, Checklist> getChecklists() {
    return checklists;
  }

  public boolean isNub() {
    if (checklist != null && Constants.NUB_TAXONOMY_KEY.equals(checklist.getKey())) {
      return true;
    }
    return false;
  }
}
