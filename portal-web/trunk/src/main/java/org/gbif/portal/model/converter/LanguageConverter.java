package org.gbif.portal.model.converter;

import org.gbif.api.model.vocabulary.InterpretedEnum;
import org.gbif.api.model.vocabulary.Language;

import java.util.Map;

import org.apache.struts2.util.StrutsTypeConverter;

public class LanguageConverter extends StrutsTypeConverter {

  @Override
  public Object convertFromString(Map context, String[] values, Class toClass) {
    if (values != null && values.length > 0) {
      InterpretedEnum<String, Language> ie =
        new InterpretedEnum<String, Language>(values[0], Language.valueOf(values[0]));
      return ie;
    }
    return null;
  }

  @Override
  public String convertToString(Map context, Object o) {
    if (o instanceof InterpretedEnum) {
      return ((InterpretedEnum) o).getInterpreted().name();
    }
    return null;
  }
}
