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
  }
}
