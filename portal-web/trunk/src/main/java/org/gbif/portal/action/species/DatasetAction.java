package org.gbif.portal.action.species;

import org.gbif.api.model.vocabulary.DatasetType;
import org.gbif.api.paging.PagingRequest;
import org.gbif.api.paging.PagingResponse;
import org.gbif.checklistbank.api.model.NameUsage;
import org.gbif.registry.api.model.Dataset;

import java.util.Iterator;
import java.util.List;
import java.util.UUID;

import com.google.common.collect.Lists;

public class DatasetAction extends UsageAction {

  private long offset = 0;
  private DatasetType type;
  private PagingResponse<Dataset> page;
  private List<NameUsage>  relatedUsages;

  @Override
  public String execute() {
    loadUsage();


    page = new PagingResponse<Dataset>();
    page.setResults(Lists.<Dataset>newArrayList());

    if (type == null || type == DatasetType.CHECKLIST) {
      PagingRequest p = new PagingRequest(offset, 25);
      relatedUsages = usageService.listRelated(usage.getNubKey(), getLocale());
      // remove nub usage itself
      Iterator<NameUsage> iter = relatedUsages.iterator();
      while (iter.hasNext()){
        if (iter.next().getKey().equals(usage.getKey())) {
          iter.remove();
        }
      }
      for (NameUsage u : relatedUsages) {
        page.getResults().add(datasetService.get(u.getDatasetKey()));
      }
    }

    if (type == null || type == DatasetType.OCCURRENCE) {
      List<UUID> relatedDatasets = usageService.listRelatedOccurrenceDatasets(usage.getNubKey());

      for (UUID uuid : relatedDatasets) {
        page.getResults().add(datasetService.get(uuid));
        page.setLimit(relatedDatasets.size() + 1);
      }
    }

    return SUCCESS;
  }

  public void setOffset(long offset) {
    this.offset = offset;
  }

  public DatasetType getType() {
    return type;
  }

  public void setType(DatasetType type) {
    this.type = type;
  }

  public PagingResponse<Dataset> getPage() {
    return page;
  }

  public List<NameUsage> getRelatedUsages() {
    return relatedUsages;
  }
}
