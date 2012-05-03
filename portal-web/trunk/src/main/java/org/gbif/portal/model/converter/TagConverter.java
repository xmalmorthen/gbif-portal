package org.gbif.portal.model.converter;

import org.gbif.registry.api.model.Tag;

import java.util.Map;

import org.apache.struts2.util.StrutsTypeConverter;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class TagConverter extends StrutsTypeConverter {

  private static final Logger LOG = LoggerFactory.getLogger(TagConverter.class);

  @Override
  public Object convertFromString(Map context, String[] values, Class toClass) {
    Tag tag = new Tag();
    if (values != null && values.length > 0) {

      if ((values[0].indexOf(':') != -1) && (values[0].indexOf('=') != -1)) {
        String[] tokens = values[0].split(":");
        tag.setNamespace(tokens[0]);
        String[] subTokens = tokens[1].split("=");
        tag.setPredicate(subTokens[0]);
        tag.setValue(subTokens[1]);
      } else if (values[0].indexOf('=') != -1) {
        // TODO: if it just has the predicate & value, should we assign it a default namespace (from TagNamespace)
        String[] subTokens = values[0].split("=");
        tag.setPredicate(subTokens[0]);
        tag.setValue(subTokens[1]);
      } else {
        // TODO: if it just has the predicate, should we assign it a default namespace (from TagNamespace)
        tag.setPredicate(values[0]);
      }
      return tag;
    }
    return null;
  }


  @Override
  public String convertToString(Map context, Object o) {
    if (o instanceof Tag) {
      return o.toString();
    }
    return null;
  }

}
