package org.gbif.portal.model.converter;

import java.net.MalformedURLException;
import java.net.URL;
import java.util.Map;

import org.apache.struts2.util.StrutsTypeConverter;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class UrlConverter extends StrutsTypeConverter {

  private static final Logger LOG = LoggerFactory.getLogger(UrlConverter.class);

  @Override
  public Object convertFromString(Map context, String[] values, Class toClass) {
    if (values != null && values.length > 0) {
      try {
        return new URL(values[0]);
      } catch (MalformedURLException e) {
        LOG.debug("URL is not valid and therefore can't be converted");
      }
    }
    return null;
  }

  @Override
  public String convertToString(Map context, Object o) {
    if (o instanceof URL) {
      return o.toString();
    }
    return null;
  }
}
