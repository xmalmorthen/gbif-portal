package org.gbif.portal.action;

import java.util.Map;

import com.opensymphony.xwork2.ActionSupport;
import org.apache.struts2.interceptor.SessionAware;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 *
 */
public abstract class BaseAction extends ActionSupport implements SessionAware {

  private static final Logger LOG = LoggerFactory.getLogger(BaseAction.class);

  public static final String HTTP_NOT_FOUND = "404";
  public static final String HTTP_NOT_ALLOWED = "401";

  private Map<String, Object> session;

  @Override
  public String execute() {
    LOG.debug("Executing action class: " + this.getClass().getName());
    return SUCCESS;
  }

  @Override
  public void setSession(Map<String, Object> session) {
    this.session = session;
  }


  /**
   * @return The HTTP session which may be null
   */
  protected Map<String, Object> getSession() {
    return session;
  }
}
