package org.gbif.user.mybatis;

import org.gbif.api.model.User;
import org.gbif.api.service.UserService;

import java.util.concurrent.TimeUnit;

import com.google.common.base.Strings;
import com.google.common.cache.Cache;
import com.google.common.cache.CacheBuilder;
import com.google.inject.Inject;

public class UserServiceImpl implements UserService {
  private UserMapper mapper;
  private Cache<String, User> cache;

  @Inject
  public UserServiceImpl(UserMapper mapper) {
    this.mapper = mapper;
    cache = CacheBuilder.newBuilder()
      .maximumSize(1000)
      .expireAfterWrite(1, TimeUnit.MINUTES)
      .build();
  }

  @Override
  public User get(String username) {
    if (Strings.isNullOrEmpty(username)){
      return null;
    }

    User u = cache.getIfPresent(username);
    if (u == null){
      u = mapper.get(username);
      cache.put(username, u);
    }
    return u;
  }

}
