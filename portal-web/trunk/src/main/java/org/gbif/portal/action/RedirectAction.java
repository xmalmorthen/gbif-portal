package org.gbif.portal.action;

import com.opensymphony.xwork2.ActionSupport;

public class RedirectAction extends ActionSupport {

  private String url;

  @Override
  public String execute() {
    LOG.debug("Redirecting to {}", url);
    return SUCCESS;
  }

  public String getUrl() {
    return url;
  }

  public void setUrl(String url) {
    this.url = url;
  }
}
