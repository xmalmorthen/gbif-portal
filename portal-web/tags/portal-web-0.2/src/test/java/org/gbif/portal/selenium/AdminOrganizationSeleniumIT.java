package org.gbif.portal.selenium;

import org.junit.Test;
import org.openqa.selenium.By;
import org.openqa.selenium.WebElement;

import static org.junit.Assert.assertEquals;

public class AdminOrganizationSeleniumIT extends SeleniumTestBase{

  @Test
  public void testNotAuthorized() throws Exception {
    final String pageUrl = getPortalUrl("admin/organization/add");
    getUrl(pageUrl);

    // assertions
    LOG.debug("Assert content exists...");
    WebElement head = driver.findElement(new By.ByTagName("head"));
    assertEquals("Expected title wrong", "Not Authorised", head.findElement(new By.ByTagName("title")).getText());
  }
}
