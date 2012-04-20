package org.gbif.user.mybatis;

import org.gbif.api.model.vocabulary.UserRole;
import org.gbif.mybatis.type.BaseConverter;

import com.google.common.collect.ImmutableMap;

public class UserRoleTypeConverter extends BaseConverter<Integer, UserRole>{

  /**
   * @throws IllegalArgumentException if two keys have the same value
   */
  public UserRoleTypeConverter() {
    super(null, new ImmutableMap.Builder<Integer, UserRole>()
    .put(2, UserRole.USER)
    .put(3, UserRole.ADMIN)
    .put(4, UserRole.EDITOR)
    .build());
  };
}
