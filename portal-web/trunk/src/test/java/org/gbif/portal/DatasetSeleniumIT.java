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

public class DatasetSeleniumIT {

  private WebDriver driver;
  private final String baseUrl;

  public DatasetSeleniumIT() {
    baseUrl = "http://localhost:" + System.getProperty("jetty.port", "8080");
  }

  @Before
  public void setUp() throws Exception {
    driver = new HtmlUnitDriver();
    driver.manage().timeouts().implicitlyWait(30, TimeUnit.SECONDS);
  }

  /**
   * This test uses the dataset page to search for all datasets, clicks on the second one and verifies that
   * the details page for the selected dataset is shown.
   */
  @Test
  public void testSearchForAnyDataset() throws Exception {
    driver.get(baseUrl);
    driver.findElement(By.linkText("Datasets")).click();
    driver.findElement(By.cssSelector("button.search_button")).click();
    WebElement element = driver.findElement(By.xpath("//div[@class='result' and position() = 2]/h2/a"));
    String sourceName = element.getText();
    element.click();
    String targetName = driver.findElement(By.xpath("//div[@id='infoband']/div/h1")).getText();
    assertEquals("Link target and dataset name must be the same", sourceName, targetName);
  }

  @After
  public void tearDown() throws Exception {
    if (driver != null) {
      driver.quit();
    }
  }
}
