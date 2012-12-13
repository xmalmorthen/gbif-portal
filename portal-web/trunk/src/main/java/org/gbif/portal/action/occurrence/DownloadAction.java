package org.gbif.portal.action.occurrence;

import org.gbif.api.model.occurrence.Download;
import org.gbif.api.model.occurrence.predicate.Predicate;
import org.gbif.api.service.occurrence.DownloadService;
import org.gbif.portal.action.BaseAction;
import org.gbif.portal.action.occurrence.util.PredicateFactory;

import java.util.Date;
import java.util.List;
import java.util.Map;

import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.google.inject.Inject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class DownloadAction extends BaseAction {

  // This is a placeholder to map from the JSON definition ID to the query field
  private static final Map<String, String> QUERY_FIELD_MAPPING = Maps.newHashMap();
  static {
    QUERY_FIELD_MAPPING.put("1", "i_scientific_name");
    QUERY_FIELD_MAPPING.put("4", "country");
    QUERY_FIELD_MAPPING.put("6", "i_latitude");
    QUERY_FIELD_MAPPING.put("7", "i_longitude");
    QUERY_FIELD_MAPPING.put("8", "i_altitude");
    QUERY_FIELD_MAPPING.put("9", "i_depth");
    QUERY_FIELD_MAPPING.put("15", "i_year");
    QUERY_FIELD_MAPPING.put("16", "i_month");
    QUERY_FIELD_MAPPING.put("18", "institution_code");
    QUERY_FIELD_MAPPING.put("19", "collection_code");
    QUERY_FIELD_MAPPING.put("20", "catalog_number");
  }

  private static final long serialVersionUID = 3653614424275432914L;
  private static final Logger LOG = LoggerFactory.getLogger(DownloadAction.class);
  private final PredicateFactory predicateFactory = new PredicateFactory(QUERY_FIELD_MAPPING);

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
    if (p != null) {
      Download download = new Download(null, p, getCurrentUser().getEmail(), new Date(), null, emails);
      jobId = downloadService.create(download);
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

  public List<String> getEmails() {
    return emails;
  }

  public void setEmails(List<String> emails) {
    this.emails = emails;
  }
}
