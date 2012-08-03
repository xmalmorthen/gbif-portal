package org.gbif.metrics.tile;

import org.gbif.metrics.cube.tile.io.LocationAvro;
import org.gbif.metrics.cube.tile.io.LocationsAvro;
import org.gbif.metrics.cube.tile.point.PointCube;
import org.gbif.metrics.cube.tile.point.PointTile;

import java.io.IOException;
import java.io.Writer;
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
import com.yammer.metrics.core.Timer;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * A simple tile rendering servlet that sources it's data from a data cube pushing out GeoJSON.
 * TODO: Investigate using Avro to the client
 */
@Singleton
public class PointTileData extends HttpServlet {

  // for the types of tiles clients can request
  private static enum TILE_TYPE {
    taxon, dataset
  }

  private static final Logger LOG = LoggerFactory.getLogger(PointTileData.class);
  private static final String REQ_TYPE = "type";
  private static final String REQ_KEY = "key";
  private static final String REQ_Z = "z";
  private static final String REQ_X = "x";
  private static final String REQ_Y = "y";

  private static final long serialVersionUID = 8681716273998041332L;
  private final DataCubeIo<PointTile> cubeIo;
  // allow monitoring of cube lookup and rendering
  private final Timer readTimer;
  private final Timer renderTimer;

  @Inject
  public PointTileData(DataCubeIo<PointTile> cubeIo) {
    this.cubeIo = cubeIo;

    // TODO: will this push to Ganglia?
    readTimer = Metrics.newTimer(PointTileData.class, "readDuration", TimeUnit.MILLISECONDS, TimeUnit.SECONDS);
    renderTimer = Metrics.newTimer(PointTileData.class, "renderDuration", TimeUnit.MILLISECONDS, TimeUnit.SECONDS);
  }

  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    resp.setHeader("Content-Type", "application/json");
    try {
      Optional<PointTile> tile = getTile(req);
      if (tile.isPresent()) {
        LocationsAvro la = tile.get().locations();
        if (la.getLocations() != null && la.getLocations().size() > 0) {
          long before = System.currentTimeMillis();
          // TODO tidy up

          Writer w = resp.getWriter();
          writeGeoJSON(la, w);
          // writeArray(la, w);

          long duration = System.currentTimeMillis() - before;
          renderTimer.update(duration, TimeUnit.MILLISECONDS);
        } else {
          // Nothing found ya'll
          resp.setStatus(HttpServletResponse.SC_NO_CONTENT);
        }
      } else {
        // Nothing found ya'll
        resp.setStatus(HttpServletResponse.SC_NO_CONTENT);
      }
    } catch (IllegalArgumentException e) {
      // If we couldn't get the content from the request
      resp.sendError(HttpServletResponse.SC_BAD_REQUEST, e.getMessage());
      // resp.setStatus(HttpServletResponse.SC_NO_CONTENT);
    } catch (Exception e) {
      // We are unable to get or render the tile
      // resp.sendError(HttpServletResponse.SC_SERVICE_UNAVAILABLE, "Tile server is out of action, please try later");
      resp.setStatus(HttpServletResponse.SC_NO_CONTENT);
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

  private TILE_TYPE extractType(HttpServletRequest req) throws IllegalArgumentException {
    try {
      return TILE_TYPE.valueOf(req.getParameter(REQ_TYPE));
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
  private Optional<PointTile> getTile(HttpServletRequest req) throws IOException, RuntimeException {
    int x = extractInt(req, REQ_X);
    int y = extractInt(req, REQ_Y);
    int z = extractInt(req, REQ_Z);
    TILE_TYPE type = extractType(req);

    // based on the type, determine the correct address for the tile
    // note some keys are strings (countries) and others are int, hence why this is needed.
    Optional<PointTile> tile = null;
    switch (type) {
      case taxon:
        int key = extractInt(req, REQ_KEY);
        LOG.debug("Tile request type[{}], key[{}], zoom[{}], x[{}], y[{}]", new Object[] {type, key, z, x, y});
        tile =
          lookup(new ReadBuilder(PointCube.INSTANCE).at(PointCube.TAXON_ID, key).at(PointCube.TILE_X, x).at(PointCube.TILE_Y, y)
            .at(PointCube.ZOOM, z).build());
        break;

      default:
        tile = Optional.absent();
        break;
    }
    return tile;
  }

  // Looks up the tile from the cube
  private Optional<PointTile> lookup(Address address) throws IOException {
    Optional<PointTile> tile = null;
    try {
      long before = System.currentTimeMillis();
      tile = cubeIo.get(address);
      long duration = System.currentTimeMillis() - before;
      readTimer.update(duration, TimeUnit.MILLISECONDS);

    } catch (InterruptedException e) {
      e.printStackTrace();
      // TODO: Consider if this should create an error tile?
      tile = Optional.absent();
    }
    return tile;
  }

  private void writeArray(LocationsAvro la, Writer w) throws IOException {
    w.write("{\"points\":[");
    int count = 0;
    for (LocationAvro l : la.getLocations()) {
      if (count++ > 0) {
        w.write(",");
      }
      w.write("[" + l.getLng() + "," + l.getLat() + "]");

    }
    w.write("]}");
  }

  private void writeGeoJSON(LocationsAvro la, Writer w) throws IOException {
    w.write("{\"type\":\"FeatureCollection\",\"features\":[");
    int count = 0;

    for (int i = 0; i < 3; i++) {

      for (LocationAvro l : la.getLocations()) {
        if (count++ > 0) {
          w.write(",");
        }
        w.write("{\"type\":\"Feature\",\"properties\":{\"id\":");
        w.write(String.valueOf(l.getId()));
        w.write(",\"type\":\"occurrence\"},\"geometry\":{\"type\":\"Point\", \"coordinates\": [" + l.getLng() + "," + l.getLat() + "]}}");


      }
    }
    w.write("]}");
    LOG.info("Count: " + count);
  }
}
