package org.gbif.portal.action.member;

import org.gbif.api.exception.NotFoundException;
import org.gbif.api.model.registry.WritableMember;
import org.gbif.api.service.registry.NetworkEntityService;

import java.util.UUID;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class MemberBaseAction<T extends WritableMember> extends org.gbif.portal.action.BaseAction {
  private static final Logger LOG = LoggerFactory.getLogger(MemberBaseAction.class);

  protected UUID id;
  protected T member;
  private NetworkEntityService<T, ?> memberService;

  protected MemberBaseAction(NetworkEntityService<T, ?> memberService) {
    this.memberService = memberService;
  }

  @Override
  public String execute() throws Exception {
    loadDetail();
    return SUCCESS;
  }

  protected void loadDetail() {
    if (id != null) {
      LOG.debug("Getting detail for member key {}", id);
      // check organisation
      member = memberService.get(id);
      if (member == null) {
        LOG.warn("No member found with key {}", id);
        throw new NotFoundException();
      }

    }
  }

  public T getMember() {
    return member;
  }

  public UUID getId() {
    return id;
  }

  public void setId(String id) {
    try {
      this.id = UUID.fromString(id);
    } catch (IllegalArgumentException e) {
      this.id = null;
    }
  }
}
