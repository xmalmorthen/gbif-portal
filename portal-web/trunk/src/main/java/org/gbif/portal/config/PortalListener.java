/*
 * Copyright 2011 Global Biodiversity Information Facility (GBIF) Licensed under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at
 * http://www.apache.org/licenses/LICENSE-2.0 Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,
 * either express or implied. See the License for the specific language governing permissions and limitations under the
 * License.
 */
package org.gbif.portal.config;

import java.io.IOException;
import java.net.URI;
import java.util.Map;
import java.util.Properties;

import com.google.common.collect.Maps;
import com.google.inject.Guice;
import com.google.inject.Injector;
import com.google.inject.Singleton;
import com.google.inject.servlet.GuiceServletContextListener;
import com.google.inject.servlet.ServletModule;
import com.google.inject.struts2.Struts2GuicePluginModule;
import org.apache.bval.guice.ValidationModule;
import org.apache.struts2.dispatcher.ng.filter.StrutsExecuteFilter;
import org.apache.struts2.dispatcher.ng.filter.StrutsPrepareFilter;
import org.apache.struts2.sitemesh.FreemarkerPageFilter;
import org.jasig.cas.client.authentication.AuthenticationFilter;
import org.jasig.cas.client.session.SingleSignOutFilter;
import org.jasig.cas.client.util.HttpServletRequestWrapperFilter;
import org.jasig.cas.client.validation.Cas10TicketValidationFilter;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Setting up filter and servlets in addition to the ones in web.xml.
 */
public class PortalListener extends GuiceServletContextListener {
  private static Logger LOG = LoggerFactory.getLogger(PortalListener.class);

  private final ServletModule sm = new ServletModule() {

    @Override
    protected void configureServlets() {

      String serverName = "http://localhost:" + System.getProperty("jetty.port", "8080");
      // try to get servername from properties
      try {
        Properties properties = new Properties();
        properties.load(this.getClass().getResourceAsStream("/application.properties"));
        String baseurl = properties.getProperty("baseurl");
        // only use if its a real URL
        URI uri = URI.create(baseurl);
        if (uri != null){
          serverName = uri.getScheme()+uri.getHost()+":"+uri.getPort();
        }
      } catch (IOException e) {
      }
      LOG.info("Configuring CAS filters with portal server name {}", serverName);

      // CAS filter parameters
      Map<String, String> params = Maps.newHashMap();
      params.put("serverName", "http://localhost:8080");
      params.put("casServerUrlPrefix", "https://cas.gbif.org");
      params.put("casServerLoginUrl", "https://cas.gbif.org/login");
      params.put("gateway", "true");
      params.put("redirectAfterValidation", "true");
      params.put("tolerance", "5000");

      // CAS
      bind(SingleSignOutFilter.class).in(Singleton.class);
      bind(AuthenticationFilter.class).in(Singleton.class);
      bind(Cas10TicketValidationFilter.class).in(Singleton.class);
      bind(HttpServletRequestWrapperFilter.class).in(Singleton.class);
      // Struts2
      bind(StrutsPrepareFilter.class).in(Singleton.class);
      bind(FreemarkerPageFilter.class).in(Singleton.class);
      bind(StrutsExecuteFilter.class).in(Singleton.class);

      // CAS
      filter("/*").through(SingleSignOutFilter.class);
      filter("/*").through(AuthenticationFilter.class, params);
      filter("/*").through(Cas10TicketValidationFilter.class, params);
      filter("/*").through(HttpServletRequestWrapperFilter.class);
      // Struts2
      filter("/*").through(StrutsPrepareFilter.class);
      filter("/*").through(FreemarkerPageFilter.class);
      filter("/*").through(StrutsExecuteFilter.class);
    }
  };


  @Override
  public Injector getInjector() {
    return Guice.createInjector(new Struts2GuicePluginModule(), sm, new PortalModule(), new ValidationModule());
  }
}
