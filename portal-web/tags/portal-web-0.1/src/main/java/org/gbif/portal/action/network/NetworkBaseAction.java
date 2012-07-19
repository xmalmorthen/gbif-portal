package org.gbif.portal.action.network;

import org.gbif.portal.action.member.MemberBaseAction;
import org.gbif.registry.api.model.Network;
import org.gbif.registry.api.service.NetworkService;

import java.util.UUID;

import com.google.inject.Inject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class NetworkBaseAction extends MemberBaseAction<Network> {
  protected static final Logger LOG = LoggerFactory.getLogger(NetworkBaseAction.class);

  @Inject
  protected NetworkService networkService;

  public NetworkBaseAction() {
    super(Network.class);
  }

  @Override
  protected Network loadMember(UUID id) {
    return networkService.get(id);
  }
}
