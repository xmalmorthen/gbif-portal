package org.gbif.portal.action.participation;

import org.gbif.api.model.common.paging.PagingRequest;
import org.gbif.api.model.common.paging.PagingResponse;
import org.gbif.api.model.registry.Node;
import org.gbif.api.service.registry.NodeService;
import org.gbif.api.vocabulary.NodeType;
import org.gbif.api.vocabulary.ParticipationStatus;
import org.gbif.portal.action.BaseAction;

import java.util.List;
import javax.annotation.Nullable;

import com.google.common.base.Function;
import com.google.common.collect.FluentIterable;
import com.google.common.collect.Lists;
import com.google.common.collect.Ordering;
import com.google.inject.Inject;

/**
 * Landing page for non country nodes.
 */
public class ListAction extends BaseAction {

  private List<Node> voting = Lists.newArrayList();
  private List<Node> associate = Lists.newArrayList();
  private List<Node> other = Lists.newArrayList();

  @Inject
  private NodeService nodeService;

  @Override
  public String execute() throws Exception {
    PagingResponse<Node> resp = nodeService.list(new PagingRequest(0, 1000));
    List<Node> sorted = FluentIterable.from(resp.getResults())
        // sort alphabetically
        .toSortedList(Ordering.natural().onResultOf(new Function<Node, String>() {
          @Nullable
          @Override
          public String apply(@Nullable Node n) {
            return n == null ? null : n.getTitle();
          }
    }));
    for (Node n: sorted) {
      if (NodeType.COUNTRY == n.getType()) {
        if (ParticipationStatus.VOTING == n.getParticipationStatus()) {
          voting.add(n);
        } else if (ParticipationStatus.ASSOCIATE == n.getParticipationStatus()) {
          associate.add(n);
        }
      } else {
        other.add(n);
      }
    }

    return SUCCESS;
  }

  public List<Node> getVoting() {
    return voting;
  }

  public List<Node> getAssociate() {
    return associate;
  }

  public List<Node> getOther() {
    return other;
  }
}
