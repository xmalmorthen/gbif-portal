package org.gbif.user.mybatis;

import org.gbif.api.model.common.User;
import org.gbif.api.service.common.UserService;
import org.gbif.api.vocabulary.UserRole;

import org.junit.Assert;
import org.junit.Rule;
import org.junit.Test;

public class UserServiceImplIT {

  @Rule
  public DrupalTestRule<UserService> ddt = new DrupalTestRule<UserService>(UserService.class);

  @Test
  public void testGet() throws Exception {
    User admin = ddt.getService().get("admin");
    Assert.assertNotNull(admin);
    Assert.assertEquals("admin", admin.getUserName());
    Assert.assertEquals("admin@mailinator.com", admin.getEmail());
    Assert.assertEquals(1, admin.getRoles().size());
    Assert.assertTrue(admin.getRoles().contains(UserRole.ADMIN));
  }

  @Test
  public void testGetBySession() throws Exception {
    User nonExisting = ((UserServiceImpl) ddt.getService()).getBySession("FAKE");
    Assert.assertNull(nonExisting);
  }

  @Test
  public void testAuthenticate() throws Exception {
    User editor = ddt.getService().authenticate("editor", "1cX3FYss");
    Assert.assertNotNull(editor);
    Assert.assertEquals("editor", editor.getUserName());
    Assert.assertEquals("editor@mailinator.com", editor.getEmail());
    Assert.assertEquals("49b8802c656a2cd1aa73f3c50090df76", editor.getPasswordHash());
    Assert.assertEquals(1, editor.getRoles().size());
    Assert.assertTrue(editor.getRoles().contains(UserRole.EDITOR));

    editor = ddt.getService().authenticate("editor", "1cX3FYs");
    Assert.assertNull(editor);
  }

}
