package org.gbif.portal.action.network;

import org.gbif.portal.action.member.MemberBaseAction;
import org.gbif.registry.api.model.Network;
import org.gbif.registry.api.service.NetworkService;

public class DetailAction extends MemberBaseAction<Network> {

  private NetworkService networkService;

  public DetailAction(NetworkService networkService) {
    super(networkService);
    this.networkService = networkService;
  }
}
