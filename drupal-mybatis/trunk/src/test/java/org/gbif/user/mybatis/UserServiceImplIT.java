package org.gbif.user.mybatis;

import org.gbif.api.model.User;
import org.gbif.api.model.vocabulary.UserRole;
import org.gbif.user.UserService;

import org.junit.Assert;
import org.junit.Rule;
import org.junit.Test;

public class UserServiceImplIT {

  @Rule
  public DrupalTestRule<UserService> ddt = new DrupalTestRule<UserService>(UserService.class, "users.xml");

  @Test
  public void testGet() throws Exception {
    User admin = ddt.getService().get("admin");
    Assert.assertNotNull(admin);
    Assert.assertEquals("admin", admin.getName());
    Assert.assertEquals(1, admin.getRoles().size());
    Assert.assertTrue(admin.getRoles().contains(UserRole.ADMIN));
  }

}
