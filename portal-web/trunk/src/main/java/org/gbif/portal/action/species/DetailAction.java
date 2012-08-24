package org.gbif.portal.action.species;

import org.gbif.api.paging.Pageable;
import org.gbif.api.paging.PagingRequest;
import org.gbif.api.paging.PagingResponse;
import org.gbif.checklistbank.api.model.NameUsage;
import org.gbif.checklistbank.api.model.NameUsageComponent;
import org.gbif.checklistbank.api.model.TypeSpecimen;
import org.gbif.checklistbank.api.model.VernacularName;
import org.gbif.checklistbank.api.service.DescriptionService;
import org.gbif.checklistbank.api.service.DistributionService;
import org.gbif.checklistbank.api.service.ImageService;
import org.gbif.checklistbank.api.service.ReferenceService;
import org.gbif.checklistbank.api.service.SpeciesProfileService;
import org.gbif.checklistbank.api.service.TypeSpecimenService;
import org.gbif.checklistbank.api.service.VernacularNameService;

import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import com.google.common.base.Strings;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.google.inject.Inject;

public class DetailAction extends UsageBaseAction {

  @Inject
  private VernacularNameService vernacularNameService;
  @Inject
  private ReferenceService referenceService;
  @Inject
  private DescriptionService descriptionService;
  @Inject
  private ImageService imageService;
  @Inject
  private DistributionService distributionService;
  @Inject
  private SpeciesProfileService speciesProfileService;
  @Inject
  private TypeSpecimenService typeSpecimenService;

  private NameUsage basionym;
  // list of unique names listing all sources for each
  private Map<String, List<VernacularName>> vernacularNames = Maps.newLinkedHashMap();
  private final List<NameUsage> related = new LinkedList<NameUsage>();
  private List<UUID> relatedDatasets = Lists.newArrayList();

  // various pagesizes used
  private final Pageable page20 = new PagingRequest(0, 20);
  private final Pageable page10 = new PagingRequest(0, 10);
  private final Pageable page6 = new PagingRequest(0, 6);
  private final Pageable page4 = new PagingRequest(0, 4);

  private final Map<String, Integer> typeStatusCounts = new HashMap<String, Integer>();

  @Override
  public String execute() {
    loadUsage();

    // load usage details
    loadUsageDetails();

    // remove duplicates
    distinctVernNames();

    // load checklist lookup map
    for (NameUsage u : related) {
      loadDataset(u.getDatasetKey());
    }
    for (UUID uuid : relatedDatasets) {
      loadDataset(uuid);
    }
    for (NameUsageComponent c : usage.getExternalLinks()) {
      loadDataset(c.getDatasetKey());
    }
    for (NameUsageComponent c : usage.getImages()) {
      loadDataset(c.getDatasetKey());
    }
    for (NameUsageComponent c : usage.getDescriptions()) {
      loadDataset(c.getDatasetKey());
    }
    for (NameUsageComponent c : usage.getDistributions()) {
      loadDataset(c.getDatasetKey());
    }
    for (NameUsageComponent c : usage.getReferences()) {
      loadDataset(c.getDatasetKey());
    }
    for (NameUsageComponent c : usage.getTypeSpecimens()) {
      loadDataset(c.getDatasetKey());
    }
    for (NameUsageComponent c : usage.getVernacularNames()) {
      loadDataset(c.getDatasetKey());
    }

    // calc typeSpecimen typestatus counts
    calcTypeSpecimenFacets();

    return SUCCESS;
  }

  private void loadUsageDetails() {
    // basionym
    if (usage.getBasionymKey() != null) {
      basionym = usageService.get(usage.getBasionymKey(), getLocale());
    }

    // get non nub related usages & occ datasets
    if (usage.getNubKey() != null) {
      List<NameUsage> relatedResponse = usageService.listRelated(usage.getNubKey(), getLocale());
      for (NameUsage u : relatedResponse) {
        // ignore this usage
        if (!u.getKey().equals(usage.getKey())) {
          related.add(u);
        }
      }
      relatedDatasets = usageService.listRelatedOccurrenceDatasets(usage.getNubKey());
    }


    // get synonyms
    PagingResponse<NameUsage> synonymResponse = usageService.listSynonyms(id, getLocale(), page6);
    usage.setSynonyms(synonymResponse.getResults());

    // get vernacular names
    usage.setVernacularNames(vernacularNameService.listByUsage(id, page4).getResults());
    // get references
    usage.setReferences(referenceService.listByUsage(id, page10).getResults());
    // get description content table
    //usage.setDescriptions(descriptionService.listByUsage(id, getLocale(), page10).getResults());
    // get distributions
    usage.setDistributions(distributionService.listByUsage(id, page6).getResults());
    // get images
    usage.setImages(imageService.listByUsage(id, page20).getResults());
    // get typeSpecimens
    usage.setTypeSpecimens(typeSpecimenService.listByUsage(id, page10).getResults());
    // get species profiles
    usage.setSpeciesProfiles(speciesProfileService.listByUsage(id, page10).getResults());
  }

  /**
   * Filters duplicates from vernacular names.
   */
  private void distinctVernNames() {
    for (VernacularName v : usage.getVernacularNames()) {
      if (Strings.isNullOrEmpty(v.getVernacularName())) {
        continue;
      }
      String lang = "";
      if (v.getLanguage() != null && v.getLanguage().getInterpreted() != null){
        lang = v.getLanguage().getInterpreted().getIso2LetterCode();
      }
      String id = v.getVernacularName() + "||" + lang;
      if (!vernacularNames.containsKey(id)) {
        vernacularNames.put(id, Lists.<VernacularName>newArrayList());
      }
      vernacularNames.get(id).add(v);
    }
  }

  /**
   * Iterate through all types and count the number of times each different
   * typeStatus appears. Store this information in a map, key=typeStatus and value=count. This map is used in the .ftl
   * to filter the TypeSpecimen.
   */
  public void calcTypeSpecimenFacets() {
    for (TypeSpecimen ts : usage.getTypeSpecimens()) {
      String typeStatus = Strings.emptyToNull(ts.getTypeStatus());
      if (typeStatus != null) {
        if (typeStatusCounts.containsKey(typeStatus)) {
          int count = typeStatusCounts.get(typeStatus);
          count++;
          typeStatusCounts.put(typeStatus, count);
        } else {
          typeStatusCounts.put(typeStatus, 1);
        }
      }
    }
  }

  public NameUsage getBasionym() {
    return basionym;
  }

  public List<NameUsage> getRelated() {
    return related;
  }

  private static Integer nullSafeMax(Integer a, Integer b) {
    if (a == null) return b;
    if (b == null) return a;
    return Math.max(a, b);
  }

  private static Boolean nullSafeOr(Boolean a, Boolean b) {
    if (a == null) return b;
    if (b == null) return a;
    return a || b;
  }

  private static String nullSafeConcat(String a, String b) {
    if (a == null) return b;
    if (b == null) return a;
    return a + ", " + b;
  }

  public Map<String, String> getResourceBundleProperties() {
    return getResourceBundleProperties("enum.rank.");
  }

  public List<UUID> getRelatedDatasets() {
    return relatedDatasets;
  }

  public Map<String, Integer> getTypeStatusCounts() {
    return typeStatusCounts;
  }

  public Map<String, List<VernacularName>> getVernacularNames() {
    return vernacularNames;
  }
}
