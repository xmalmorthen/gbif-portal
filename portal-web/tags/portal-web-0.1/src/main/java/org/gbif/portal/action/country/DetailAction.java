package org.gbif.portal.action.country;

import org.gbif.api.exception.NotFoundException;
import org.gbif.portal.action.BaseAction;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class DetailAction extends BaseAction {

  private static final Logger LOG = LoggerFactory.getLogger(DetailAction.class);

  // detail
  private Integer id;

  @Override
  public String execute() {
    if (id != null) {
      LOG.debug("Getting detail for country id [{}]", id);
      /** TODO: implement country lookup */
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
