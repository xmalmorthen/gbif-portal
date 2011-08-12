package org.gbif.portal.action.occurrence;

import org.gbif.portal.action.BaseAction;

public class DetailAction extends BaseAction {

  private Integer id;

  @Override
  public String execute() {
    log.debug("Loading details for occurrence id [{}]", id);
    return SUCCESS;
  }

  public String raw() {
    log.debug("Loading raw details for occurrence id [{}]", id);
    return SUCCESS;
  }

  public Integer getId() {
    return id;
  }

  public void setId(Integer id) {
    this.id = id;
  }
}
