package org.gbif.user;

import org.gbif.api.model.User;

public interface UserService {

  /**
   * Retrieves a user by its case insensitive username or email.
   *
   * @param usernameOrEmail
   * @return
   */
  User get(String usernameOrEmail);
}
