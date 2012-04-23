package org.gbif.portal.struts;

import org.gbif.api.model.User;
import org.gbif.portal.config.Constants;
import org.gbif.user.UserService;

import java.security.Principal;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;

import com.google.inject.Inject;
import com.opensymphony.xwork2.ActionInvocation;
import com.opensymphony.xwork2.interceptor.AbstractInterceptor;
import com.sun.jersey.spi.resource.Singleton;
import org.apache.struts2.StrutsStatics;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * An Interceptor that puts the current user into the session if its not yet existing and a request principle is given.
 */
@Singleton
public class LoginInterceptor extends AbstractInterceptor {
  private static final Logger LOG = LoggerFactory.getLogger(LoginInterceptor.class);

  @Inject
  private UserService userService;

  @Override
  public String intercept(final ActionInvocation invocation) throws Exception {
    final Map session = invocation.getInvocationContext().getSession();
    final User user = (User) session.get(Constants.SESSION_USER);
    if (user == null) {
      // check if we have a principal populated by the cas filters
      HttpServletRequest request = (HttpServletRequest) invocation.getInvocationContext().get(StrutsStatics.HTTP_REQUEST);
      Principal principal = request.getUserPrincipal();
      if (principal != null){
        User u = userService.get(principal.getName());
        session.put(Constants.SESSION_USER, u);
        if (u == null){
          LOG.warn("Authenticated UserPrincipal "+principal.getName()+" not found in Drupal!");
        }
      }
    }
    return invocation.invoke();
  }

}
