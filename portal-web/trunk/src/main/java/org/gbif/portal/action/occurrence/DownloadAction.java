package org.gbif.portal.action.occurrence;

import org.gbif.api.model.occurrence.Download;
import org.gbif.api.model.occurrence.predicate.Predicate;
import org.gbif.api.service.occurrence.DownloadService;
import org.gbif.portal.action.BaseAction;
import org.gbif.portal.action.occurrence.util.PredicateFactory;

import java.util.Date;
import java.util.List;

import com.google.common.base.Splitter;
import com.google.common.collect.Lists;
import com.google.inject.Inject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class DownloadAction extends BaseAction {

  private static final long serialVersionUID = 3653614424275432914L;
  private static final Logger LOG = LoggerFactory.getLogger(DownloadAction.class);
  private final static Splitter EMAIL_SPLITTER = Splitter.on(";").trimResults().omitEmptyStrings();
  private final PredicateFactory predicateFactory = new PredicateFactory();

  @Inject
  private DownloadService downloadService;

  private String jobId;
  // optional additional email notifications
  private List<String> emails = Lists.newArrayList();

  @Override
  public String execute() {
    // nothing more we can do than suppress
    @SuppressWarnings("unchecked")
    Predicate p = predicateFactory.build(getServletRequest().getParameterMap());

    LOG.info("Predicate build for passing to download [{}]", p);

    Download download = new Download(null, p, getCurrentUser().getEmail(), new Date(), null, emails);
    jobId = downloadService.create(download);

    return SUCCESS;
  }

  public List<String> getEmails() {
    return emails;
  }

  public String getJobId() {
    return jobId;
  }

  public void setEmails(String emails) {
    this.emails = Lists.newArrayList(EMAIL_SPLITTER.split(emails));
  }

  public void setJobId(String jobId) {
    this.jobId = jobId;
  }
}
