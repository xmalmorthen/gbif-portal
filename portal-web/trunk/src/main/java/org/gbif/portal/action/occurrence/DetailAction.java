package org.gbif.portal.action.occurrence;

import org.gbif.portal.action.BaseAction;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class DetailAction extends BaseAction {

  private final static Logger LOG = LoggerFactory.getLogger(DetailAction.class);

  private Integer id;

  @Override
  public String execute() {
    LOG.debug("Loading details for occurrence id [{}]", id);
    return SUCCESS;
  }

  public String raw() {
    LOG.debug("Loading raw details for occurrence id [{}]", id);
    return SUCCESS;
  }

  public Integer getId() {
    return id;
  }

  public void setId(Integer id) {
    this.id = id;
  }
}
