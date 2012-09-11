package org.gbif.user.mybatis;

import org.gbif.api.model.common.User;

public interface UserMapper {

  /**
   * Retrieves a user by its case insensitive username or email.
   */
  User get(String name);
}
