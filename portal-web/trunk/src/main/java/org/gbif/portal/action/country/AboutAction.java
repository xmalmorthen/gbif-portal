package org.gbif.portal.action.country;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class AboutAction extends CountryBaseAction {
  private static Logger LOG = LoggerFactory.getLogger(AboutAction.class);

  @Override
  public String execute() throws Exception {
    super.execute();

    buildAboutMetrics(7, 7);

    LOG.info("Render complete country about page for {} in: {}", country, watch.toString());
    return SUCCESS;
  }

}
