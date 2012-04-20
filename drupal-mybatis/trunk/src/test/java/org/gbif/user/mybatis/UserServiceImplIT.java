package org.gbif.user.mybatis;

import org.gbif.api.model.User;
import org.gbif.user.UserService;

import com.google.inject.Inject;
import org.junit.Assert;
import org.junit.Rule;
import org.junit.Test;

public class UserServiceImplIT {

  @Inject
  private UserService service;

  @Rule
  public DrupalTestRule ddt = new DrupalTestRule("users.xml");

  @Test
  public void testGet() throws Exception {
    User admin = service.get("admin");
    Assert.assertNotNull(admin);
    Assert.assertEquals("admin", admin.getName());
  }
}
