package org.gbif.portal.action.network;

import org.gbif.api.model.registry.Network;
import org.gbif.api.service.registry.NetworkService;
import org.gbif.portal.action.AdminBaseAction;

import java.util.UUID;

import javax.validation.Valid;

public class AdminAction extends AdminBaseAction<NetworkService, Network> {

  @Valid
  Network member;

  /**
   * @return the network.
   */

  public Network getMember() {
    if (id != null && member == null) {
      member = loadMember(id);
    }
    return member;
  }

  protected Network loadMember(UUID id) {
    return wsClient.get(id);
  }

  /**
   * @param organization the network to set.
   */
  public void setMember(Network member) {
    this.member = member;
  }

  public String editEntity() {
    // TODO: add logic required to edit the network fields (calling WS client)
    return SUCCESS;
  }

  public String addEntity() {
    // first persist the WritableNetwork entity
    // UUID networkKey = wsClient.create(member);
    // createMembers(networkKey);
    return SUCCESS;
  }

  public Network getSessionNetwork() {
    return (Network) session.get("network");
  }

  @Override
  public Network getEntity() {
    return getMember();
  }
}
