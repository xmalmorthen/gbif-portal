package org.gbif.portal.action.dataset;

import org.gbif.portal.config.PortalModule;

import com.google.inject.Guice;
import com.google.inject.Injector;
import org.junit.Test;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;

public class DetailActionTest {
  @Test
  public void test() {
    Injector injector = Guice.createInjector(new PortalModule());
    DetailAction da = injector.getInstance(org.gbif.portal.action.dataset.DetailAction.class);
    assertNotNull(da);
    // "Additional Common Names for the Catalogue of Life"
    da.setId("f8ef0556-2a27-11e1-bb68-483019ec54e1");
    String result = da.execute();
    assertEquals("detail_checklist", result);
  }
}
