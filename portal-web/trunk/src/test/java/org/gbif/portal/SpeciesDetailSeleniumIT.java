package org.gbif.portal;

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
    driver.get(getPortalUrl("species/10291613"));
    // assertions
    WebElement infoband = driver.findElement(By.id("infoband"));
    WebElement content = driver.findElement(By.id("content"));

    assertEquals("Expected infoband name wrong", "Sciurus vulgaris Linnaeus, 1758",
      infoband.findElement(By.cssSelector("h1")).getText());

    assertEquals("Expected checklist name wrong", "GBIF Taxonomic Backbone",
      infoband.findElement(By.cssSelector("h3 a")).getText());

    assertEquals("Expected appears in entries",
      content.findElements(By.cssSelector("#appearsin div.left li")).size(), 12);

    assertEquals("Expected distribution entries",
      content.findElements(By.cssSelector("#distribution div.left ul.notes div")).size(), 10);

  }

}
