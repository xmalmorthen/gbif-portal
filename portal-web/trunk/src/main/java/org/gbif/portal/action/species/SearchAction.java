/*
 * Copyright 2011 Global Biodiversity Information Facility (GBIF) Licensed under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at
 * http://www.apache.org/licenses/LICENSE-2.0 Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,
 * either express or implied. See the License for the specific language governing permissions and limitations under the
 * License.
 */
package org.gbif.portal.action.species;

//import org.gbif.checklistbank.api.model.UsageName;

import org.gbif.checklistbank.ws.client.NubUsageWsClient;
import org.gbif.portal.action.BaseAction;

import java.util.List;
import java.util.Map;
import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class SearchAction extends BaseAction {

  private static final Logger LOG = LoggerFactory.getLogger(SearchAction.class);

  // search
  private String q;
  private List<Map> usages;

  @Inject
  private NameUsageWsClient nameClient;

  @Override
  public String execute() {
    // testing new ws lookup
    //LOG.debug("Testing species lookup of [{}]", q);
    //Name name = nameClient.getName(q);
    //LOG.debug("Got result name with nubid [{}]", name == null ? null : name.getNubId());

    // using static just to make sure all layout is working properly
    //q = "Puma concolor";
    //usages = new ArrayList<Map>();
    //usages.add(new HashMap<String, String>());
    //usages.add(new HashMap<String, String>());

    return SUCCESS;
  }

  public String getQ() {
    return q;
  }

  public void setQ(String q) {
    this.q = q;
  }

  public List<Map> getUsages() {
    return usages;
  }
}
