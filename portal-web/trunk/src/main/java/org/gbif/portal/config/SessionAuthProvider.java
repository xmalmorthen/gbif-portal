package org.gbif.portal.config;

import org.gbif.ws.filter.HttpGbifAuthFilter;

import java.security.Principal;
import javax.servlet.http.HttpSession;

import com.google.inject.Inject;
import com.google.inject.Provider;
import com.google.inject.Singleton;
import com.google.inject.name.Named;
import com.sun.jersey.api.client.filter.ClientFilter;

@Singleton
public class SessionAuthProvider implements Provider<ClientFilter>{
  private static final String SESSION_USER = "current_user";
  private final Provider<HttpSession> sessionProvider;
  private final String applicationKey;

  @Inject
  public SessionAuthProvider(Provider<HttpSession> sessionProvider, @Named("application.key") String applicationKey) {
    this.sessionProvider = sessionProvider;
    this.applicationKey = applicationKey;
  }

  @Override
  public ClientFilter get() {
    HttpSession session = sessionProvider.get();
    if (session != null){
      Principal user = (Principal) session.getAttribute(SESSION_USER);
      if (user != null){
        return new HttpGbifAuthFilter(applicationKey, user.getName());
      }
    }
    return null;
  }
}
