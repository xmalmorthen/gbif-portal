package org.gbif.portal.model.converter;

import java.util.Map;
import java.util.UUID;

import org.apache.struts2.util.StrutsTypeConverter;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class UuidConverter extends StrutsTypeConverter {

  private static final Logger LOG = LoggerFactory.getLogger(UuidConverter.class);

  @Override
  public Object convertFromString(Map context, String[] values, Class toClass) {
    try {
      if (values != null && values.length > 0) {
        return UUID.fromString(values[0]);
      }
    } catch (IllegalArgumentException exc) {
      return null;
    }
    return null;
  }

  @Override
  public String convertToString(Map context, Object o) {
    if (o instanceof UUID) {
      return o.toString();
    }
    return null;
  }
}
