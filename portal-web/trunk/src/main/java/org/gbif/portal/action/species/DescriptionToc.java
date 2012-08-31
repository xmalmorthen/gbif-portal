package org.gbif.portal.action.species;

import org.gbif.api.model.vocabulary.Language;
import org.gbif.checklistbank.api.model.Description;

import java.util.List;
import java.util.Map;

import com.google.common.base.Strings;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;

/**
 * Simple class wrapping all descriptions for a species and exposing methods used to generate a table of content menu.
 * This could become part of the regular CLB api at some point, but for now we use the basic listByUsage methods of
 * the DescriptionService to feed the ToC with full descriptions.
 */
public class DescriptionToc {
  private Map<String, Map<Language, List<Integer>>> descriptionToc = Maps.newTreeMap();

  public void addDescription(Description description) {
    String topic = "general";
    if (!Strings.isNullOrEmpty(description.getType())) {
      topic = description.getType().toLowerCase();
    }
    if (!descriptionToc.containsKey(topic)) {
      descriptionToc.put(topic, Maps.<Language, List<Integer>>newTreeMap());
    }

    // default as english
    Language lang = Language.ENGLISH;
    if (description.getLanguage() != null) {
      Language l = Language.fromIsoCode(description.getLanguage());
      if (l != null) {
        lang = l;
      }
    }
    if (!descriptionToc.get(topic).containsKey(lang)) {
      descriptionToc.get(topic).put(lang, Lists.<Integer>newArrayList());
    }
    descriptionToc.get(topic).get(lang).add(description.getKey());
  }

  /**
   * @return list of all topics available in this toc
   */
  public List<String> listTopics() {
    return Lists.newArrayList(descriptionToc.keySet());
  }

  /**
   * @return map of all languages available for this topic with a list of description keys for each language
   */
  public Map<Language, List<Integer>> listTopicEntries(String topic) {
    if (descriptionToc.containsKey(topic)) {
      return descriptionToc.get(topic);
    }
    return Maps.newHashMap();
  }

  public boolean isEmpty() {
    return descriptionToc.isEmpty();
  }
}
