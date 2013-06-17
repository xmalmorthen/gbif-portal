package org.gbif.portal.action.node;

import org.gbif.api.model.common.paging.PagingRequest;
import org.gbif.api.model.common.paging.PagingResponse;
import org.gbif.api.model.metrics.cube.OccurrenceCube;
import org.gbif.api.model.metrics.cube.ReadBuilder;
import org.gbif.api.model.registry2.Dataset;
import org.gbif.api.model.registry2.Endpoint;
import org.gbif.api.model.registry2.Node;
import org.gbif.api.model.registry2.Organization;
import org.gbif.api.service.metrics.CubeService;
import org.gbif.api.service.registry2.NodeService;
import org.gbif.api.vocabulary.registry2.EndpointType;
import org.gbif.portal.action.member.MemberBaseAction;
import org.gbif.portal.model.CountWrapper;

import java.util.List;

import com.google.common.collect.Lists;
import com.google.inject.Inject;

public class DetailAction extends MemberBaseAction<Node> {

  private static final int MAX_DATASETS = 10;
  private final NodeService nodeService;
  private CubeService cubeService;

  private PagingResponse<Organization> page;
  private long offset = 0;

  private List<CountWrapper<Dataset>> datasets = Lists.newArrayList();

  @Inject
  public DetailAction(NodeService nodeService, CubeService cubeService) {
    super(nodeService);
    this.nodeService = nodeService;
    this.cubeService = cubeService;
  }

  @Override
  public String execute() throws Exception {
    super.execute();
    // redirect to country page if this node is a country node
    if (member.getCountry() != null) {
      id = null;
      return "country";
    }

    page = nodeService.endorsedOrganizations(id, new PagingRequest(0, 10));

    loadDatasets();

    return SUCCESS;
  }

  private void loadDatasets() {
    PagingResponse<Dataset> ds = nodeService.endorsedDatasets(id, new PagingRequest(0, MAX_DATASETS));
    for (Dataset d : ds.getResults()) {
      long cnt = cubeService.get(new ReadBuilder()
        .at(OccurrenceCube.DATASET_KEY, d.getKey()));

      long geoCnt = cubeService.get(new ReadBuilder()
        .at(OccurrenceCube.DATASET_KEY, d.getKey())
        .at(OccurrenceCube.IS_GEOREFERENCED, true));

      datasets.add(new CountWrapper(d, cnt, geoCnt));
    }
  }

  public String organizations() throws Exception {
    super.execute();

    page = nodeService.endorsedOrganizations(id, new PagingRequest(offset, 25));
    return SUCCESS;
  }

  public PagingResponse<Organization> getPage() {
    return page;
  }

  public void setOffset(long offset) {
    if (offset >= 0) {
      this.offset = offset;
    }
  }

  public List<CountWrapper<Dataset>> getDatasets() {
    return datasets;
  }

  public String getFeed() {
    if (member != null && !member.getEndpoints().isEmpty()) {
      for (Endpoint e : member.getEndpoints()) {
        if (EndpointType.FEED == e.getType()) {
          return e.getUrl();
        }
      }
    }
    return null;
  }

}
