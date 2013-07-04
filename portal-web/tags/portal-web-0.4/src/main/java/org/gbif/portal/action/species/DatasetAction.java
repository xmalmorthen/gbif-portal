package org.gbif.portal.action.species;

import org.gbif.api.model.checklistbank.NameUsage;
import org.gbif.api.model.common.paging.PagingResponse;
import org.gbif.api.model.registry2.Dataset;
import org.gbif.api.service.occurrence.OccurrenceDatasetIndexService;
import org.gbif.api.vocabulary.DatasetType;

import java.util.Iterator;
import java.util.List;
import java.util.SortedMap;
import java.util.UUID;

import com.google.common.collect.Lists;
import com.google.inject.Inject;

public class DatasetAction extends UsageBaseAction {

  @Inject
  private OccurrenceDatasetIndexService occurrenceDatasetService;

  private DatasetType type;
  private PagingResponse<DatasetResult> page;
  private int offset = 0;
  private static final int pageSize = 25;

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

    page = new PagingResponse<DatasetResult>(offset, pageSize);

    if (type == null || type == DatasetType.CHECKLIST) {
      List<NameUsage> relatedUsages = usageService.listRelated(usage.getNubKey(), getLocale());
      // remove nub usage itself
      Iterator<NameUsage> iter = relatedUsages.iterator();
      while (iter.hasNext()){
        if (iter.next().getKey().equals(usage.getKey())) {
          iter.remove();
        }
      }

      page.setCount( (long) relatedUsages.size());
      for (NameUsage u : sublist(relatedUsages, offset, offset + pageSize)) {
        page.getResults().add(new DatasetResult(datasetService.get(u.getDatasetKey()), null, u));
      }
    }

    if ((type == null || type == DatasetType.OCCURRENCE) && usage.getNubKey() != null) {
      SortedMap<UUID, Integer> occurrenceDatasetCounts = occurrenceDatasetService.occurrenceDatasetsForNubKey(usage.getNubKey());
      page.setCount( (long) occurrenceDatasetCounts.size());
      for (UUID uuid : sublist(Lists.newArrayList(occurrenceDatasetCounts.keySet()), offset, offset + pageSize)) {
        page.getResults().add(new DatasetResult(datasetService.get(uuid), occurrenceDatasetCounts.get(uuid), null));
      }
    }

    return SUCCESS;
  }

  public DatasetType getType() {
    return type;
  }

  public void setType(DatasetType type) {
    this.type = type;
  }

  public PagingResponse<DatasetResult> getPage() {
    return page;
  }

  public int getOffset() {
    return offset;
  }

  public void setOffset(int offset) {
    this.offset = offset;
  }
}
