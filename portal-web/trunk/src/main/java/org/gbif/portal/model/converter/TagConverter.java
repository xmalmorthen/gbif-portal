package org.gbif.portal.model.converter;

import org.gbif.registry.api.model.Tag;

import java.util.Map;
import java.util.UUID;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.struts2.util.StrutsTypeConverter;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class TagConverter extends StrutsTypeConverter {

  private static final Logger LOG = LoggerFactory.getLogger(TagConverter.class);

  @Override
  public Object convertFromString(Map context, String[] values, Class toClass) {
    String regex = "(\\w+)(:*)(\\w+)(=*)(\\w*)";
    Tag tag = new Tag();
    if (values != null && values.length > 0) {
      Pattern pattern = Pattern.compile(regex);
      Matcher matcher = pattern.matcher(values[0]);
      if (matcher.matches()) {
        if (matcher.group(1).isEmpty()) {
          tag.setNamespace(null);
        } else {
          tag.setNamespace(matcher.group(1));
        }
        if (matcher.group(3).isEmpty()) {
          tag.setPredicate(null);
        } else {
          tag.setPredicate(matcher.group(3));
        }
        if (matcher.group(5).isEmpty()) {
          tag.setValue(null);
        } else {
          tag.setValue(matcher.group(5));
        }
      }
      return tag;
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
