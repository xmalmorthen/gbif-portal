package org.gbif.portal.action.member;

import org.gbif.portal.action.BaseAction;
import org.gbif.portal.action.NotFoundException;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class DetailAction extends BaseAction {

  private static final Logger LOG = LoggerFactory.getLogger(DetailAction.class);

  // detail
  private Integer id;

  @Override
  public String execute() {
    if (id != null) {
      LOG.debug("Getting detail for member id [{}]", id);
      /** TODO: implement member lookup */
      return SUCCESS;
    }
    throw new NotFoundException();
  }

  public void setId(Integer id) {
    this.id = id;
  }

  public Integer getId() {
    return id;
  }
}
