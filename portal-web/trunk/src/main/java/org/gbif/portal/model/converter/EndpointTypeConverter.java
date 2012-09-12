package org.gbif.portal.model.converter;

import org.gbif.api.vocabulary.EndpointType;

import java.util.Map;

import org.apache.struts2.util.StrutsTypeConverter;

public class EndpointTypeConverter extends StrutsTypeConverter {

  @Override
  public Object convertFromString(Map context, String[] values, Class toClass) {
    if (values != null && values.length > 0) {
      return EndpointType.valueOf(values[0]);
    }
    return null;
  }

  @Override
  public String convertToString(Map context, Object o) {
    if (o instanceof EndpointType) {
      return ((EndpointType) o).name();
    }
    return null;
  }
}
