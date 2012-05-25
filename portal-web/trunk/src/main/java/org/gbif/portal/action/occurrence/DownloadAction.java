package org.gbif.portal.action.occurrence;

import org.gbif.occurrencestore.download.api.model.Download;
import org.gbif.occurrencestore.download.api.model.predicate.Predicate;
import org.gbif.occurrencestore.download.api.service.DownloadService;
import org.gbif.portal.action.BaseAction;
import org.gbif.portal.action.occurrence.util.PredicateFactory;

import com.google.inject.Inject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class DownloadAction extends BaseAction {

  private static final long serialVersionUID = 3653614424275432914L;
  private static final Logger LOG = LoggerFactory.getLogger(DownloadAction.class);
  private final PredicateFactory predicateFactory = new PredicateFactory();

  @Inject
  private DownloadService downloadService;

  private String jobId;


  @Override
  public String execute() {
    LOG.info("Request [{}]", getServletRequest());
    LOG.info("Request [{}]", getServletRequest().getParameterMap());

    // nothing more we can do than suppress
    @SuppressWarnings("unchecked")
    Predicate p = predicateFactory.build(getServletRequest().getParameterMap());

    LOG.info("Predicate build for passing to download [{}]", p);
    if (p != null) {
      jobId = downloadService.create(new Download(p, "trobertson@gbif.org"));
      return SUCCESS;
    } else {
      return ERROR;
    }
  }

  public String getJobId() {
    return jobId;
  }

  public void setJobId(String jobId) {
    this.jobId = jobId;
  }
}
