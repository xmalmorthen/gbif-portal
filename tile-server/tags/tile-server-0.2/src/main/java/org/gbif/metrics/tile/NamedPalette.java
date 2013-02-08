package org.gbif.metrics.tile;

/**
 * Enumeration of fixed color palettes.
 */
public enum NamedPalette {
  blues(DensityColorPaletteFactory.BLUES), greens(DensityColorPaletteFactory.GREENS), greys(
    DensityColorPaletteFactory.GREYS), oranges(DensityColorPaletteFactory.ORANGES), purples(
    DensityColorPaletteFactory.PURPLES), reds(DensityColorPaletteFactory.REDS), yellows_reds(
    DensityColorPaletteFactory.YELLOWS_REDS);

  private final DensityColorPalette pallete;

  private NamedPalette(DensityColorPalette p) {
    this.pallete = p;
  }

  public DensityColorPalette getPalette() {
    return pallete;
  }
}
