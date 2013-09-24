package org.gbif.portal.action.country;

import org.gbif.api.service.registry.NodeService;
import org.gbif.api.vocabulary.Country;
import org.gbif.portal.action.BaseAction;
import org.gbif.portal.config.ContinentCountryMap;

import java.util.List;
import java.util.Set;

import com.google.common.collect.ImmutableList;
import com.google.common.collect.Lists;
import com.google.common.collect.Ordering;
import com.google.common.collect.Sets;
import com.google.inject.Inject;

public class HomeAction extends BaseAction {

  /**
   * Ensure we are ordered
   */
  private static List<Country> countries = ImmutableList.copyOf(Ordering.usingToString().sortedCopy(
    Lists.newArrayList(Country.values())));


  private Set<Country> activeNodes;
  @Inject
  private NodeService nodeService;
  @Inject
  private ContinentCountryMap continentMap;

  @Override
  public String execute() throws Exception {
    activeNodes = Sets.newHashSet(nodeService.listActiveCountries());
    return SUCCESS;
  }

  public Set<Country> getActiveNodes() {
    return activeNodes;
  }

  public List<Country> getCountries() {
    return countries;
  }
}
