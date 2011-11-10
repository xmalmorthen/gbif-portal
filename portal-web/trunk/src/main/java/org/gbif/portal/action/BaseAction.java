package org.gbif.portal.action;

import org.gbif.portal.config.Config;

import java.util.Map;
import java.util.ResourceBundle;
import java.util.TreeMap;

import javax.servlet.http.HttpServletRequest;

import com.google.inject.Inject;
import com.opensymphony.xwork2.ActionSupport;
import org.apache.struts2.interceptor.ServletRequestAware;
import org.apache.struts2.interceptor.SessionAware;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 *
 */
public abstract class BaseAction extends ActionSupport implements SessionAware, ServletRequestAware {

  protected final Logger LOG = LoggerFactory.getLogger(getClass());

  public static final String HTTP_NOT_FOUND = "404";
  public static final String HTTP_NOT_ALLOWED = "401";

  protected Map<String, Object> session;
  protected HttpServletRequest request;

  @Inject
  private Config cfg;


  /*
   * (non-Javadoc)
   * @see org.apache.struts2.interceptor.ServletRequestAware#setServletRequest(javax.servlet.http.HttpServletRequest)
   */
  @Override
  public void setServletRequest(HttpServletRequest request) {
    this.request = request;
  }

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
   * Returns the absolute url to the current page.
   *
   * @return the absolute url
   */
  public String getCurrentUrl() {
    StringBuffer currentUrl = request.getRequestURL();
    if (request.getQueryString() != null) {
      currentUrl.append("?");
      currentUrl.append(request.getQueryString());
    }
    return currentUrl.toString();
  }

  /**
   * @return The HTTP session which may be null
   */
  protected Map<String, Object> getSession() {
    return session;
  }

  /**
   * Returns a map representing properties from the resource bundle but just those
   * properties whose keys match one or more of the given prefixes.
   * 
   * @param prefix
   * @return a map which the matched properties
   */
  public Map<String, String> getResourceBundleProperties(String... prefix) {
    Map<String, String> bundleProps = new TreeMap<String, String>();
    ResourceBundle bundle = ResourceBundle.getBundle("resources", getLocale());
    // properties should be filtered out
    if (prefix != null && prefix.length != 0) {
      for (String key : bundle.keySet()) {
        // only add those properties whose key starts with one of the prefixes given
        if (containsPrefix(key, prefix)) {
          bundleProps.put(key, bundle.getString(key));
        }
      }
    } else { // just get all properties without any filtering at all
      for (String key : bundle.keySet()) {
        bundleProps.put(key, bundle.getString(key));
      }
    }
    return bundleProps;
  }

  /**
   * Checks whether a string starts with any of the prefixes specified
   * 
   * @param propertyKey
   * @param prefixes
   * @return true if string matches against any prefix. false otherwise.
   */
  private boolean containsPrefix(String propertyKey, String[] prefixes) {
    if (propertyKey != null) {
      for (String prefix : prefixes) {
        if (propertyKey.startsWith(prefix)) {
          return true;
        }
      }
    }
    return false;
  }

  public Config getCfg() {
    return cfg;
  }
}
