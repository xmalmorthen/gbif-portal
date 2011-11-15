package org.gbif.portal;

import java.util.LinkedList;

import org.junit.Test;
import org.openqa.selenium.By;
import org.openqa.selenium.WebElement;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNull;

public class SpeciesSearchSeleniumIT extends SeleniumTestBase {

  @Test
  public void testIdPattern() {
    assertEquals((Integer) 2685464, parseIdLink("http://staging.gbif.org:8080/portal-web-dynamic/species/2685464"));
    assertEquals((Integer) 1, parseIdLink("http://localhost:8080/species/1"));
    assertNull(parseIdLink("http://localhost:8080/species/search"));
  }

  /**
   * This test uses the dataset page to search for all datasets, clicks on the second one and verifies that
   * the details page for the selected dataset is shown.
   */
  @Test
  public void testVernacularNameSearch() {
    assertNameSearch("Abies pinsapo ", true, 16, 2685464);
    assertNameSearch("Spanische TANNE", true, 1, 2685464);
    assertNameSearch("španjolska jela", true, 1, 2685464);
  }

  /**
   * @param name the q name to search for
   * @param searchNub true if only the nub is being searched, false to search all
   * @param expectedUsageId the list of expected name usage ids in the result, starting with first entry
   */
  private void assertNameSearch(String name, boolean searchNub, Integer expectedNumResults, int ... expectedUsageId){
    LOG.debug("Asserting name search '{}'", name);
    driver.get(getPortalUrl("species"));
    // Find input form and enter seach text
    WebElement input = driver.findElement(By.id("q"));
    input.sendKeys(name);
    LOG.debug("SEARCH FORM VALUE: {}", input.getAttribute("value"));
    driver.findElement(By.id("submitSearch")).click();

    // main content div on page
    WebElement content = driver.findElement(By.id("content"));

    // assert number of hits
    if (expectedNumResults != null){
      assertEquals("Expected number of shown search results wrong", expectedNumResults, (Integer) content.findElements(By.cssSelector("div.result")).size());
    }

    // assert exact results
    LinkedList<WebElement> links = new LinkedList(content.findElements(By.cssSelector("div.result h2 a")));
    LOG.debug("{} search results found", links.size());
    for (int uid : expectedUsageId){
      int speciesKey = parseIdLink(links.remove().getAttribute("href"));
      assertEquals("Expected result usage id different", speciesKey, uid);
    }
  }

}
