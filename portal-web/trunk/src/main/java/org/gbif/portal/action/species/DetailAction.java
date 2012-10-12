package org.gbif.portal.action.species;

import org.gbif.api.model.checklistbank.Description;
import org.gbif.api.model.checklistbank.NameUsage;
import org.gbif.api.model.checklistbank.NameUsageComponent;
import org.gbif.api.model.checklistbank.TypeSpecimen;
import org.gbif.api.model.checklistbank.VernacularName;
import org.gbif.api.model.common.paging.Pageable;
import org.gbif.api.model.common.paging.PagingRequest;
import org.gbif.api.model.common.paging.PagingResponse;
import org.gbif.api.service.checklistbank.DescriptionService;
import org.gbif.api.service.checklistbank.DistributionService;
import org.gbif.api.service.checklistbank.ImageService;
import org.gbif.api.service.checklistbank.ReferenceService;
import org.gbif.api.service.checklistbank.SpeciesProfileService;
import org.gbif.api.service.checklistbank.TypeSpecimenService;
import org.gbif.api.service.checklistbank.VernacularNameService;
import org.gbif.api.vocabulary.Language;
import org.gbif.portal.model.VernacularLocaleComparator;

import java.util.Collections;
import java.util.LinkedHashMap;
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
  private final LinkedHashMap<String, List<VernacularName>> vernacularNames = Maps.newLinkedHashMap();
  private final List<NameUsage> related = new LinkedList<NameUsage>();
  private List<UUID> relatedDatasets = Lists.newArrayList();

  // various pagesizes used
  private final Pageable page100 = new PagingRequest(0, 100);
  private final Pageable page50 = new PagingRequest(0, 50);
  private final Pageable page20 = new PagingRequest(0, 20);
  private final Pageable page10 = new PagingRequest(0, 10);
  private final Pageable page6 = new PagingRequest(0, 6);
  private final Pageable page4 = new PagingRequest(0, 4);
  private final Pageable page1 = new PagingRequest(0, 1);

  private final Map<String, Integer> typeStatusCounts = Maps.newHashMap();
  private final DescriptionToc descriptionToc = new DescriptionToc();
  private List<String> habitats = Lists.newArrayList();

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

  /**
   * Filters duplicates from vernacular names and sorts names based on language first.
   */
  private void distinctVernNames() {
    // sort by language and then name
    VernacularLocaleComparator comparator = new VernacularLocaleComparator(Language.fromIsoCode(getLocale().getISO3Language()));
    Collections.sort(usage.getVernacularNames(), comparator);

    for (VernacularName v : usage.getVernacularNames()) {
      if (Strings.isNullOrEmpty(v.getVernacularName())) {
        continue;
      }
      String id = v.getVernacularName().toLowerCase() + "||";
      if (v.getLanguage() != null) {
        id = id + v.getLanguage().getIso2LetterCode();
      }
      if (!vernacularNames.containsKey(id)) {
        vernacularNames.put(id, Lists.<VernacularName>newArrayList());
      }
      vernacularNames.get(id).add(v);
    }
  }

  @Override
  public String execute() {
    loadUsage();

    // load usage details
    loadUsageDetails();

    // remove duplicates
    distinctVernNames();

    // calc habitats
    calcHabitats();

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

  private void calcHabitats() {
    // add boolean flags first
    addHabitatFlag(usage.isTerrestrial(), "terrestrial");
    addHabitatFlag(usage.isMarine(), "marine");
    addHabitatFlag(usage.isFreshwater(), "freshwater");
    // now all other uncontrolled habitats
    for (String h : usage.getHabitats()) {
      habitats.add(h);
    }
  }

  private void addHabitatFlag(Boolean flag, String flagName) {
    if (flag != null) {
      StringBuilder sb = new StringBuilder();
      if (!flag) {
        sb.append(getText("not"));
        sb.append(" ");
      }
      sb.append(getText("enum.habitat."+flagName));
      habitats.add(sb.toString());
    }
  }

  public NameUsage getBasionym() {
    return basionym;
  }

  public DescriptionToc getDescriptionToc() {
    return descriptionToc;
  }

  public List<NameUsage> getRelated() {
    return related;
  }

  public List<UUID> getRelatedDatasets() {
    return relatedDatasets;
  }

  public Map<String, String> getResourceBundleProperties() {
    return getResourceBundleProperties("enum.rank.");
  }

  public Map<String, Integer> getTypeStatusCounts() {
    return typeStatusCounts;
  }

  public Map<String, List<VernacularName>> getVernacularNames() {
    return vernacularNames;
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
    usage.setVernacularNames(vernacularNameService.listByUsage(id, page100).getResults());
    // get references
    usage.setReferences(referenceService.listByUsage(id, page10).getResults());
    // get description content table
    for (Description d : descriptionService.listByUsage(id, page50).getResults()) {
      descriptionToc.addDescription(d);
    }
    // get distributions
    usage.setDistributions(distributionService.listByUsage(id, page6).getResults());
    // get first image only
    usage.setImages(imageService.listByUsage(id, page1).getResults());
    // get typeSpecimens
    usage.setTypeSpecimens(typeSpecimenService.listByUsage(id, page10).getResults());
    // get species profiles
    usage.setSpeciesProfiles(speciesProfileService.listByUsage(id, page20).getResults());
  }

  public List<String> getHabitats() {
    return habitats;
  }
}
