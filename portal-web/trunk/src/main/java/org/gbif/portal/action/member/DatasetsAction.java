package org.gbif.portal.action.member;

import org.gbif.portal.action.BaseAction;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class DatasetsAction extends BaseAction {

  private final static Logger LOG = LoggerFactory.getLogger(DatasetsAction.class);

  // detail
  private Integer id;

  @Override
  public String execute() {
    if (id != null) {
      LOG.debug("Getting datasets for member id [{}]", id);
      /** TODO: implement member lookup */
      return SUCCESS;
    }
    return HTTP_NOT_FOUND;
  }

  public void setId(Integer id) {
    this.id = id;
  }

  public Integer getId() {
    return id;
  }
}
