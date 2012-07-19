package org.gbif.portal.action.dataset;

import org.gbif.portal.action.BaseAction;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class OccurrencesAction extends BaseAction {

  private static final Logger LOG = LoggerFactory.getLogger(OccurrencesAction.class);

  // detail
  private Integer id;

  @Override
  public String execute() {
    LOG.debug("Getting occurrences for dataset id [{}]", id);
    return SUCCESS;
  }

  public void setId(Integer id) {
    this.id = id;
  }

  public Integer getId() {
    return id;
  }
}
