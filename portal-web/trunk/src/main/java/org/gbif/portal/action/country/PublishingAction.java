package org.gbif.portal.action.country;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class PublishingAction extends CountryBaseAction {
  private static Logger LOG = LoggerFactory.getLogger(PublishingAction.class);

  @Override
  public String execute() throws Exception {
    super.execute();

    buildByMetrics(7, 7);

    LOG.info("Render complete country publishing page for {} in: {}", country, watch.toString());
    return SUCCESS;
  }

}
