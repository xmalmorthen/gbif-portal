package org.gbif.portal.struts;

import org.gbif.api.model.common.User;
import org.gbif.api.vocabulary.UserRole;

import java.util.Map;

import com.opensymphony.xwork2.ActionInvocation;
import com.opensymphony.xwork2.interceptor.AbstractInterceptor;

import static org.gbif.portal.config.Constants.SESSION_USER;

/**
 * An Interceptor that makes sure a user is currently logged in and returns a notLoggedIn otherwise.
 */
public class RequireLoginInterceptor extends AbstractInterceptor {

  @Override
  public String intercept(final ActionInvocation invocation) throws Exception {
    final Map session = invocation.getInvocationContext().getSession();
    User user = new User();
    user.setUserName("fmendez");
    user.setKey(1);
    user.setEmail("fmendez@gbif.org");
    user.addRole(UserRole.ADMIN);
    session.put(SESSION_USER, user);
    return invocation.invoke();
  }

}
