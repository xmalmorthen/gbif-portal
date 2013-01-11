package org.gbif.portal.action.member;

import org.gbif.api.exception.NotFoundException;
import org.gbif.api.model.registry.Network;
import org.gbif.api.model.registry.Node;
import org.gbif.api.model.registry.Organization;
import org.gbif.api.model.registry.Tag;
import org.gbif.api.model.registry.WritableMember;
import org.gbif.api.service.registry.NetworkEntityService;

import java.util.List;
import java.util.Set;
import java.util.UUID;

import com.google.common.base.Predicate;
import com.google.common.base.Strings;
import com.google.common.collect.Iterables;
import com.google.common.collect.Lists;
import com.google.common.collect.Sets;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class MemberBaseAction<T extends WritableMember> extends org.gbif.portal.action.BaseAction {
  private static final Logger LOG = LoggerFactory.getLogger(MemberBaseAction.class);

  protected UUID id;
  protected T member;
  private NetworkEntityService<T, ?> memberService;
  // displayed in member's infoband underneath title
  private List<String> keywords;

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

  /**
   * Lists a unique set of lower cased, plain string keywords derived from public tags without a namespace.
   * The Tag's toString is used to display the Tag in the GUI.
   *
   * @return a list of unique plain keywords in lower case
   */
  private List<String> getKeywords(T member) {
    Set<String> keywords = Sets.newHashSet();

    Iterable<Tag> publicTags = null;
    if (member instanceof Organization) {
      publicTags = Iterables.filter(((Organization) member).getTags(), isPublic);
    } else if (member instanceof Node) {
      publicTags = Iterables.filter(((Node) member).getTags(), isPublic);
    } else if (member instanceof Network) {
      publicTags = Iterables.filter(((Network) member).getTags(), isPublic);
    }

    // populate keywords from (public) tag's toString
    if (publicTags != null) {
      for (Tag t : publicTags) {
        keywords.add(t.toString());
      }
    }

    return Lists.newArrayList(keywords);
  }

  /**
   * The member's list of lower cased, plain string keywords derived from public tags without a namespace.
   *
   * @return member's list of keywords
   */
  public List<String> getKeywords() {
    return getKeywords(member);
  }

  /**
   * Predicate used to filter member Tags. If a Tag is public (has no namespace) it will return true.
   */
  Predicate<Tag> isPublic = new Predicate<Tag>() {
    @Override public boolean apply(Tag t) {
      return Strings.isNullOrEmpty(t.getNamespace());
    }
  };
}
