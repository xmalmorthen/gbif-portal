package org.gbif.portal.action.dataset;

import org.gbif.portal.action.ActionTestUtil;

import com.google.inject.Injector;
import com.opensymphony.xwork2.Action;
import org.junit.Test;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;

public class DetailActionTest {

  @Test
  public void test() {
    Injector injector = ActionTestUtil.initTestInjector();
    DetailAction da = injector.getInstance(org.gbif.portal.action.dataset.DetailAction.class);
    assertNotNull(da);
    // Checklist: "Orthoptera Species File"
    da.setId("af66d4cf-0fd2-434b-9334-9806a5efa6f7");
    assertEquals(Action.SUCCESS, da.execute());
    // Dataset title = "OCNMS: Physical Oceanography: moored temperature data: Makah Bay, Washington, USA (MB015)"
    da.setId("7879e569-4a13-4643-b833-d1a564675b86:MB015X_015MTBD015R00_20040517.50.4");
    assertEquals(Action.SUCCESS, da.execute());
    // External - escaped
    // Dataset title = "OCNMS: Physical Oceanography: moored temperature data: Makah Bay, Washington, USA (MB015)"
    da.setId("7879e569-4a13-4643-b833-d1a564675b86%3AMB015X_015MTBD015R00_20040517.50.4");
    assertEquals(Action.SUCCESS, da.execute());
  }
}
