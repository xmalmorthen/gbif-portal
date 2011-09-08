package org.gbif.portal.action.member;

import org.gbif.portal.action.BaseAction;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class SearchAction extends BaseAction {

  private static final Logger LOG = LoggerFactory.getLogger(SearchAction.class);

  /**
   * TODO: implement member lookup
   */
  // search
  private String q;

  @Override
  public String execute() {
    LOG.debug("Trying member search for q [{}]", q);
    return SUCCESS;
  }

  public String getQ() {
    return q;
  }

  public void setQ(String q) {
    this.q = q;
  }
}
