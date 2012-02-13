package org.gbif.portal.action.member;

import org.gbif.portal.action.BaseAction;
import org.gbif.portal.action.NotFoundException;
import org.gbif.registry.api.model.NetworkEntity;
import org.gbif.registry.api.service.NodeService;
import org.gbif.registry.api.service.OrganizationService;

import java.util.UUID;

import com.google.inject.Inject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class DetailAction extends BaseAction {
  private static final Logger LOG = LoggerFactory.getLogger(DetailAction.class);

  @Inject
  protected OrganizationService organizationService;
  @Inject
  protected NodeService nodeService;

  private UUID id;
  private NetworkEntity member;

  @Override
  public String execute() {
    if (id != null) {
      LOG.debug("Getting detail for member id [{}]", id);
      // check organisation
      member = organizationService.get(id);
      if (member == null){
        member = nodeService.get(id);
      }

      if (member == null){
        throw new NotFoundException();
      }
      return SUCCESS;
    }
    throw new NotFoundException();
  }

  public NetworkEntity getMember() {
    return member;
  }

  public UUID getId() {
    return id;
  }

  public void setId(String id) {
    try {
      this.id = UUID.fromString(id);
    } catch (Exception e) {
      this.id = null;
    }
  }
}
