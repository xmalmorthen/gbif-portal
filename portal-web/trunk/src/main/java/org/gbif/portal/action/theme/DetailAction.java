package org.gbif.portal.action.theme;

import org.gbif.portal.action.BaseAction;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class DetailAction extends BaseAction {

  private static final Logger LOG = LoggerFactory.getLogger(DetailAction.class);

  private String id;
  private String themeName;

  @Override
  public String execute() {
    if (id != null) {
      LOG.debug("Got requested theme id of [{}]", id);
      themeName = humanize(id, true);
      LOG.debug("Using theme name of {}", themeName);
    }
    return SUCCESS;
  }

  /**
   * TODO: move to utils of some kind
   */
  private String humanize(String underscoredString, boolean allFirstCharsUpper) {
    String[] parts = underscoredString.toLowerCase().split("_");
    StringBuffer result = new StringBuffer();
    int partCount = -1;
    for (String part : parts) {
      partCount++;
      if (partCount == 0 || allFirstCharsUpper) {
        result.append(part.substring(0, 1).toUpperCase());
        result.append(part.substring(1, part.length()));
      } else {
        result.append(part);
      }
      if ((partCount + 1) < parts.length) {
        result.append(" ");
      }
    }

    return result.toString();
  }

  public String getId() {
    return id;
  }

  public String getThemeName() {
    return themeName;
  }

  public void setThemeName(String themeName) {
    this.themeName = themeName;
  }

  public void setId(String id) {
    this.id = id;

  }
}
