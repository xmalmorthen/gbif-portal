package org.gbif.portal.selenium;

import org.junit.Test;
import org.openqa.selenium.By;
import org.openqa.selenium.WebElement;

import static org.junit.Assert.assertEquals;

/**
 * Tests a single species page.
 */
public class SpeciesDetailSeleniumIT extends SeleniumTestBase {

  @Test
  public void testSciurusVulgaris() {
    final String pageUrl = getPortalUrl("species/5219668");
    getUrl(pageUrl);

    // assertions
    LOG.debug("Assert content exists...");
    WebElement infoband = driver.findElement(By.id("infoband"));
    WebElement content = driver.findElement(By.id("content"));
    WebElement map = driver.findElement(By.className("map"));

    assertEquals("Expected infoband name wrong", "Sciurus vulgaris Linnaeus, 1758",
      infoband.findElement(By.cssSelector("h1")).getText());

    assertEquals("Expected checklist name wrong", "GBIF Backbone Taxonomy", infoband
      .findElement(By.cssSelector("h3 a")).getText());

    // its 6 checklists & 6 occurrences plus 2 see more links
    assertEquals("Expected appears in entries", 14, content.findElements(By.cssSelector("#appearsin div.col li"))
      .size());

    // this species id should bring back 7 distributions
    assertEquals("Expected distribution entries", 8, map.findElements(By.cssSelector(".right li")).size());

  }

}
