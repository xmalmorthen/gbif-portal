package org.gbif.imgcache;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.net.URL;
import java.net.URLEncoder;

import javax.imageio.ImageIO;
import javax.inject.Inject;

import com.google.common.base.Preconditions;
import com.google.common.io.ByteStreams;
import com.google.common.io.Closer;
import com.google.inject.name.Named;
import net.coobird.thumbnailator.Thumbnails;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class ImageCacheService {

  private final Logger LOG = LoggerFactory.getLogger(ImageCacheService.class);

  private final File repo;
  private static final String ENC = "UTF8";
  private static final String PNG_FMT = "png";
  private static final String MIME_TYPE = "image/" + PNG_FMT;
  private static final String DFT_FILENAME = "image";

  @Inject
  public ImageCacheService(@Named("imgcache.repository") String repository) {
    repo = new File(repository);
    LOG.info("Use image repository " + repo.getAbsolutePath());
    if (!repo.exists() && !repo.isDirectory()) {
      throw new IllegalStateException("imgcache.repository needs to be an existing, writable directory: "
        + repo.getAbsolutePath());
    }
  }

  public CachedImage get(URL url, ImageSize size) throws IOException {
    Preconditions.checkNotNull(url);

    File imgFile = location(url, size);
    if (!imgFile.exists()) {
      cacheImage(url);
    }
    // TODO: store mime type or deduct from image/file suffix
    return new CachedImage(url, size, MIME_TYPE, imgFile);
  }

  private void cacheImage(URL url) throws IOException {
    // download original
    LOG.info("Caching image " + url);
    File origImg = location(url, ImageSize.ORIGINAL);
    // create parent folder that is unque for the original image
    origImg.getParentFile().mkdir();

    OutputStream out = null;
    InputStream source = null;
    Closer closer = Closer.create();

    try {
      out = new FileOutputStream(origImg);
      closer.register(out);
      source = url.openStream();
      closer.register(source);
      ByteStreams.copy(source, out);
    } finally {
      closer.close();
    }

    // now produce a thumbnail from the original
    produceImage(url, ImageSize.THUMBNAIL);
    produceImage(url, ImageSize.SMALL);
    produceImage(url, ImageSize.MIDSIZE);
    produceImage(url, ImageSize.LARGE);
  }

  private File location(URL url, ImageSize size) throws IOException {
    File folder;
    try {
      folder = new File(repo, URLEncoder.encode(url.toString(), ENC));
    } catch (UnsupportedEncodingException e) {
      throw new IOException("UnsupportedEncodingException", e);
    }

    // try to get some sensible filename - optional
    String fileName;
    try {
      fileName = new File(url.getPath()).getName();
    } catch (Exception e) {
      fileName = DFT_FILENAME;
    }

    String suffix;
    if (size == ImageSize.ORIGINAL) {
      suffix = "";
    } else {
      suffix = '-' + size.name().charAt(0) + '.' + PNG_FMT;
    }

    return new File(folder, fileName + suffix);
  }

  private void produceImage(URL url, ImageSize size) throws IOException {
    File orig = location(url, ImageSize.ORIGINAL);
    File calc = location(url, size);
    BufferedImage bufferedImage = ImageIO.read(orig);
    Thumbnails.Builder<BufferedImage> thumb = Thumbnails.of(bufferedImage)
      .size(size.width, size.height)
      .outputFormat(PNG_FMT);

    // make sure thumbnails have the same square size
    if (ImageSize.THUMBNAIL == size) {
      thumb.keepAspectRatio(false);
    }

    // process
    thumb.toFile(calc);
    bufferedImage.flush();
  }
}
