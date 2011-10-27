package org.gbif.portal.action.species;

import org.gbif.portal.config.PortalModule;

import com.google.inject.Guice;
import com.google.inject.Injector;
import org.junit.Test;

import static org.junit.Assert.assertNotNull;

public class SearchActionTest {

  /**
   * The checklistbanksearch module does many things at startup, including for example
   * pinging SOLR.  This test simply ensures that this process works
   */
  @Test
  public void test() {
    Injector injector = Guice.createInjector(new PortalModule());
    SearchAction sa = injector.getInstance(SearchAction.class);
    assertNotNull(sa);
  }
}
