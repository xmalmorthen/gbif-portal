/**
 * 
 */
package org.gbif.metrics.tile;

import org.gbif.metrics.cube.tile.density.DensityCube;
import org.gbif.metrics.cube.tile.density.DensityTile;
import org.gbif.metrics.cube.tile.io.TileContentType;

import java.io.IOException;
import java.util.Set;
import java.util.concurrent.TimeUnit;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;

import com.google.common.base.Optional;
import com.google.common.base.Preconditions;
import com.google.common.collect.ImmutableSet;
import com.urbanairship.datacube.Address;
import com.urbanairship.datacube.DataCube;
import com.urbanairship.datacube.DataCubeIo;
import com.urbanairship.datacube.ReadBuilder;
import com.yammer.metrics.Metrics;
import com.yammer.metrics.core.Timer;
import com.yammer.metrics.core.TimerContext;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


/**
 * Base class to simplify looking up tiles from the cube.
 */
@SuppressWarnings("serial")
public abstract class CubeTileRenderer extends HttpServlet {
  
  private static final Logger LOG = LoggerFactory.getLogger(CubeTileRenderer.class);
  public static final String REQ_TYPE = "type";
  public static final String REQ_KEY = "key";
  public static final String REQ_Z = "z";
  public static final String REQ_X = "x";
  public static final String REQ_Y = "y";
  public static final String REQ_RESOLUTION = "resolution";

  private final DataCubeIo<DensityTile> cubeIo;

  // allow monitoring of cube lookup, rendering speed and the throughput per second
  private final Timer readTimer = Metrics.newTimer(DensityTileRenderer.class, "readDuration", TimeUnit.MILLISECONDS,
    TimeUnit.SECONDS);

  protected CubeTileRenderer(DataCubeIo<DensityTile> cubeIo) {
    this.cubeIo = cubeIo;
  }

  protected Integer extractInt(HttpServletRequest req, String key, boolean required) throws IllegalArgumentException {
    if (req.getParameter(key) != null) {
      try {
        return Integer.parseInt(req.getParameter(key));
      } catch (NumberFormatException e) {
        throw new IllegalArgumentException("Parameter [" + key + "] is invalid.  Supplied: " + req.getParameter(key));
      }
    }
    if (required)
      throw new IllegalArgumentException("Parameter [" + key + "] is required");
    return null;
  }
  
  protected Float extractFloat(HttpServletRequest req, String key, boolean required) throws IllegalArgumentException {
    if (req.getParameter(key) != null) {
      try {
        return Float.parseFloat(req.getParameter(key));
      } catch (NumberFormatException e) {
        throw new IllegalArgumentException("Parameter [" + key + "] is invalid.  Supplied: " + req.getParameter(key));
      }
    }
    if (required)
      throw new IllegalArgumentException("Parameter [" + key + "] is required");
    return null;
  }

  protected TileContentType extractType(HttpServletRequest req) throws IllegalArgumentException {
    try {
      return TileContentType.valueOf(req.getParameter(REQ_TYPE));
    } catch (Exception e) {
      throw new IllegalArgumentException("Parameter [" + REQ_TYPE + "] is invalid.  Supplied: "
        + req.getParameter(REQ_TYPE));
    }
  }

  protected Optional<DensityTile> getTile(HttpServletRequest req, DataCube<DensityTile> cube) throws IOException, RuntimeException {
    int x = extractInt(req, REQ_X, true);
    int y = extractInt(req, REQ_Y, true);
    int z = extractInt(req, REQ_Z, true);
    Integer resolution = extractInt(req, REQ_RESOLUTION, false); 
    
    TileContentType type = extractType(req);
    String k = req.getParameter(REQ_KEY);
    if (k == null) {
      throw new IllegalArgumentException("Parameter [" + REQ_KEY + "] is required");
    }

    Optional<DensityTile> tile =
      lookup(new ReadBuilder(cube).at(DensityCube.TYPE, type).at(DensityCube.KEY, k).at(DensityCube.TILE_X, x)
        .at(DensityCube.TILE_Y, y).at(DensityCube.ZOOM, z).build());

    if (tile.isPresent()) {
      LOG.debug("Tile request type[{}], key[{}], zoom[{}], x[{}], y[{}] has a tile", new Object[] {type, k, z, x, y});
    } else {
      LOG.debug("Tile request type[{}], key[{}], zoom[{}], x[{}], y[{}] has no tile", new Object[] {type, k, z, x, y});
    }
    
    if (tile.isPresent() && resolution!=null) {
      LOG.debug("Downscaling tile to resolution[{}]", resolution);
      return Optional.of(tile.get().downscale(resolution));
    } else {
      return tile;  
    }    
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
