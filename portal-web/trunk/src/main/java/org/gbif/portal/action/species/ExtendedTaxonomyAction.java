package org.gbif.portal.action.species;

import org.gbif.portal.action.BaseAction;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class ExtendedTaxonomyAction extends BaseAction {

  private static final Logger LOG = LoggerFactory.getLogger(ExtendedTaxonomyAction.class);
  private Integer id;

  @Override
  public String execute() {
    LOG.debug("Loading extended taxonomy for species id [{}]", id);
    return SUCCESS;
  }

  public void setId(Integer id) {
    this.id = id;
  }

  public Integer getId() {
    return id;
  }
}
