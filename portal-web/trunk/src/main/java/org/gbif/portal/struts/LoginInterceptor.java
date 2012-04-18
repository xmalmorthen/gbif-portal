package org.gbif.portal.struts;

import org.gbif.api.model.User;
import org.gbif.portal.config.Constants;

import java.security.Principal;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;

import com.opensymphony.xwork2.ActionInvocation;
import com.opensymphony.xwork2.interceptor.AbstractInterceptor;
import org.apache.struts2.StrutsStatics;

/**
 * An Interceptor that puts the current user into the session if its not yet existing and a request principle is given.
 */
public class LoginInterceptor extends AbstractInterceptor {

  @Override
  public String intercept(final ActionInvocation invocation) throws Exception {
    final Map session = invocation.getInvocationContext().getSession();
    final User user = (User) session.get(Constants.SESSION_USER);
    if (user == null) {
      // check if we have a principal populated by the cas filters
      HttpServletRequest request = (HttpServletRequest) invocation.getInvocationContext().get(StrutsStatics.HTTP_REQUEST);
      Principal principal = request.getUserPrincipal();
      if (principal != null){
        // TODO: load User into session via user service
        User u = new User();
        u.setName(principal.getName());
        u.setFirstName("first");
        u.setLastName("last");
        session.put(Constants.SESSION_USER, u);
      }
    }
    return invocation.invoke();
  }

}
