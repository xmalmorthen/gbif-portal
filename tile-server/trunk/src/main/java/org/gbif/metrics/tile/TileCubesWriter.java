package org.gbif.metrics.tile;

import org.gbif.metrics.cube.tile.density.DensityTile;
import org.gbif.metrics.cube.tile.density.Layer;

import java.io.IOException;
import java.io.OutputStream;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import com.google.common.collect.Lists;

import com.google.common.annotations.VisibleForTesting;

import com.google.common.collect.Maps;
import org.codehaus.jackson.JsonGenerationException;
import org.codehaus.jackson.map.JsonMappingException;
import org.codehaus.jackson.map.ObjectMapper;
import org.codehaus.jackson.node.ArrayNode;
import org.codehaus.jackson.node.ObjectNode;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;



/**
 * Writes the data in TileCubes format suitable for the Vizzuality developed Torque library for client side rendering. 
 *  @see <a href="https://github.com/andrewxhill/tilecubes/blob/master/1.0/spec.md">https://github.com/andrewxhill/tilecubes/blob/master/1.0/spec.md</a>
 */
public class TileCubesWriter {
  private final static Logger LOG = LoggerFactory.getLogger(TileCubesWriter.class);
  private final static ObjectMapper MAPPER = new ObjectMapper();
  
  /**
   * Renders the tile to the outputstream as json format.
   * Does not flush or close the stream.
   */
  public static void jsonNotation(DensityTile tile, OutputStream out) throws JsonGenerationException, JsonMappingException, IOException {
    // A map keyed on the cell, holding the count per layer at the cell
    Map<Integer, Map<Layer,Integer>> tileCube = Maps.newHashMap();
    
    // rewrite the density tile into a tilecubes friendly structure, which is keyed on the pixel (cell)
    for( Entry<Layer, Map<Integer, Integer>> layers : tile.layers().entrySet()) {
      
      for (Entry<Integer,Integer> dtCell : layers.getValue().entrySet()) {
        Map<Layer, Integer> tileCubeCell = tileCube.get(dtCell.getKey());
        // ensure exists
        if (tileCubeCell == null) {
          tileCubeCell = Maps.newHashMap();
          tileCube.put(dtCell.getKey(), tileCubeCell);
        }
        tileCubeCell.put(layers.getKey(), dtCell.getValue());
      }
    }
    LOG.debug("Request tile has {} cells", tileCube.size());
    
    // build the JSON
    ObjectNode tileCubesNode = MAPPER.createObjectNode();
    tileCubesNode.put("pixel_size", tile.getClusterSize());
    tileCubesNode.put("total_rows", tileCube.size());
    
    ArrayNode dimensionsNode = tileCubesNode.putArray("dimension_mapping");
    for (Layer l : Layer.values()) {
      ObjectNode dimensionNode = dimensionsNode.addObject();
      dimensionNode.put(l.toString(), l.ordinal());
    }
    
    ArrayNode rowsNode = tileCubesNode.putArray("rows");
    for (Entry<Integer, Map<Layer,Integer>> pixel : tileCube.entrySet()) {
      ObjectNode row = rowsNode.addObject();
      ArrayNode dataNode = row.putArray("data");
      dataNode.add(fromCellId(pixel.getKey(), tile.getClusterSize())[0]); // x
      dataNode.add(fromCellId(pixel.getKey(), tile.getClusterSize())[1]); // y
      dataNode.add(pixel.getValue().size()); // number of kvps to expect
      
      // keep the order of what we added!
      List<Layer> addedKeys = Lists.newArrayList();
      for (Layer l : pixel.getValue().keySet()) {
        dataNode.add(l.ordinal()); // the key
        addedKeys.add(l); 
      }
      for (Layer l : addedKeys) {
        dataNode.add(pixel.getValue().get(l));  // the value
      }
            
    }    
    MAPPER.writeValue(out, tileCubesNode);
  }
  
  /**
   * Based on the cluster size, generates the x,y offset from the cell id from the offset X and Y within
   * the tile. Response is x and then y in the format required for TileCubes.  Note that the density tile
   * ranges go from 0 - TILE_SIZE, but the Tilecubes addressing only goes from 0 - (TILE_SIZE / clusterSize).
   */
  @VisibleForTesting
  static int[] fromCellId(int cellId, int clusterSize) {
    int tpc = DensityTile.TILE_SIZE / clusterSize;
    
    return new int[]{
      cellId % tpc, // X
      (int) cellId / tpc
    };
  }  
}
