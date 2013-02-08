package org.gbif.portal.struts;

import org.gbif.api.model.common.User;
import org.gbif.api.service.common.UserService;
import org.gbif.portal.config.Config;
import org.gbif.portal.config.Constants;
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

/**
 * An Interceptor that puts the current user into the session if its not yet existing and a request principle is given.
 */
public class DrupalSessionInterceptor extends AbstractInterceptor {
  private static final Logger LOG = LoggerFactory.getLogger(DrupalSessionInterceptor.class);

  private UserServiceImpl userService;
  private final String COOKIE_NAME;

  @Inject
  public DrupalSessionInterceptor(UserService userService, Config cfg) {
    this.userService = (UserServiceImpl) userService;
    COOKIE_NAME = cfg.getDrupalCookieName();
  }

  @Override
  public String intercept(final ActionInvocation invocation) throws Exception {
    final Map session = invocation.getInvocationContext().getSession();
    final User user = (User) session.get(Constants.SESSION_USER);
    final Cookie cookie = findDrupalCookie(invocation);
    if (user == null && cookie != null) {
      // user logged into drupal
      User u = userService.getBySession(cookie.getValue());
      session.put(Constants.SESSION_USER, u);
      if (u == null){
        LOG.warn("Drupal cookie contains invalid session {}", cookie.getValue());
      }
    } else if (user != null && cookie == null) {
      // user logged out in drupal!
      session.clear();
    }
    return invocation.invoke();
  }

  private Cookie findDrupalCookie(ActionInvocation invocation){
    final HttpServletRequest request = (HttpServletRequest) invocation.getInvocationContext().get(
      StrutsStatics.HTTP_REQUEST);
    for (Cookie cookie : request.getCookies()){
      if (COOKIE_NAME.equalsIgnoreCase(cookie.getName())) {
        return cookie;
      }
    }
    return null;
  }

}
