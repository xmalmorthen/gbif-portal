package org.gbif.portal.action.organization;

import org.gbif.portal.action.member.MemberBaseAction;
import org.gbif.registry.api.model.Organization;
import org.gbif.registry.api.service.OrganizationService;

import java.util.UUID;

import com.google.inject.Inject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class OrganizationBaseAction extends MemberBaseAction<Organization> {
  protected static final Logger LOG = LoggerFactory.getLogger(OrganizationBaseAction.class);

  @Inject
  protected OrganizationService organizationService;

  public OrganizationBaseAction() {
    super(Organization.class);
  }

  @Override
  protected Organization loadMember(UUID id) {
    return organizationService.get(id);
  }
}
