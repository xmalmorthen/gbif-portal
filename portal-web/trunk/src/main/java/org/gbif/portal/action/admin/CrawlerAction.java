package org.gbif.portal.action.admin;

import org.gbif.api.paging.PagingResponse;
import org.gbif.portal.action.BaseAction;
import org.gbif.registry.api.model.Node;
import org.gbif.registry.api.model.vocabulary.EndpointType;
import org.gbif.registry.api.service.NodeService;

import java.util.List;
import java.util.Set;

import com.google.inject.Inject;

public class CrawlerAction extends BaseAction {

  @Inject
  protected NodeService nodeWsClient;

  @Override
  public String execute() {
    return SUCCESS;
  }

  public List<Node> getNodes() {
    // TODO: This returns 20 by default, should process all nodes to return the complete list.
    PagingResponse<Node> response = nodeWsClient.list(null);

    if (response != null) {
      return response.getResults();
    }
    return null;
  }

  public Set<EndpointType> getOccurrenceEndpoints() {
    return EndpointType.OCCURRENCE_CODES;
  }
}
