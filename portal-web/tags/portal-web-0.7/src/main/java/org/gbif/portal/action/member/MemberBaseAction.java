package org.gbif.portal.action.member;

import org.gbif.api.model.registry.NetworkEntity;
import org.gbif.api.model.registry.Tag;
import org.gbif.api.model.registry.Taggable;
import org.gbif.api.service.registry.NetworkEntityService;
import org.gbif.portal.exception.NotFoundException;

import java.util.List;
import java.util.Set;
import java.util.UUID;

import com.google.common.base.Strings;
import com.google.common.collect.Lists;
import com.google.common.collect.Sets;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class MemberBaseAction<T extends NetworkEntity & Taggable> extends org.gbif.portal.action.BaseAction {

  private static final Logger LOG = LoggerFactory.getLogger(MemberBaseAction.class);

  protected UUID id;
  protected T member;
  private final NetworkEntityService<T> memberService;
  private final MemberType type;
  private List<String> keywords;

  protected MemberBaseAction(MemberType type, NetworkEntityService<T> memberService) {
    this.memberService = memberService;
    this.type = type;
  }

  @Override
  public String execute() throws Exception {
    loadDetail();
    return SUCCESS;
  }

  public UUID getId() {
    return id;
  }

  /**
   * The member's list of lower cased, plain string keywords derived from public tags without a namespace.
   * This method loads keywords lazily.
   * @return member's list of keywords
   */
  public List<String> getKeywords() {
    if (keywords == null) {
      // lazy load keywords
      Set<String> kws = Sets.newTreeSet();
      for (Tag t : member.getTags()) {
        if (!Strings.isNullOrEmpty(t.getValue())) {
          kws.add(t.getValue().trim().toLowerCase());
        }
      }
      keywords = Lists.newArrayList(kws);
    }
    return keywords;
  }

  public T getMember() {
    return member;
  }

  public MemberType getType() {
    return type;
  }

  public void setId(String id) {
    try {
      this.id = UUID.fromString(id);
    } catch (IllegalArgumentException e) {
      this.id = null;
    }
  }

  protected void loadDetail() {
    LOG.debug("Getting detail for member key {}", id);
    member = memberService.get(id);
    if (member == null) {
      throw new NotFoundException("No member found with key " + id);
    }
  }

}
