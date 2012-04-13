package org.gbif.portal.action.member;

import org.gbif.portal.action.NotFoundException;
import org.gbif.registry.api.model.WritableMember;

import java.util.UUID;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public abstract class MemberBaseAction<T extends WritableMember> extends org.gbif.portal.action.BaseAction {
  private static final Logger LOG = LoggerFactory.getLogger(MemberBaseAction.class);

  protected UUID id;
  private T member;
  protected final Class<T> clazz;

  public MemberBaseAction(Class<T> clazz) {
    this.clazz = clazz;
  }

  @Override
  public String execute() {
    if (id != null) {
      LOG.debug("Getting detail for member id [{}]", id);
      // check organisation
      member = loadMember(id);

      if (member != null){
        return SUCCESS;
      }
    }
    throw new NotFoundException();
  }

  abstract protected T loadMember(UUID id);

  public T getMember() {
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

  public String getMemberType() {
    return clazz.getSimpleName();
  }

  /**
   * @param member the member to set.
   */
  public void setMember(T member) {
    this.member = member;
  }
}
