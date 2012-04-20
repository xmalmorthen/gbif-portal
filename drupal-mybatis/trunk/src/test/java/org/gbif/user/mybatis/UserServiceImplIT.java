package org.gbif.user.mybatis;

import org.junit.Rule;
import org.junit.Test;

public class UserServiceImplIT {

  @Rule
  public DrupalTestRule ddt = new DrupalTestRule("users.xml");

  @Test
  public void testGet() throws Exception {

  }
}
