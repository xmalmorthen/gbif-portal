package org.gbif.user.mybatis;

import org.gbif.api.model.User;
import org.gbif.api.model.vocabulary.UserRole;
import org.gbif.api.service.UserService;

import org.junit.Assert;
import org.junit.Ignore;
import org.junit.Rule;
import org.junit.Test;

@Ignore("Datasource needs to be exposed in module for this test to work")
public class UserServiceImplIT {

  @Rule
  public DrupalTestRule<UserService> ddt = new DrupalTestRule<UserService>(UserService.class, "users.xml");

  @Test
  public void testGet() throws Exception {
    User admin = ddt.getService().get("admin");
    Assert.assertNotNull(admin);
    Assert.assertEquals("admin", admin.getName());
    Assert.assertEquals("admin@mailinator.com", admin.getEmail());
    Assert.assertEquals(1, admin.getRoles().size());
    Assert.assertTrue(admin.getRoles().contains(UserRole.ADMIN));
  }

  @Test
  public void testAuthenticate() throws Exception {
    User editor = ddt.getService().authenticate("editor", "1cX3FYss");
    Assert.assertNotNull(editor);
    Assert.assertEquals("editor", editor.getName());
    Assert.assertEquals("editor@mailinator.com", editor.getEmail());
    Assert.assertEquals("49b8802c656a2cd1aa73f3c50090df76", editor.getPasswordHash());
    Assert.assertEquals(1, editor.getRoles().size());
    Assert.assertTrue(editor.getRoles().contains(UserRole.EDITOR));

    editor = ddt.getService().authenticate("editor", "1cX3FYs");
    Assert.assertNull(editor);
  }

}
