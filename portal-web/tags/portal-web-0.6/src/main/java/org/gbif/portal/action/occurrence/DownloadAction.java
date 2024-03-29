package org.gbif.portal.action.occurrence;

import org.gbif.api.model.occurrence.DownloadRequest;
import org.gbif.api.model.occurrence.predicate.Predicate;
import org.gbif.api.service.occurrence.DownloadRequestService;
import org.gbif.portal.action.BaseAction;
import org.gbif.portal.action.occurrence.util.PredicateFactory;

import java.util.Set;

import com.google.common.base.Splitter;
import com.google.common.collect.Sets;
import com.google.inject.Inject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class DownloadAction extends BaseAction {

  private static final long serialVersionUID = 3653614424275432914L;
  private static final Logger LOG = LoggerFactory.getLogger(DownloadAction.class);
  private static final Splitter EMAIL_SPLITTER = Splitter.on(';').trimResults().omitEmptyStrings();
  private final PredicateFactory predicateFactory = new PredicateFactory();

  @Inject
  private DownloadRequestService downloadRequestService;

  private String jobId;
  // optional additional email notifications
  private Set<String> emails = Sets.newHashSet();

  @Override
  public String execute() {
    // nothing more we can do than suppress
    @SuppressWarnings("unchecked")
    Predicate p = predicateFactory.build(getServletRequest().getParameterMap());

    LOG.info("Predicate build for passing to download [{}]", p);

    emails.add(getCurrentUser().getEmail());
    DownloadRequest download = new DownloadRequest(p, getCurrentUser().getUserName(), emails);
    jobId = downloadRequestService.create(download);

    return SUCCESS;
  }

  public Set<String> getEmails() {
    return emails;
  }

  public String getJobId() {
    return jobId;
  }

  public void setEmails(String emails) {
    this.emails = Sets.newHashSet(EMAIL_SPLITTER.split(emails));
  }

}
