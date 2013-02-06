package org.gbif.user.guice;

import org.gbif.api.model.common.User;
import org.gbif.api.service.common.UserService;
import org.gbif.api.vocabulary.UserRole;
import org.gbif.mybatis.guice.MyBatisModule;
import org.gbif.mybatis.type.UuidTypeHandler;
import org.gbif.user.mybatis.UserMapper;
import org.gbif.user.mybatis.UserRoleTypeHandler;
import org.gbif.user.mybatis.UserServiceImpl;

import java.util.UUID;

import com.google.inject.Scopes;

/**
 * This Module should not be used, use the {@link org.gbif.user.guice.DrupalMyBatisModule} instead.
 */
public class InternalDrupalMyBatisModule extends MyBatisModule {

  public static final String DATASOURCE_BINDING_NAME = "drupal";

  public InternalDrupalMyBatisModule() {
    super(DATASOURCE_BINDING_NAME);
  }

  @Override
  protected void bindManagers() {
    // services. Make sure they are also exposed in the public module!
    bind(UserService.class).to(UserServiceImpl.class).in(Scopes.SINGLETON);
  }

  @Override
  protected void bindMappers() {
    addAlias("User").to(User.class);
    addAlias("UserRole").to(UserRole.class);
    // mybatis mapper
    addMapperClass(UserMapper.class);
  }

  @Override
  protected void bindTypeHandlers() {
    // type handler
    handleType(UserRole.class).with(UserRoleTypeHandler.class);
    handleType(UUID.class).with(UuidTypeHandler.class);
  }
}
