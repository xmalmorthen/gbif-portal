package org.gbif.portal.config;

import org.gbif.api.model.checklistbank.DatasetMetrics;
import org.gbif.api.model.registry.Dataset;
import org.gbif.api.service.checklistbank.DatasetMetricsService;
import org.gbif.api.service.registry.DatasetService;
import org.gbif.portal.action.ActionTestUtil;

import java.util.UUID;

import com.google.inject.Injector;
import org.junit.Before;
import org.junit.Test;

import static org.junit.Assert.assertNull;

public class PortalModuleIT {

  private Injector injector;

  @Before
  public void setup() {
    // will make a new instance of PortalModule(), calling its configure() which installs the various clients
    injector = ActionTestUtil.initTestInjector();
  }

  /**
   * Ultimately, we want to test that the Client has been properly installed, and any interceptors have been properly
   * bound. In particular, the HttpErrorResponseInterceptor will have been bound to every single public method in
   * every single client package. This binding is done in the client's super class GbifWsClientModule configure().
   * </p>
   * Please note, that if one client has had the NotFoundToNullInterceptor bound, we can rest assured all the others
   * will have been bound as well. Therefore, we only need to test one service.
   * </p>
   * This test uses DatasetMetricsService, bound to DatasetMetricsWsClient in the ChecklistBankWsServiceClientModule.
   * This test tries to retrieve metrics for a checklist calling: public DatasetMetrics get(UUID datasetKey).
   * This test intentionally uses a checklist that doesn't exist. The service returns a 204 (no content) response.
   * If the HttpErrorResponseInterceptor has been bound, the 204 response is converted to NULL.
   * @see org.gbif.ws.client.interceptor.HttpErrorResponseInterceptor#invoke(org.aopalliance.intercept.MethodInvocation)
   */
  @Test
  public void testChecklistBankWsClientModuleInstalled() {
    DatasetMetricsService cms = injector.getInstance(org.gbif.api.service.checklistbank.DatasetMetricsService.class);
    DatasetMetrics metrics = cms.get(UUID.randomUUID());
    assertNull(metrics);
  }

  /**
   * This test tries to retrieve a dataset calling: public Dataset get(@PathParam("key") String key).
   * </p>
   * The ws-client method is annotated with @NullForNotFound (a client interceptor called NotFoundToNullInterceptor
   * catches a NotFoundException and returns NULL instead). The ws-client method is also annotated with
   * HttpErrorResponseInterceptor (a client method interceptor that translates http response errors into actual java
   * exceptions. The order of the interceptors is important, so that the 404 gets translated into a NotFoundException
   * and this gets translated into null.
   * </p>
   * This test intentionally uses a dataset that doesn't exist. The web service returns a 404 (not found) response.
   * If the NotFoundToNullInterceptor and HttpErrorResponseInterceptor have been bound, and the interceptor order is
   * correct, the final response is NULL.
   * @see org.gbif.ws.client.interceptor.NotFoundToNullInterceptor
   * @see org.gbif.ws.client.interceptor.HttpErrorResponseInterceptor#invoke(org.aopalliance.intercept.MethodInvocation)
   */
  @Test
  public void testRegistryWsClientModuleInstalled() {
    DatasetService ds = injector.getInstance(org.gbif.api.service.registry.DatasetService.class);
    Dataset dataset = ds.get(UUID.randomUUID());
    assertNull(dataset);
  }
}
