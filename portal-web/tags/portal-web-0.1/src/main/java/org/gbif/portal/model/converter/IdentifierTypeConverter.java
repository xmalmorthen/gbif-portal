package org.gbif.portal.model.converter;

import org.gbif.api.model.vocabulary.IdentifierType;

import java.util.Map;

import org.apache.struts2.util.StrutsTypeConverter;

public class IdentifierTypeConverter extends StrutsTypeConverter {

  @Override
  public Object convertFromString(Map context, String[] values, Class toClass) {
    if (values != null && values.length > 0) {
      return IdentifierType.valueOf(values[0]);
    }
    return null;
  }

  @Override
  public String convertToString(Map context, Object o) {
    if (o instanceof IdentifierType) {
      return ((IdentifierType) o).name();
    }
    return null;
  }
}