package org.gbif.portal.action.species;

import org.gbif.api.paging.Pageable;
import org.gbif.api.paging.PagingRequest;
import org.gbif.api.paging.PagingResponse;
import org.gbif.checklistbank.api.model.Identifier;
import org.gbif.checklistbank.api.model.NameUsage;
import org.gbif.checklistbank.api.model.SpeciesProfile;
import org.gbif.checklistbank.api.service.DescriptionService;
import org.gbif.checklistbank.api.service.DistributionService;
import org.gbif.checklistbank.api.service.IdentifierService;
import org.gbif.checklistbank.api.service.ImageService;
import org.gbif.checklistbank.api.service.ReferenceService;
import org.gbif.checklistbank.api.service.SpeciesProfileService;
import org.gbif.checklistbank.api.service.TypeSpecimenService;
import org.gbif.checklistbank.api.service.VernacularNameService;

import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.SortedSet;
import java.util.TreeSet;
import java.util.UUID;

import com.google.inject.Inject;
import freemarker.template.utility.StringUtil;

public class DetailAction extends UsageAction {

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
  @Inject
  private SpeciesProfileService speciesProfileService;
  @Inject
  private TypeSpecimenService typeSpecimenService;

  private NameUsage basionym;
  private LinkedList<NameUsage> related = new LinkedList<NameUsage>();
  private List<UUID> relatedDatasets = new ArrayList<UUID>();
  // TODO: remove the children property once the taxonomic browser is working via ajax
  private List<NameUsage> children;

  // various pagesizes used
  private Pageable page20 = new PagingRequest(0, 20);
  private Pageable page10 = new PagingRequest(0, 10);


  @Override
  public String execute() {
    loadUsage();

    // load usage details
    loadUsageDetails();

    // load checklist lookup map
    for (NameUsage u : related) {
      loadChecklist(u.getChecklistKey());
    }

    return SUCCESS;
  }

  private void loadUsageDetails() {
    // basionym
    if (usage.getBasionymKey() != null) {
      basionym = usageService.get(usage.getBasionymKey(), getLocale());
    }

    // get children
    PagingResponse<NameUsage> childrenResponse = usageService.listChildren(id, getLocale(), page20);
    children = childrenResponse.getResults();

    // get non nub related usages & occ datasets
    if (usage.getNubKey() != null) {
      PagingResponse<NameUsage> relatedResponse = usageService.listRelated(usage.getNubKey(), getLocale(), page10);
      for (NameUsage u : relatedResponse.getResults()) {
        // ignore this usage
        if (!u.getKey().equals(usage.getKey())) {
          related.add(u);
        }
      }
      relatedDatasets = usageService.listRelatedOccurrenceDatasets(usage.getNubKey());
    }


    // get synonyms
    PagingResponse<NameUsage> synonymResponse = usageService.listSynonyms(id, getLocale(), page10);
    usage.setSynonyms(synonymResponse.getResults());

    // get identifier
    PagingResponse<Identifier> identifierResponse = identifierService.listByUsage(id, page10);
    usage.setIdentifiers(identifierResponse.getResults());

    // get vernacular names
    usage.setVernacularNames(vernacularNameService.listByUsage(id, page10).getResults());
    // get references
    usage.setReferences(referenceService.listByUsage(id, page10).getResults());
    // get descriptions
    usage.setDescriptions(descriptionService.listByUsage(id, page10).getResults());
    // get distributions
    usage.setDistributions(distributionService.listByUsage(id, page10).getResults());
    // get images
    usage.setImages(imageService.listByUsage(id, page10).getResults());
    // get typeSpecimens
    usage.setTypeSpecimens(typeSpecimenService.listByUsage(id, page10).getResults());
    // get species profiles
    List<SpeciesProfile> rawResults = speciesProfileService.listByUsage(id, page10).getResults();
    if (rawResults.size() == 1) {
      usage.setSpeciesProfiles(rawResults);
    } else {
      // build one representative species profile to show to the view
      SpeciesProfile agg = new SpeciesProfile();
      SortedSet<String> habitats = new TreeSet<String>();
      SortedSet<String> lifeForms = new TreeSet<String>();
      SortedSet<String> livingPeriods = new TreeSet<String>();
      for (SpeciesProfile sp : rawResults) {
        agg.setAgeInDays(nullSafeMax(agg.getAgeInDays(), sp.getAgeInDays()));
        agg.setMassInGram(nullSafeMax(agg.getMassInGram(), sp.getMassInGram()));
        agg.setSizeInMillimeter(nullSafeMax(agg.getSizeInMillimeter(), sp.getSizeInMillimeter()));
        agg.setHybrid(nullSafeOr(agg.isHybrid(), sp.isHybrid()));
        agg.setMarine(nullSafeOr(agg.isMarine(), sp.isMarine()));
        agg.setTerrestrial(nullSafeOr(agg.isTerrestrial(), sp.isTerrestrial()));
        agg.setExtinct(nullSafeOr(agg.isExtinct(), sp.isExtinct()));

        if (sp.getHabitat() != null) habitats.add(StringUtil.capitalize(sp.getHabitat()));
        if (sp.getLifeForm() != null) lifeForms.add(StringUtil.capitalize(sp.getLifeForm()));
        if (sp.getLivingPeriod() != null) livingPeriods.add(StringUtil.capitalize(sp.getLivingPeriod()));
      }
      String habitatString = habitats.toString();
      if (habitatString.length() > 0) agg.setHabitat(habitatString.substring(1, habitatString.length() - 1));
      String lifeFormString = lifeForms.toString();
      if (lifeFormString.length() > 0) agg.setLifeForm(lifeFormString.substring(1, lifeFormString.length() - 1));
      String livingPeriodString = livingPeriods.toString();
      if (livingPeriodString.length() > 0) {
        agg.setLivingPeriod(livingPeriodString.substring(1, livingPeriodString.length() - 1));
      }

      // use terrestrial and marine to make the habitat string more useful
      String terrString = null;
      if (agg.isTerrestrial() != null && agg.isTerrestrial() && agg.isMarine() != null && agg.isMarine()) {
        terrString = getText("species.terrestrial_and_marine");
      } else if (agg.isTerrestrial() != null && agg.isTerrestrial()) {
        terrString = getText("species.terrestrial");
      } else if (agg.isMarine() != null && agg.isMarine()) {
        terrString = getText("species.marine");
      }
      if (terrString != null) {
        if (agg.getHabitat() == null) {
          agg.setHabitat(terrString);
        } else {
          agg.setHabitat(terrString + ": " + agg.getHabitat());
        }
      }
      List<SpeciesProfile> output = new ArrayList<SpeciesProfile>();
      output.add(agg);
      usage.setSpeciesProfiles(output);
    }
  }

  public NameUsage getUsage() {
    return usage;
  }

  public NameUsage getBasionym() {
    return basionym;
  }

  public List<NameUsage> getChildren() {
    return children;
  }

  public List<NameUsage> getRelated() {
    return related;
  }

  public boolean isNub() {
    return usage.isNub();
  }

  private Integer nullSafeMax(Integer a, Integer b) {
    if (a == null) return b;
    if (b == null) return a;
    return Math.max(a, b);
  }

  private Boolean nullSafeOr(Boolean a, Boolean b) {
    if (a == null) return b;
    if (b == null) return a;
    return (a || b);
  }

  private String nullSafeConcat(String a, String b) {
    if (a == null) return b;
    if (b == null) return a;
    return a + ", " + b;
  }
  
  public Map<String, String> getResourceBundleProperties() {
    return super.getResourceBundleProperties("enum.rank.");
  }

  public List<UUID> getRelatedDatasets() {
    return relatedDatasets;
  }
}
