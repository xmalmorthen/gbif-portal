package org.gbif.portal.action.node;

import org.gbif.portal.action.member.MemberBaseAction;
import org.gbif.registry.api.model.Node;
import org.gbif.registry.api.service.NodeService;

import java.util.UUID;

import com.google.inject.Inject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class NodeBaseAction extends MemberBaseAction<Node> {
  protected static final Logger LOG = LoggerFactory.getLogger(NodeBaseAction.class);

  @Inject
  protected NodeService nodeService;

  public NodeBaseAction() {
    super(Node.class);
  }

  @Override
  protected Node loadMember(UUID id) {
    return nodeService.get(id);
  }
}
