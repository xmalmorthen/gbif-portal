package org.gbif.portal.action.member;

import org.gbif.api.search.SearchResponse;
import org.gbif.portal.action.BaseSearchAction;
import org.gbif.registry.api.model.NetworkEntity;
import org.gbif.registry.api.service.OrganizationService;

import java.util.Map;

import com.google.common.collect.Maps;
import com.google.inject.Inject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class SearchAction extends BaseSearchAction<NetworkEntity> {

  private static final Logger LOG = LoggerFactory.getLogger(SearchAction.class);

  @Inject
  private OrganizationService orgService;

  @Override
  public String execute() {
    LOG.debug("Trying member search for q [{}]", q);

    // fake a search by using list...
    //TODO: implement real search
    searchResponse = new SearchResponse<NetworkEntity>(orgService.list(searchRequest));

    return SUCCESS;
  }

  public Map<?,?> getFacets(){
    return Maps.newHashMap();
  }
}
