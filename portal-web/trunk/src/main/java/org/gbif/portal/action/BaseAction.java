package org.gbif.portal.action;

import org.gbif.api.model.User;
import org.gbif.portal.config.Config;
import org.gbif.portal.config.Constants;

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

public abstract class BaseAction extends ActionSupport implements SessionAware, ServletRequestAware {
  private static final Logger LOG = LoggerFactory.getLogger(BaseAction.class);
  protected Map<String, Object> session;
  protected HttpServletRequest request;

  @Inject
  private Config cfg;

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
   * @return true if an admin user is logged in.
   */
  public boolean isAdmin(){
    return getCurrentUser()!=null && getCurrentUser().isAdmin();
  }

  /**
   * @return the currently logged in user.
   */
  public User getCurrentUser(){
    return (User) session.get(Constants.SESSION_USER);
  }

  /**
   * Returns the application's base url
   *
   * @return the base url
   */  
  public String getBaseUrl() {
    StringBuffer baseUrl = new StringBuffer();

    baseUrl.append(request.getScheme()).append("://");
    baseUrl.append(getServerName());
    baseUrl.append(request.getContextPath());

    return baseUrl.toString();
  }

  private String getServerName() {
    String name = request.getServerName();
    int portnum = request.getServerPort();
    // Only add port if non-standard.
    if (portnum != 80) {
      name = name + ":" + String.valueOf(portnum);
    }
    return name;
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

  public Config getCfg() {
    return cfg;
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
   * @return true if string matches against any prefix. false otherwise.
   */
  private static boolean containsPrefix(String propertyKey, String[] prefixes) {
    if (propertyKey != null) {
      for (String prefix : prefixes) {
        if (propertyKey.startsWith(prefix)) {
          return true;
        }
      }
    }
    return false;
  }
}
