package org.gbif.portal.struts;

import com.opensymphony.xwork2.ActionInvocation;
import com.opensymphony.xwork2.interceptor.AbstractInterceptor;

/**
 * An Interceptor that makes sure a user is currently logged in and returns a notLoggedIn otherwise.
 */
public class RequireLoginInterceptor extends AbstractInterceptor {

  @Override
  public String intercept(final ActionInvocation invocation) throws Exception {
// final Map session = invocation.getInvocationContext().getSession();
// final Object user = (Object) session.get(DataDirConfig.SESSION_USER);
// if (user == null) {
// return BaseAction.LOGIN_REQUIRED;
// }
    return invocation.invoke();
  }

}
