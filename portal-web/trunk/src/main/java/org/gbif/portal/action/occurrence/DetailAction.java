package org.gbif.portal.action.occurrence;

import org.gbif.registry.api.model.Organization;
import org.gbif.registry.api.service.OrganizationService;

import com.google.inject.Inject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class DetailAction extends OccurrenceBaseAction {

  private static final Logger LOG = LoggerFactory.getLogger(DetailAction.class);

  @Inject
  private OrganizationService organizationService;

  private Organization publisher;

  @Override
  public String execute() {
    loadDetail();
    // load publisher
    publisher = organizationService.get(dataset.getOwningOrganizationKey());

    return SUCCESS;
  }

  public String verbatim() {
    loadDetail();
    LOG.debug("Loading raw details for occurrence id [{}]", id);
    return execute();
  }

  public Organization getPublisher() {
    return publisher;
  }
}
