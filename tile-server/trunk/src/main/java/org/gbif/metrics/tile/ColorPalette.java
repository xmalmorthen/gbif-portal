package org.gbif.metrics.tile;


public interface ColorPalette {
  public byte alpha(int count);
  public byte red(int count);
  public byte green(int count);
  public byte blue(int count);
  
}
