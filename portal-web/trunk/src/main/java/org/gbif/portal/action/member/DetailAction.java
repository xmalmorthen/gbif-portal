package org.gbif.portal.action.member;

import org.gbif.portal.action.BaseAction;
import org.gbif.portal.action.NotFoundException;
import org.gbif.registry.api.model.WritableMember;
import org.gbif.registry.api.service.NetworkService;
import org.gbif.registry.api.service.NodeService;
import org.gbif.registry.api.service.OrganizationService;
import org.gbif.registry.api.service.TechnicalInstallationService;

import java.util.UUID;

import com.google.inject.Inject;

/**
 * Redirects to the typed url for the member or throws NotFoundException.
 */
public class DetailAction extends BaseAction {
  @Inject
  private OrganizationService organizationService;
  @Inject
  private NodeService nodeService;
  @Inject
  private NetworkService networkService;
  @Inject
  private TechnicalInstallationService technicalInstallationService;

  private UUID id;
  private String redirectUrl;

  @Override
  public String execute() {
    if (id != null) {
      // check organisation
      WritableMember member = organizationService.get(id);
      if (member != null){
        return redirect("organization");
      }

      member = nodeService.get(id);
      if (member != null){
        return redirect("node");
      }

      member = networkService.get(id);
      if (member != null){
        return redirect("network");
      }

      member = technicalInstallationService.get(id);
      if (member != null){
        return redirect("installation");
      }
    }
    throw new NotFoundException();
  }

  private String redirect(String type){
    redirectUrl = getBaseUrl() + "/" + type.toLowerCase() + "/" + id.toString();
    return SUCCESS;
  }

  public void setId(String id) {
    try {
      this.id = UUID.fromString(id);
    } catch (Exception e) {
      this.id = null;
    }
  }

  public String getRedirectUrl() {
    return redirectUrl;
  }
}
