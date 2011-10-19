/*
 * Copyright 2011 Global Biodiversity Information Facility (GBIF) Licensed under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at
 * http://www.apache.org/licenses/LICENSE-2.0 Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,
 * either express or implied. See the License for the specific language governing permissions and limitations under the
 * License.
 */
package org.gbif.portal.config;

import com.google.inject.Guice;
import com.google.inject.Injector;
import com.google.inject.Singleton;
import com.google.inject.servlet.GuiceServletContextListener;
import com.google.inject.servlet.ServletModule;
import com.google.inject.struts2.Struts2GuicePluginModule;
import org.apache.struts2.dispatcher.ng.filter.StrutsExecuteFilter;
import org.apache.struts2.dispatcher.ng.filter.StrutsPrepareFilter;
import org.apache.struts2.sitemesh.FreemarkerPageFilter;

/**
 * Setting up filter and servlets in addition to the ones in web.xml.
 */
public class PortalListener extends GuiceServletContextListener {

  private final ServletModule sm = new ServletModule() {
    @Override
    protected void configureServlets() {
      bind(StrutsPrepareFilter.class).in(Singleton.class);
      bind(FreemarkerPageFilter.class).in(Singleton.class);
      bind(StrutsExecuteFilter.class).in(Singleton.class);
      filter("/*").through(StrutsPrepareFilter.class);
      filter("/*").through(FreemarkerPageFilter.class);
      filter("/*").through(StrutsExecuteFilter.class);
    }
  };


  @Override
  public Injector getInjector() {
    return Guice.createInjector(new Struts2GuicePluginModule(), sm, new PortalModule());
  }
}
