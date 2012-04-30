package org.gbif.portal.config;

import org.gbif.ws.client.filter.HttpGbifAuthFilter;

import java.util.Properties;

import com.google.inject.Inject;
import com.google.inject.PrivateModule;
import com.google.inject.Provides;
import com.google.inject.Scopes;
import com.google.inject.Singleton;
import com.google.inject.name.Names;
import com.sun.jersey.api.client.filter.ClientFilter;

public class PrivatePortalModule extends PrivateModule{
  private final Properties properties;

  public PrivatePortalModule(Properties properties) {
    this.properties = properties;
  }

  @Override
  protected void configure() {
    Names.bindProperties(binder(), properties);

    bind(SessionAuthProvider.class).in(Scopes.SINGLETON);

    expose(ClientFilter.class);
  }

  @Provides
  @Singleton
  @Inject
  public ClientFilter provideSessionAuthFilter(SessionAuthProvider sessionAuthProvider) {
    return new HttpGbifAuthFilter("portal", sessionAuthProvider);
  }
}
