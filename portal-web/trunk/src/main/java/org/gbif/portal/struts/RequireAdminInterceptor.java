package org.gbif.portal.struts;

import org.gbif.api.model.common.User;
import org.gbif.portal.config.Constants;

import java.util.Map;

import com.opensymphony.xwork2.ActionInvocation;
import com.opensymphony.xwork2.interceptor.AbstractInterceptor;
import com.opensymphony.xwork2.util.ValueStack;

/**
 * An Interceptor that makes sure an admin user is currently logged in and returns a notAllowed otherwise
 */
public class RequireAdminInterceptor extends AbstractInterceptor {

  @Override
  public String intercept(final ActionInvocation invocation) throws Exception {
    final Map session = invocation.getInvocationContext().getSession();
    final User user = (User) session.get(Constants.SESSION_USER);
    if (user != null && user.isAdmin()) {
      return invocation.invoke();
    }

    Object action = invocation.getAction();
    ValueStack stack = invocation.getStack();

    return Constants.RESULT_NOT_ALLOWED;
  }

}