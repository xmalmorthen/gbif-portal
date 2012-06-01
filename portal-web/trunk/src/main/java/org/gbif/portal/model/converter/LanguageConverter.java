package org.gbif.portal.model.converter;

import org.gbif.api.model.vocabulary.Language;

import java.util.Map;

import org.apache.struts2.util.StrutsTypeConverter;

public class LanguageConverter extends StrutsTypeConverter {

  @Override
  public Object convertFromString(Map context, String[] values, Class toClass) {
    if (values != null && values.length > 0) {
      return Language.fromIsoCode(values[0]);
    }
    return null;
  }

  @Override
  public String convertToString(Map context, Object o) {
    if (o instanceof Language) {
      return ((Language) o).getIso2LetterCode();
    }
    return null;
  }
}
