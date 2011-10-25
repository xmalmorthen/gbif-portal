package org.gbif.portal;

import org.junit.Test;
import org.openqa.selenium.By;

import static org.junit.Assert.assertEquals;

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

}
