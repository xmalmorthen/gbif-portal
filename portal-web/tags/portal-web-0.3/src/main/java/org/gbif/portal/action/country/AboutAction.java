package org.gbif.portal.action.country;

import org.gbif.api.model.registry.Dataset;

import java.util.List;

import com.google.common.collect.Lists;

public class AboutAction extends CountryBaseAction {
  private List<Dataset> datasets = Lists.newArrayList();


  public List<Dataset> getDatasets() {
    return datasets;
  }
}
