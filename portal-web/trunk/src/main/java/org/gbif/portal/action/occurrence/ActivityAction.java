package org.gbif.portal.action.occurrence;

import org.gbif.portal.action.BaseAction;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class ActivityAction extends BaseAction {

  private static final Logger LOG = LoggerFactory.getLogger(ActivityAction.class);

  // detail
  private Integer id;

  @Override
  public String execute() {
    if (id != null) {
      LOG.debug("Getting activity for occurrence id [{}]", id);
      /** TODO: implement occurrence lookup */
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
