package org.gbif.portal.action.country;

import org.gbif.portal.action.BaseAction;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class SearchAction extends BaseAction {

  private final static Logger LOG = LoggerFactory.getLogger(SearchAction.class);

  /**
   * TODO: implement country lookup
   */
  // search
  private String q;

  @Override
  public String execute() {
    LOG.debug("Trying country search for q [{}]", q);
    return SUCCESS;
  }

  public String getQ() {
    return q;
  }

  public void setQ(String q) {
    this.q = q;
  }
}
