package org.gbif.metrics.tile;

import org.gbif.metrics.cube.tile.density.DensityTile;

import java.io.ByteArrayOutputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.util.Map.Entry;
import java.util.zip.CRC32;
import java.util.zip.CheckedOutputStream;
import java.util.zip.Deflater;
import java.util.zip.DeflaterOutputStream;

import com.google.common.io.Closeables;

/**
 * A highly optimized PNG tile writer for a DensityTile.
 */
public class PNGWriter {

  static class Chunk extends DataOutputStream {

    final CRC32 crc;
    final ByteArrayOutputStream baos;

    Chunk(int chunkType) throws IOException {
      this(chunkType, new ByteArrayOutputStream(), new CRC32());
    }

    private Chunk(int chunkType, ByteArrayOutputStream baos, CRC32 crc) throws IOException {
      super(new CheckedOutputStream(baos, crc));
      this.crc = crc;
      this.baos = baos;

      writeInt(chunkType);
    }

    public void writeTo(DataOutputStream out) throws IOException {
      flush();
      out.writeInt(baos.size() - 4);
      baos.writeTo(out);
      out.writeInt((int) crc.getValue());
    }
  }

  public static final byte[] EMPTY_TILE;

  // see the PNG specification
  private static final byte[] SIGNATURE = {(byte) 137, 80, 78, 71, 13, 10, 26, 10};
  private static final int IHDR = 0x49484452;
  private static final int IDAT = 0x49444154;
  private static final int IEND = 0x49454E44;
  private static final byte COLOR_TRUECOLOR_ALPHA = 6;
  private static final byte COMPRESSION_DEFLATE = 0;
  private static final byte FILTER_NONE = 0;
  private static final byte INTERLACE_NONE = 0;
  // These arrays are always used together, so need to be indexed the same way.
  // 0xFFFABA00,
  // 0xFFFAB000,
  // 0xFFFC5D0E,
  // 0xFFFD3F16,
  // 0xFFFC3117,
  // 0xFFFE091F
  private static byte[] R = {(byte) 0xFA, (byte) 0xFA, (byte) 0xFC, (byte) 0xFD, (byte) 0xFC, (byte) 0xFE};
  private static byte[] G = {(byte) 0xBA, (byte) 0xB0, (byte) 0x5D, (byte) 0x3F, (byte) 0x31, (byte) 0x09};
  private static byte[] B = {(byte) 0x00, (byte) 0x00, (byte) 0x0E, (byte) 0x16, (byte) 0x17, (byte) 0x1F};

  // This has to come after the rest of the static initialized fields
  static {
    ByteArrayOutputStream baos = null;
    try {
      baos = new ByteArrayOutputStream();
      byte[] r = new byte[DensityTile.TILE_SIZE * DensityTile.TILE_SIZE];
      byte[] g = new byte[DensityTile.TILE_SIZE * DensityTile.TILE_SIZE];
      byte[] b = new byte[DensityTile.TILE_SIZE * DensityTile.TILE_SIZE];
      byte[] a = new byte[DensityTile.TILE_SIZE * DensityTile.TILE_SIZE];
      write(baos, r, g, b, a);
      EMPTY_TILE = baos.toByteArray();
    } catch (IOException e) {
      // This is not recoverable, and indicates catastrophe
      throw new RuntimeException("Unable to produce blank tile during initialization");
    } finally {
      Closeables.closeQuietly(baos);
    }
  }

  /**
   * Determines the color based on the density given.
   * We will consider making this configurable in the future.
   * 
   * @param count to use in lookup
   * @return the color index to use
   */
  private static int getColorIndex(int count) {
    int colorIndex = 0;
    if (10 < count && count <= 99) {
      colorIndex = 1;
    } else if (100 <= count && count <= 999) {
      colorIndex = 2;
    } else if (1000 <= count && count <= 9999) {
      colorIndex = 3;
    } else if (10000 <= count && count <= 99999) {
      colorIndex = 4;
    } else if (100000 <= count) {
      colorIndex = 5;
    }
    return colorIndex;
  }

  private static void paint(byte[] r, byte[] g, byte[] b, byte[] a, byte rc, byte gc, byte bc, byte alpha, int index) {
    if (index >= 0 && index < r.length) {
      r[index] = rc;
      g[index] = gc;
      b[index] = bc;
      a[index] = alpha;
    }
  }

  /**
   * Writes the tile to the stream as a PNG.
   */
  public static void write(DensityTile tile, OutputStream out) throws IOException {
    // don't waste time setting up PNG if no data
    if (tile != null && !tile.cells().isEmpty()) {

      // arrays for the RGB and alpha channels
      byte[] r = new byte[DensityTile.TILE_SIZE * DensityTile.TILE_SIZE];
      byte[] g = new byte[DensityTile.TILE_SIZE * DensityTile.TILE_SIZE];
      byte[] b = new byte[DensityTile.TILE_SIZE * DensityTile.TILE_SIZE];
      byte[] a = new byte[DensityTile.TILE_SIZE * DensityTile.TILE_SIZE];

      // paint the pixels for each cell in the tile
      int cellsPerRow = DensityTile.TILE_SIZE / tile.getClusterSize();
      for (Entry<Integer, Integer> e : tile.cells().entrySet()) {
        int cellId = e.getKey();
        int offsetX = tile.getClusterSize() * (cellId % cellsPerRow);
        int offsetY = tile.getClusterSize() * (cellId / cellsPerRow);

        // determine the starting draw position
        int cellStart = (offsetY * DensityTile.TILE_SIZE) + (offsetX);
        int colorIndex = getColorIndex(e.getValue());

        // for the number of rows in the cell
        for (int i = 0; i < tile.getClusterSize(); i++) {
          // paint the cells pixel by pixel
          for (int j = cellStart; j < cellStart + tile.getClusterSize(); j++) {
            paint(r, g, b, a, R[colorIndex], G[colorIndex], B[colorIndex], (byte) 0xFF, j);
          }
          cellStart += DensityTile.TILE_SIZE;
        }
      }

      write(out, r, g, b, a);
    } else {
      // always return a valid image
      out.write(EMPTY_TILE);
    }
  }

  private static void write(OutputStream os, byte[] r, byte[] g, byte[] b, byte[] a) throws IOException {
    DataOutputStream dos = null;
    DeflaterOutputStream dfos = null;
    Chunk cIHDR = null;
    Chunk cIEND = null;
    try {
      dos = new DataOutputStream(os);
      dos.write(SIGNATURE);

      cIHDR = new Chunk(IHDR);
      cIHDR.writeInt(DensityTile.TILE_SIZE);
      cIHDR.writeInt(DensityTile.TILE_SIZE);
      cIHDR.writeByte(8); // 8 bit per component
      cIHDR.writeByte(COLOR_TRUECOLOR_ALPHA);
      cIHDR.writeByte(COMPRESSION_DEFLATE);
      cIHDR.writeByte(FILTER_NONE);
      cIHDR.writeByte(INTERLACE_NONE);
      cIHDR.writeTo(dos);

      Chunk cIDAT = new Chunk(IDAT);
      dfos = new DeflaterOutputStream(cIDAT, new Deflater(Deflater.BEST_COMPRESSION));

      int channels = 4;
      int lineLen = DensityTile.TILE_SIZE * channels;
      byte[] lineOut = new byte[lineLen];

      for (int line = 0; line < DensityTile.TILE_SIZE; line++) {
        for (int p = 0; p < DensityTile.TILE_SIZE; p++) {
          lineOut[p * 4 + 0] = r[(line * DensityTile.TILE_SIZE) + p]; // R
          lineOut[p * 4 + 1] = g[(line * DensityTile.TILE_SIZE) + p]; // G
          lineOut[p * 4 + 2] = b[(line * DensityTile.TILE_SIZE) + p]; // B
          lineOut[p * 4 + 3] = a[(line * DensityTile.TILE_SIZE) + p]; // transparency
        }

        dfos.write(FILTER_NONE);
        dfos.write(lineOut);
      }

      dfos.finish();
      cIDAT.writeTo(dos);

      cIEND = new Chunk(IEND);

      cIEND.writeTo(dos);
      dos.flush();

    } finally {
      Closeables.closeQuietly(cIHDR);
      Closeables.closeQuietly(cIEND);
      Closeables.closeQuietly(dfos);
      Closeables.closeQuietly(dos);
    }
  }
}