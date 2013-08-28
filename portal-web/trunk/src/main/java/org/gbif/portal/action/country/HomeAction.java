package org.gbif.portal.action.country;

import org.gbif.api.service.registry.NodeService;
import org.gbif.api.vocabulary.Country;
import org.gbif.portal.action.BaseAction;

import java.util.List;
import java.util.Set;

import com.google.common.collect.Lists;
import com.google.common.collect.Sets;
import com.google.inject.Inject;

public class HomeAction extends BaseAction {

  private static List<Country> countries = Lists.newArrayList(Country.values());
  private Set<Country> activeNodes;
  @Inject
  private NodeService nodeService;

  public static List<Country> getCountries() {
    return countries;
  }

  @Override
  public String execute() throws Exception {
    activeNodes = Sets.newHashSet(nodeService.listNodeCountries());
    return SUCCESS;
  }

  public Set<Country> getActiveNodes() {
    return activeNodes;
  }
}
