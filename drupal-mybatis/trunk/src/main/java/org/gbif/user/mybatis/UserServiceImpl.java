package org.gbif.user.mybatis;

import org.gbif.api.model.User;
import org.gbif.user.UserService;

import com.google.inject.Inject;

public class UserServiceImpl implements UserService{
  private UserMapper mapper;

  @Inject
  UserServiceImpl(UserMapper mapper) {
    this.mapper = mapper;
  }

  @Override
  public User get(String usernameOrEmail) {
    return mapper.get(usernameOrEmail);
  }
}
