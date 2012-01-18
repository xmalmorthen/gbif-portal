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
    // Checklist: "Orthoptera Species File"
    da.setId("af66d4cf-0fd2-434b-9334-9806a5efa6f7");
    String result = da.execute();
    assertEquals("detail", result);
    // Dataset title = "OCNMS: Physical Oceanography: moored temperature data: Makah Bay, Washington, USA (MB015)"
    da.setId("7879e569-4a13-4643-b833-d1a564675b86:urn:lsid:knb.ecoinformatics.org:MB015X_015MTBD015R00_20040517:50");
    result = da.execute();
    assertEquals("detail", result);
    // External - escaped
    // Dataset title = "Soil Calcium"
    da.setId("7879e569-4a13-4643-b833-d1a564675b86:urn%3Alsid%3Aknb.ecoinformatics.org%3Aknb-lter-cdr%3A8133");
    result = da.execute();
    assertEquals("detail", result);
  }
}
