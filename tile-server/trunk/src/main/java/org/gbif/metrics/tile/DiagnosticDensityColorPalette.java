package org.gbif.metrics.tile;


/**
 * A class that simply maps the count to a color.  Thus you can reverse engineer from the color in the PNG to the count. 
 */
public class DiagnosticDensityColorPalette implements ColorPalette {
  
  private DiagnosticDensityColorPalette() {
  };
  
  public static DiagnosticDensityColorPalette INSTANCE = new DiagnosticDensityColorPalette();
  
  @Override
  public byte alpha(int count) {
    return (byte) 0xff;
  }

  @Override
  public byte red(int count) {
    System.out.println("R " + count + " " + ((byte) (0xFF & count>>16)));
    return (byte) (0xFF & count>>16);
  }

  @Override
  public byte green(int count) {
    System.out.println("G " + count + " " + ((byte) (0xFF & count>>8)));
    return (byte) (0xFF & count>>8);
  }

  @Override
  public byte blue(int count) {
    System.out.println("B " + count + " " + ((byte) (0x0000FF & count)));
    return (byte) (0xFF & count);
  }
  
  public static void main(String[] args) {
    int count = 13264;
    System.out.println("B " + count + " " + ((0xFF & count)));
    System.out.println("G " + count + " " + ((0xFF & count>>8)));
    System.out.println("R " + count + " " + ((0xFF & count>>16)));
  }
}