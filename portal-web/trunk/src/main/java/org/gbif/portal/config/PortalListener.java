/*
 * Copyright 2011 Global Biodiversity Information Facility (GBIF) Licensed under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at
 * http://www.apache.org/licenses/LICENSE-2.0 Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,
 * either express or implied. See the License for the specific language governing permissions and limitations under the
 * License.
 */
package org.gbif.portal.config;

import org.gbif.checklistbank.service.mybatis.guice.ChecklistBankServiceMyBatisModule;
import org.gbif.occurrencestore.ws.client.guice.OccurrenceWsClientModule;
import org.gbif.registry.ws.client.guice.RegistryWsClientModule;

import java.io.IOException;

import com.google.inject.Guice;
import com.google.inject.Injector;
import com.google.inject.Module;
import com.google.inject.Singleton;
import com.google.inject.servlet.GuiceServletContextListener;
import com.google.inject.servlet.ServletModule;
import com.google.inject.struts2.Struts2GuicePluginModule;
import com.opensymphony.sitemesh.webapp.SiteMeshFilter;
import org.apache.struts2.dispatcher.ng.filter.StrutsExecuteFilter;
import org.apache.struts2.dispatcher.ng.filter.StrutsPrepareFilter;

/**
 * Setting up filter and servlets in addition to the ones in web.xml.
 */
public class PortalListener extends GuiceServletContextListener {

  @Override
  public Injector getInjector() {
    // new ChecklistBankWsClientModule()
    Module clbApi = null;
    try {
      clbApi = new ChecklistBankServiceMyBatisModule("clbmybatis.properties");
    } catch (IOException e) {
      throw new IllegalStateException("Checklist bank api guice module could not be loaded");
    }
    return Guice
      .createInjector(new PortalModule(), clbApi, new RegistryWsClientModule(), new OccurrenceWsClientModule(),
        new Struts2GuicePluginModule(), new ServletModule() {

        @Override
        protected void configureServlets() {
          bind(StrutsPrepareFilter.class).in(Singleton.class);
          filter("/*").through(StrutsPrepareFilter.class);
          bind(SiteMeshFilter.class).in(Singleton.class);
          filter("/*").through(SiteMeshFilter.class);
          bind(StrutsExecuteFilter.class).in(Singleton.class);
          filter("/*").through(StrutsExecuteFilter.class);
        }
      });
  }
}
