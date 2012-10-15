package org.gbif.portal.action.species;

import org.gbif.api.model.checklistbank.NameUsage;
import org.gbif.api.model.metrics.cube.OccurrenceCube;
import org.gbif.api.model.metrics.cube.ReadBuilder;
import org.gbif.api.model.registry.Dataset;
import org.gbif.api.vocabulary.DatasetType;

import java.util.Collections;
import java.util.Iterator;
import java.util.List;
import java.util.UUID;

import com.google.common.collect.Lists;

public class DatasetAction extends UsageBaseAction {

  private DatasetType type;
  private List<DatasetResult> results = Lists.newArrayList();

  public class DatasetResult implements Comparable<DatasetResult>{
    private Dataset dataset;
    private Integer numOccurrences;
    private NameUsage usage;

    public DatasetResult(Dataset dataset, Integer numOccurrences, NameUsage usage) {
      this.dataset = dataset;
      this.numOccurrences = numOccurrences;
      this.usage = usage;
    }

    public Dataset getDataset() {
      return dataset;
    }

    public Integer getNumOccurrences() {
      return numOccurrences;
    }

    public NameUsage getUsage() {
      return usage;
    }

    @Override
    public int compareTo(DatasetResult that) {
      if ( this == that ) return 0;
      return dataset.getTitle().toLowerCase().compareTo(that.getDataset().getTitle().toLowerCase());
    }
  }

  @Override
  public String execute() {
    loadUsage();


    if (type == null || type == DatasetType.CHECKLIST) {
      List<NameUsage> relatedUsages = usageService.listRelated(usage.getNubKey(), getLocale());
      // remove nub usage itself
      Iterator<NameUsage> iter = relatedUsages.iterator();
      while (iter.hasNext()){
        if (iter.next().getKey().equals(usage.getKey())) {
          iter.remove();
        }
      }

      for (NameUsage u : relatedUsages) {
        results.add(new DatasetResult(datasetService.get(u.getDatasetKey()), null, u));
      }
    }

    if (type == null || type == DatasetType.OCCURRENCE) {
      List<UUID> relatedDatasets = usageService.listRelatedOccurrenceDatasets(usage.getNubKey());

      for (UUID uuid : relatedDatasets) {
        int count = 0;
        try {
          // The occurrence dimensions are calculated for the dataset and the nub key 
          count = (int) occurrenceCubeService.get(
            new ReadBuilder()
              .at(OccurrenceCube.DATASET_KEY, uuid)
              .at(OccurrenceCube.NUB_KEY, usage.getKey()));
        } catch (Exception e) {
          LOG.error("Unable to read occurrence cube for usage[" + usage.getKey() + "] dataset[" + usage.getDatasetKey()+ "]", e);
        }
        results.add(new DatasetResult(datasetService.get(uuid), count, null));
      }
    }

    // sort results alphabetically
    Collections.sort(results);

    return SUCCESS;
  }

  public DatasetType getType() {
    return type;
  }

  public void setType(DatasetType type) {
    this.type = type;
  }

  public List<DatasetResult> getResults() {
    return results;
  }
}
