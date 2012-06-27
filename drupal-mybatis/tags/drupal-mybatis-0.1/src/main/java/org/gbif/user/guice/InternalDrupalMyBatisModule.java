package org.gbif.user.guice;

import org.gbif.api.model.User;
import org.gbif.api.model.vocabulary.UserRole;
import org.gbif.api.service.UserService;
import org.gbif.mybatis.type.UuidTypeHandler;
import org.gbif.user.mybatis.UserMapper;
import org.gbif.user.mybatis.UserRoleTypeHandler;
import org.gbif.user.mybatis.UserServiceImpl;

import java.util.UUID;

import com.google.inject.Scopes;
import org.apache.ibatis.transaction.jdbc.JdbcTransactionFactory;
import org.mybatis.guice.MyBatisModule;
import org.mybatis.guice.datasource.bonecp.BoneCPProvider;

/**
 * This Module should not be used, use the {@link org.gbif.user.guice.DrupalMyBatisModule} instead.
 */
public class InternalDrupalMyBatisModule extends MyBatisModule {

  @Override
  protected void initialize() {
    environmentId("default");

    addAlias("User").to(User.class);
    addAlias("UserRole").to(UserRole.class);

    bindTransactionFactoryType(JdbcTransactionFactory.class);

    // type handler
    handleType(UserRole.class).with(UserRoleTypeHandler.class);
    handleType(UUID.class).with(UuidTypeHandler.class);

    // mybatis mapper
    addMapperClass(UserMapper.class);

    // services. Make sure they are also exposed in the public module!
    bind(UserService.class).to(UserServiceImpl.class).in(Scopes.SINGLETON);

    // TODO: Make configurable somehow? Load from classname property.
    // Couldn't figure out how to do that with the generics though.
    bindDataSourceProviderType(BoneCPProvider.class);
  }
}
