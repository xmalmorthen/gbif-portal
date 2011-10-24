package org.gbif.portal;

import java.util.concurrent.TimeUnit;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.htmlunit.HtmlUnitDriver;

import static org.junit.Assert.assertEquals;

public class SpeciesSeleniumIT {

  private WebDriver driver;
  private final String baseUrl;

  public SpeciesSeleniumIT() {
    baseUrl = "http://localhost:" + System.getProperty("jetty.port", "8080");
  }

  @Before
  public void setUp() {
    driver = new HtmlUnitDriver();
    driver.manage().timeouts().implicitlyWait(30, TimeUnit.SECONDS);
  }

  /**
   * This test does a primitive check if species with id 1 is Animalia.
   */
  @Test
  public void testNubAnimaliaSpecies() {
    driver.get(baseUrl + "/species/1");
    String targetName = driver.findElement(By.xpath("//div[@id='infoband']/div/h1")).getText();
    assertEquals("Animalia", targetName);
  }

  @After
  public void tearDown() {
    if (driver != null) {
      driver.quit();
    }
  }
}
