package org.gbif.user.mybatis;

import org.gbif.api.model.User;
import org.gbif.api.model.vocabulary.UserRole;
import org.gbif.api.service.UserService;

import org.junit.Assert;
import org.junit.Ignore;
import org.junit.Rule;
import org.junit.Test;

public class UserServiceImplIT {

  @Rule
  public DrupalTestRule<UserService> ddt = new DrupalTestRule<UserService>(UserService.class, "users.xml");

  @Test
  @Ignore("Datasource needs to be exposed in module for this test to work")
  public void testGet() throws Exception {
    User admin = ddt.getService().get("admin");
    Assert.assertNotNull(admin);
    Assert.assertEquals("admin", admin.getName());
    Assert.assertEquals("admin@mailinator.com", admin.getEmail());
    Assert.assertEquals(1, admin.getRoles().size());
    Assert.assertTrue(admin.getRoles().contains(UserRole.ADMIN));
  }

}
