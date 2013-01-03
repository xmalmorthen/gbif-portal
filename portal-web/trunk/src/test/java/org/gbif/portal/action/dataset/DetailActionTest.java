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
    da.setId("2344f83d-eefb-4635-afed-fb2a1c9bd466:MB015X_015MTBD005R00_20060606.50.6");
    assertEquals(Action.SUCCESS, da.execute());
    // External - escaped
    // Dataset title = "OCNMS: Physical Oceanography: moored temperature data: Makah Bay, Washington, USA (MB015)"
    da.setId("2344f83d-eefb-4635-afed-fb2a1c9bd466%MB015X_015MTBD005R00_20060606.50.6");
    assertEquals(Action.SUCCESS, da.execute());
  }
}
