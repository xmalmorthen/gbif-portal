package org.gbif.portal.action.admin;

import org.gbif.portal.action.AdminBaseAction;
import org.gbif.registry.api.model.Network;
import org.gbif.registry.api.service.NetworkService;

import java.util.UUID;

import javax.validation.Valid;

public class NetworkAction extends AdminBaseAction<NetworkService, Network> {

  @Valid
  Network member;

  /**
   * @return the network.
   */

  public Network getMember() {
    if (member == null) {
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

  public String editNetwork() {
    // TODO: add logic required to edit the network fields (calling WS client)
    return SUCCESS;
  }

  public String addNetwork() {
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
