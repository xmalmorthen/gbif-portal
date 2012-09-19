package org.gbif.portal.action;

import org.junit.Test;

import static org.junit.Assert.assertEquals;

public class BaseSearchActionTest {

  @Test
  public void testGetHighlightedText() throws Exception {
    assertEquals("hallo markus", BaseSearchAction.getHighlightedText("hallo markus", 20));
    assertEquals("hallo markus, hal...", BaseSearchAction.getHighlightedText("hallo markus, hallo pia, hallo carla", 20));
    final String text = "Strings are constant; their values cannot be changed after they are created. String <em class=\"gbifHl\">buffers</em> support mutable strings. Because String objects are immutable they can be shared.";
    assertEquals("<em class=\"gbifHl\">buffers</em>", BaseSearchAction.getHighlightedText(text, 10));
    assertEquals("<em class=\"gbifHl\">buffers</em>", BaseSearchAction.getHighlightedText(text, 30));
    assertEquals("...created. String <em class=\"gbifHl\">buffers</em> support mutable strings. B...", BaseSearchAction.getHighlightedText(text, 80));
    assertEquals(text, BaseSearchAction.getHighlightedText(text, 200));

    final String text2 = "Strings are <em class=\"gbifHl\">constant</em>; their values cannot be changed after they are created. String buffers support mutable strings. Because String objects are immutable they can be shared.";
    assertEquals("<em class=\"gbifHl\">constant</em>", BaseSearchAction.getHighlightedText(text2, 10));
    assertEquals("Strings are <em class=\"gbifHl\">constant</em>; their values cannot be changed ...", BaseSearchAction.getHighlightedText(text2, 80));
  }
}
