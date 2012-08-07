package org.gbif.metrics.tile;

import org.gbif.metrics.cube.tile.density.DensityCube;
import org.gbif.metrics.cube.tile.density.DensityTile;

import java.io.IOException;
import java.util.concurrent.TimeUnit;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.common.base.Optional;
import com.google.inject.Inject;
import com.google.inject.Singleton;
import com.urbanairship.datacube.DataCubeIo;
import com.yammer.metrics.Metrics;
import com.yammer.metrics.core.Meter;
import com.yammer.metrics.core.Timer;
import com.yammer.metrics.core.TimerContext;

/**
 * A simple tile rendering servlet that sources it's data from a data cube.
 */
@Singleton
public class DensityTileRenderer extends CubeTileRenderer<DensityTile> {

  private static final long serialVersionUID = 8681716273998041332L;
  // allow monitoring of cube lookup, rendering speed and the throughput per second
  private final Timer renderTimer = Metrics.newTimer(DensityTileRenderer.class, "renderDuration", TimeUnit.MILLISECONDS, TimeUnit.SECONDS);
  private final Meter requests = Metrics.newMeter(DensityTileRenderer.class, "requests", "requests", TimeUnit.SECONDS);

  @Inject
  public DensityTileRenderer(DataCubeIo<DensityTile> cubeIo) {
    super(cubeIo);
  }

  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    resp.setHeader("Content-Type", "image/png");
    try {
      Optional<DensityTile> tile = getTile(req, DensityCube.INSTANCE);
      if (tile.isPresent()) {
        requests.mark();
        final TimerContext context = renderTimer.time();
        try {
          PNGWriter.write(tile.get(), resp.getOutputStream());
        } finally {
          context.stop();
        }
      } else {
        resp.getOutputStream().write(PNGWriter.EMPTY_TILE);
      }
    } catch (IllegalArgumentException e) {
      // If we couldn't get the content from the request
      resp.sendError(HttpServletResponse.SC_BAD_REQUEST, e.getMessage());
    } catch (Exception e) {
      // We are unable to get or render the tile
      resp.sendError(HttpServletResponse.SC_SERVICE_UNAVAILABLE, "Tile server is out of action, please try later");
    }
    resp.flushBuffer();
  }
}
