package org.gbif.portal.action.species;

import org.gbif.portal.action.BaseAction;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class NameUsageAction extends BaseAction {

  private static final Logger LOG = LoggerFactory.getLogger(NameUsageAction.class);

  private Integer id;

  @Override
  public String execute() {
    return nameUsage();
  }

  public String nameUsage() {
    LOG.debug("Loading name usage for species id [{}]", id);
    return SUCCESS;
  }

  public String nameUsageRaw() {
    LOG.debug("Loading raw name usage for species id [{}]", id);
    return SUCCESS;
  }

  public String nameUsageList() {
    LOG.debug("Loading name usage list for species id [{}]", id);
    return SUCCESS;
  }

  public void setId(Integer id) {
    this.id = id;
  }

  public Integer getId() {
    return id;
  }
}
