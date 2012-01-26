package org.gbif.portal.action.dataset;

import org.gbif.portal.config.PortalModule;

import com.google.inject.Guice;
import com.google.inject.Injector;
import org.junit.Ignore;
import org.junit.Test;

import static org.junit.Assert.assertNotNull;

public class SearchActionTest {
  /**
   * The registry search module does many things at startup, including for example
   * pinging SOLR. This test simply ensures that this process works.
   */
  @Ignore("Need to updater jersey to 1.11 for this to pass - will coordinate this tomorrow")
  public void test() {
    Injector injector = Guice.createInjector(new PortalModule());
    SearchAction sa = injector.getInstance(org.gbif.portal.action.dataset.SearchAction.class);
    assertNotNull(sa);
  }
}
