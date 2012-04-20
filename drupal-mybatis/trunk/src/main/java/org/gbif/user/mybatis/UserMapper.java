package org.gbif.user.mybatis;

import org.gbif.api.model.User;

public interface UserMapper {
  /**
   * Retrieves a user by its case insensitive username or email.
   *
   * @param name
   * @return
   */
  User get(String name);
}
