package org.gbif.portal.model.converter;

import java.math.BigDecimal;
import java.util.Map;

import org.apache.struts2.util.StrutsTypeConverter;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class BigDecimalConverter extends StrutsTypeConverter {

  private static final Logger LOG = LoggerFactory.getLogger(BigDecimalConverter.class);

  @Override
  public Object convertFromString(Map context, String[] values, Class toClass) {
    if (values != null && values.length > 0) {
      try {
        return new BigDecimal(values[0]);
      } catch (NumberFormatException nfe) {
        return null;
      }
    }
    return null;
  }

  @Override
  public String convertToString(Map context, Object o) {
    if (o instanceof BigDecimal) {
      return o.toString();
    }
    return null;
  }
}
