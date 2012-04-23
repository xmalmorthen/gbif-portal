package org.gbif.user.mybatis;

import org.gbif.api.model.User;
import org.gbif.api.service.UserService;

import com.google.inject.Inject;

public class UserServiceImpl implements UserService {
  private UserMapper mapper;

  @Inject
  UserServiceImpl(UserMapper mapper) {
    this.mapper = mapper;
  }

  @Override
  public User get(String username) {
    return mapper.get(username);
  }

}
