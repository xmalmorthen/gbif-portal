package org.gbif.imgcache;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.net.URL;
import java.net.URLEncoder;
import javax.inject.Inject;

import com.google.common.io.ByteStreams;
import com.google.common.io.Closeables;
import com.google.inject.name.Named;
import net.coobird.thumbnailator.Thumbnails;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class ImageCacheService {
  private final Logger LOG = LoggerFactory.getLogger(ImageCacheService.class);

  private final File repo;
  private final String ENC = "UTF8";
  private final String format = "png";

  @Inject
  public ImageCacheService(@Named("imgcache.repository") String repository) {
    repo = new File(repository);
    LOG.info("Use image repository " + repo.getAbsolutePath());
    if (!repo.exists() && !repo.isDirectory()) {
      throw new IllegalStateException("imgcache.repository needs to be an existing, writable directory: " + repo.getAbsolutePath());
    }
  }

  public CachedImage get(URL url, ImageSize size) throws IOException {
    File imgFile = location(url, size);
    if (!imgFile.exists()) {
      cacheImage(url);
    }
    //TODO: store mime type or deduct from image/file suffix
    return new CachedImage(url, size, "image/" + format, imgFile);
  }

  private File location(URL url, ImageSize size) throws IOException {
    String suffix;
    if (size == ImageSize.ORIGINAL){
      suffix = "";
    } else {
      suffix = "-" + size.name().charAt(0) + "." + format;
    }

    try {
      return new File(repo, URLEncoder.encode(url.toString() + suffix, ENC));

    } catch (UnsupportedEncodingException e) {
      throw new IOException("UnsupportedEncodingException", e);
    }
  }

  private void cacheImage(URL url) throws IOException {
    // download original
    LOG.info("Caching image " + url);
    File origImg = location(url, ImageSize.ORIGINAL);
    OutputStream out = null;
    InputStream source = null;

    try {
      out = new FileOutputStream(origImg);
      source = url.openStream();
      ByteStreams.copy(source, out);

    } finally {
      Closeables.closeQuietly(out);
      Closeables.closeQuietly(source);
    }

    // now produce a thumbnail from the original
    produceImage(url, ImageSize.THUMBNAIL);
    produceImage(url, ImageSize.SMALL);
    produceImage(url, ImageSize.MIDSIZE);
  }

  private void produceImage(URL url, ImageSize size) throws IOException {
    File orig = location(url, ImageSize.ORIGINAL);
    File calc = location(url, size);
    Thumbnails.Builder<File> thumb = Thumbnails.of(orig)
            .size(size.width, size.height)
            .outputFormat(format);

    // make sure thumbnails have the same square size
    if (ImageSize.THUMBNAIL == size) {
      thumb.keepAspectRatio(false);
    }

    // process
    thumb.toFile(calc);
  }
}
