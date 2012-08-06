package org.gbif.metrics.tile;

import org.gbif.metrics.cube.tile.density.DensityCube;
import org.gbif.metrics.cube.tile.density.DensityTile;
import org.gbif.metrics.cube.tile.io.TileContentType;

import java.io.IOException;
import java.util.concurrent.TimeUnit;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.common.base.Optional;
import com.google.inject.Inject;
import com.google.inject.Singleton;
import com.urbanairship.datacube.Address;
import com.urbanairship.datacube.DataCubeIo;
import com.urbanairship.datacube.ReadBuilder;
import com.yammer.metrics.Metrics;
import com.yammer.metrics.core.Meter;
import com.yammer.metrics.core.Timer;
import com.yammer.metrics.core.TimerContext;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * A simple tile rendering servlet that sources it's data from a data cube.
 */
@Singleton
public class DensityTileRenderer extends HttpServlet {

  private static final Logger LOG = LoggerFactory.getLogger(DensityTileRenderer.class);
  private static final String REQ_TYPE = "type";
  private static final String REQ_KEY = "key";
  private static final String REQ_Z = "z";
  private static final String REQ_X = "x";
  private static final String REQ_Y = "y";

  private static final long serialVersionUID = 8681716273998041332L;
  private final DataCubeIo<DensityTile> cubeIo;
  // allow monitoring of cube lookup, rendering speed and the throughput per second
  private final Timer readTimer = Metrics.newTimer(DensityTileRenderer.class, "readDuration", TimeUnit.MILLISECONDS, TimeUnit.SECONDS);
  private final Timer renderTimer = Metrics.newTimer(DensityTileRenderer.class, "renderDuration", TimeUnit.MILLISECONDS, TimeUnit.SECONDS);
  private final Meter requests = Metrics.newMeter(DensityTileRenderer.class, "requests", "requests", TimeUnit.SECONDS);

  @Inject
  public DensityTileRenderer(DataCubeIo<DensityTile> cubeIo) {
    this.cubeIo = cubeIo;
  }

  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    resp.setHeader("Content-Type", "image/png");
    try {
      Optional<DensityTile> tile = getTile(req);
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

  private int extractInt(HttpServletRequest req, String key) throws IllegalArgumentException {
    if (req.getParameter(key) != null) {
      try {
        return Integer.parseInt(req.getParameter(key));
      } catch (NumberFormatException e) {
        throw new IllegalArgumentException("Parameter [" + key + "] is invalid.  Supplied: " + req.getParameter(key));
      }
    }
    throw new IllegalArgumentException("Parameter [" + key + "] is required");
  }

  private TileContentType extractType(HttpServletRequest req) throws IllegalArgumentException {
    try {
      return TileContentType.valueOf(req.getParameter(REQ_TYPE));
    } catch (Exception e) {
      throw new IllegalArgumentException("Parameter [" + REQ_TYPE + "] is invalid.  Supplied: " + req.getParameter(REQ_TYPE));
    }
  }

  /**
   * Inspects the request, determines the cube address, and gets the tile data.
   * 
   * @throws IOException On cube communications
   * @throws
   */
  private Optional<DensityTile> getTile(HttpServletRequest req) throws IOException, RuntimeException {
    int x = extractInt(req, REQ_X);
    int y = extractInt(req, REQ_Y);
    int z = extractInt(req, REQ_Z);
    TileContentType type = extractType(req);
    String k = req.getParameter(REQ_KEY);
    if (k == null) {
      throw new IllegalArgumentException("Parameter [" + REQ_KEY + "] is required");
    }

    Optional<DensityTile> tile =
      lookup(new ReadBuilder(DensityCube.INSTANCE).at(DensityCube.TYPE, type).at(DensityCube.KEY, k).at(DensityCube.TILE_X, x)
        .at(DensityCube.TILE_Y, y).at(DensityCube.ZOOM, z).build());

    if (tile.isPresent() && tile.get().cells() != null) {
      LOG.debug("Tile request type[{}], key[{}], zoom[{}], x[{}], y[{}] has cells[{}]", new Object[] {type, k, z, x, y, tile.get().cells().size()});
    } else if (tile.isPresent()) {
      LOG.debug("Tile request type[{}], key[{}], zoom[{}], x[{}], y[{}] has cells[0]", new Object[] {type, k, z, x, y});
    } else {
      LOG.debug("Tile request type[{}], key[{}], zoom[{}], x[{}], y[{}] has no tile", new Object[] {type, k, z, x, y});
    }

    return tile;
  }

  // Looks up the tile from the cube
  private Optional<DensityTile> lookup(Address address) throws IOException {
    Optional<DensityTile> tile = null;
    final TimerContext context = readTimer.time();
    try {
      tile = cubeIo.get(address);

    } catch (InterruptedException e) {
      LOG.error("Unable to read from the cube", e);
      // Consider if this should create an error tile, rather than an empty one?
      tile = Optional.absent();
    } finally {
      context.stop();
    }
    return tile;
  }
}
