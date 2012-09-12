package org.gbif.portal.action.network;

import org.gbif.api.model.registry.Network;
import org.gbif.api.service.registry.NetworkService;
import org.gbif.portal.action.member.MemberBaseAction;

public class DetailAction extends MemberBaseAction<Network> {

  private NetworkService networkService;

  public DetailAction(NetworkService networkService) {
    super(networkService);
    this.networkService = networkService;
  }
}
