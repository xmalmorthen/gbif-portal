package org.gbif.portal.action.member;

import org.gbif.api.model.registry.Network;
import org.gbif.api.model.registry.NetworkEntityComponents;
import org.gbif.api.model.registry.Node;
import org.gbif.api.model.registry.Organization;
import org.gbif.api.model.registry.Tag;
import org.gbif.api.service.registry.NetworkService;
import org.gbif.api.service.registry.NodeService;
import org.gbif.api.service.registry.OrganizationService;

import org.junit.Test;

import static org.junit.Assert.assertEquals;
import static org.mockito.Mockito.mock;

public class MemberBaseActionTest {
  public static final Tag PUBLIC_TAG_1 = Tag.builder().predicate("score1").value("10").build();
  public static final Tag PUBLIC_TAG_2 = Tag.builder().predicate("score2").value("20").build();
  public static final Tag PRIVATE_TAG = Tag.builder().predicate("private_score").value("1").namespace("gbif").build();

  @Test
  public void testOrganizationKeywords() {
    MemberBaseAction<Organization> action = new MemberBaseAction<Organization>(mock(OrganizationService.class));
    // populate Organization having some tags
    Organization org = new Organization();
    populateTags(org);
    action.member = org;

    // test: expect 2 keywords, because there are 2 public tags
    assertEquals(2, action.getKeywords().size());
    assertEquals("score1=10", action.getKeywords().get(0));
  }

  @Test
  public void testNodeKeywords() {
    MemberBaseAction<Node> action = new MemberBaseAction<Node>(mock(NodeService.class));
    // populate Node having some tags
    Node node = new Node();
    populateTags(node);
    action.member = node;

    // test: expect 2 keywords, because there are 2 public tags
    assertEquals(2, action.getKeywords().size());
    assertEquals("score2=20", action.getKeywords().get(1));
  }

  @Test
  public void testNetworkKeywords() {
    MemberBaseAction<Network> action = new MemberBaseAction<Network>(mock(NetworkService.class));
    // populate Node having some tags
    Network network = new Network();
    populateTags(network);
    action.member = network;

    // test: expect 2 keywords, because there are 2 public tags
    assertEquals(2, action.getKeywords().size());
  }

  /**
   * To assist adding 2 Tags to class implementing NetworkEntityComponents such as Organization, Node, or Network.
   *
   * @param component NetworkEntityComponents
   *
   * @return NetworkEntityComponents
   */
  private NetworkEntityComponents populateTags(NetworkEntityComponents component) {
    component.getTags().add(PUBLIC_TAG_1);
    component.getTags().add(PUBLIC_TAG_2);
    component.getTags().add(PRIVATE_TAG);
    return component;
  }
}
