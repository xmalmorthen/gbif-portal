package org.gbif.portal;

import java.util.concurrent.TimeUnit;

import org.junit.After;
import org.junit.Before;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.htmlunit.HtmlUnitDriver;

/**
 * Base class for Selenium test providing {@code Before} and {@code After} methods that set up a {@link HtmlUnitDriver}
 * and tears it down again.
 */
public abstract class SeleniumTestBase {

  private WebDriver driver;
  private final String baseUrl;
  private static final long DEFAULT_TIMEOUT = 30;

  protected SeleniumTestBase() {
    baseUrl = "http://localhost:" + System.getProperty("jetty.port", "8080");
  }

  @Before
  public void setUp() {
    driver = new HtmlUnitDriver();
    driver.manage().timeouts().implicitlyWait(DEFAULT_TIMEOUT, TimeUnit.SECONDS);
  }

  @After
  public void tearDown() {
    if (driver != null) {
      driver.quit();
    }
  }

  protected WebDriver getDriver() {
    return driver;
  }

  protected String getBaseUrl() {
    return baseUrl;
  }
}
