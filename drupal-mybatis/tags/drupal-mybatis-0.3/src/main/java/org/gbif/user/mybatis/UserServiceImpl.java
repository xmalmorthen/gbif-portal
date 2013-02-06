package org.gbif.user.mybatis;

import org.gbif.api.model.common.User;
import org.gbif.api.service.common.UserService;
import org.gbif.user.util.PasswordEncoder;

import java.util.concurrent.TimeUnit;

import com.google.common.base.Strings;
import com.google.common.cache.Cache;
import com.google.common.cache.CacheBuilder;
import com.google.inject.Inject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class UserServiceImpl implements UserService {

  private static final Logger LOG = LoggerFactory.getLogger(UserServiceImpl.class);

  private final UserMapper mapper;
  private final Cache<String, User> cache;
  private final PasswordEncoder encoder = new PasswordEncoder("MD5");

  @Inject
  public UserServiceImpl(UserMapper mapper) {
    this.mapper = mapper;
    cache = CacheBuilder.newBuilder().maximumSize(1000).expireAfterWrite(1, TimeUnit.MINUTES).build();
  }

  @Override
  public User get(String username) {
    if (Strings.isNullOrEmpty(username)) {
      return null;
    }

    User u = cache.getIfPresent(username);
    if (u == null) {
      u = mapper.get(username);
      // make sure we found a user with that name
      if (u == null) {
        LOG.debug("Cannot find user " + username);
        return null;
      }
      cache.put(username, u);
    }
    return u;
  }

  @Override
  public User authenticate(String username, String password) {
    if (Strings.isNullOrEmpty(username) || password == null) {
      return null;
    }

    User u = get(username);
    if (u != null) {
      // build password hash stored in drupal
      String phash = encoder.encode(password);
      if (phash.equalsIgnoreCase(u.getPasswordHash())) {
        return u;
      }
    }

    return null;
  }

}
