package org.gbif.portal.action.country;

import org.gbif.api.model.common.paging.PagingRequest;
import org.gbif.api.model.common.paging.PagingResponse;
import org.gbif.api.model.registry2.Node;
import org.gbif.api.service.registry2.NodeService;
import org.gbif.api.vocabulary.Country;
import org.gbif.portal.action.BaseAction;

import java.util.List;
import java.util.Set;

import com.google.common.collect.Lists;
import com.google.common.collect.Sets;
import com.google.inject.Inject;

public class HomeAction extends BaseAction {

  private static List<Country> countries = Lists.newArrayList(Country.values());
  private Set<Country> nodes = Sets.newHashSet();
  @Inject
  private NodeService nodeService;

  @Override
  public String execute() throws Exception {
    PagingResponse<Node> resp = nodeService.list(new PagingRequest(0, 250));
    for (Node n : resp.getResults()) {
      if (n.getCountry() != null) {
        nodes.add(n.getCountry());
      }
    }
    return SUCCESS;
  }

  public static List<Country> getCountries() {
    return countries;
  }

  public Set<Country> getNodes() {
    return nodes;
  }
}
