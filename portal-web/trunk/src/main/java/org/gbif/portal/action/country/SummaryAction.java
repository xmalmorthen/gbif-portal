package org.gbif.portal.action.country;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class SummaryAction extends CountryBaseAction {
  private static Logger LOG = LoggerFactory.getLogger(SummaryAction.class);

  @Override
  public String execute() throws Exception {
    super.execute();

    buildAboutMetrics(0,0);
    // load 6 latest published datasets
    buildByMetrics(7,0);

    LOG.info("Render complete country summary page for {} in: {}", country, watch.toString());
    return SUCCESS;
  }

}
