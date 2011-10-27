package org.gbif.portal;

import org.junit.Test;
import org.openqa.selenium.By;
import org.openqa.selenium.WebElement;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;

public class SpeciesSeleniumIT extends SeleniumTestBase {

  /**
   * This test does a primitive check if species with id 1 is Animalia.
   */
  @Test
  public void testNubAnimaliaSpecies() {
    getDriver().get(getBaseUrl() + "/species/1");
    String targetName = getDriver().findElement(By.xpath("//div[@id='infoband']/div/h1")).getText();
    assertEquals("Animalia", targetName);
  }

  @Test
  public void testSpeciesSearch() {
    assertHasSearchResults("albies");
    assertHasSearchResults("puma");
    assertHasSearchResults("puma concolor");
    assertHasNoSearchResults("fooooobaetrniedtruinatedi2lc3c^e/eiu");
  }

  private void assertHasNoSearchResults(String search) {
    // TODO: Can't add yet because search doesn't work and I don't know yet what'll be returned on no result
  }

  /**
   * Searches for a string on the species search page and asserts that there are some results for this by looking for
   * the string 'results for "searchstring"'.
   */
  private void assertHasSearchResults(String search) {
    getDriver().get(getBaseUrl() + "/species/");
    WebElement element = getDriver().findElement(By.name("q"));
    element.sendKeys(search);
    getDriver().findElement(By.xpath("/html/body/div/article/div/form/button")).click();
    String targetName = getDriver().findElement(By.xpath("/html/body/div/form/article/div/div/div/h2")).getText();
    assertTrue(targetName.contains("results for \"" + search + '\"'));
  }

}
