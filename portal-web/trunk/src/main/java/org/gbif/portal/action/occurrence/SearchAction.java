package org.gbif.portal.action.occurrence;

import org.gbif.portal.action.BaseAction;

public class SearchAction extends BaseAction {

  // search
  private String q;

  @Override
  public String execute() {
    log.debug("Trying occurrence search for q [{}]", q);
    return SUCCESS;
  }

  public String getQ() {
    return q;
  }

  public void setQ(String q) {
    this.q = q;
  }
}
