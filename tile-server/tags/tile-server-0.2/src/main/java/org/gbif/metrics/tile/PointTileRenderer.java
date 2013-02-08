package org.gbif.metrics.tile;

import org.gbif.metrics.cube.tile.io.LocationAvro;
import org.gbif.metrics.cube.tile.io.LocationsAvro;
import org.gbif.metrics.cube.tile.point.PointCube;
import org.gbif.metrics.cube.tile.point.PointTile;

import java.io.IOException;
import java.io.Writer;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.common.base.Optional;
import com.google.inject.Inject;
import com.google.inject.Singleton;
import com.urbanairship.datacube.DataCubeIo;

/**
 * A simple tile rendering servlet that sources it's data from a data cube pushing out GeoJSON.
 * THIS IS EXPERIMENTAL, AND IS NOT READY TO BE USED, BUT EXPECTED TO BE DEVELOPED
 * TODO: Investigate using Avro to the client instead of GeoJSON (see avro.js in this project)
 */
@Singleton
public class PointTileRenderer extends CubeTileRenderer<PointTile> {

  private static final long serialVersionUID = 6656758671362183399L;

  @Inject
  public PointTileRenderer(DataCubeIo<PointTile> cubeIo) {
    super(cubeIo);
  }

  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    resp.setHeader("Content-Type", "application/json");
    try {
      Optional<PointTile> tile = getTile(req, PointCube.INSTANCE);
      if (tile.isPresent()) {
        LocationsAvro la = tile.get().locations();
        if (la.getLocations() != null && la.getLocations().size() > 0) {
          Writer w = resp.getWriter();
          writeGeoJSON(la, w);
          // EXPERIMENTAL #1: writes a JSON array
          // writeArray(la, w);
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
  }
}
