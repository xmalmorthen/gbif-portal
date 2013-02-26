package org.gbif.portal.struts;

import org.gbif.api.model.common.User;
import org.gbif.api.service.common.UserService;
import org.gbif.portal.config.Config;
import org.gbif.user.mybatis.UserServiceImpl;

import java.util.Map;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;

import com.google.inject.Inject;
import com.opensymphony.xwork2.ActionInvocation;
import com.opensymphony.xwork2.interceptor.AbstractInterceptor;
import org.apache.struts2.StrutsStatics;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import static org.gbif.portal.config.Constants.SESSION_USER;

/**
 * An Interceptor that puts the current user into the session if its not yet existing and a request principle is given.
 */
public class DrupalSessionInterceptor extends AbstractInterceptor {
  private static final Logger LOG = LoggerFactory.getLogger(DrupalSessionInterceptor.class);

  private UserServiceImpl userService;
  private final String COOKIE_NAME;
  private final String DRUPAL_SESSION_NAME = "drupal_session";

  @Inject
  public DrupalSessionInterceptor(UserService userService, Config cfg) {
    this.userService = (UserServiceImpl) userService;
    COOKIE_NAME = cfg.getDrupalCookieName();
  }

  @Override
  public String intercept(final ActionInvocation invocation) throws Exception {
    final Map session = invocation.getInvocationContext().getSession();
    final Cookie cookie = findDrupalCookie(invocation);

    User user = (User) session.get(SESSION_USER);

    // invalidate current user if cookie is missing or drupal session is different
    if (user != null && (cookie == null || !cookie.getValue().equals(session.get(DRUPAL_SESSION_NAME)))) {
      user = null;
      session.clear();
    }

    if (user == null && cookie != null) {
      // user logged into drupal
      user = userService.getBySession(cookie.getValue());
      if (user == null){
        LOG.warn("Drupal cookie contains invalid session {}", cookie.getValue());
      } else {
        session.put(SESSION_USER, user);
        session.put(DRUPAL_SESSION_NAME, cookie.getValue());
      }
    }

    return invocation.invoke();
  }

  private Cookie findDrupalCookie(ActionInvocation invocation){
    final HttpServletRequest request = (HttpServletRequest) invocation.getInvocationContext().get(
      StrutsStatics.HTTP_REQUEST);
    
    // Above looks rather suspicious
    // http://dev.gbif.org/issues/browse/POR-569
    if (request==null || request.getCookies() == null) {
      return null;
    }
    
    for (Cookie cookie : request.getCookies()){
      if (COOKIE_NAME.equalsIgnoreCase(cookie.getName())) {
        return cookie;
      }
    }
    return null;
  }

}
