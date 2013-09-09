package org.gbif.imgcache;

import java.io.IOException;
import java.net.URL;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.common.base.Preconditions;
import com.google.common.io.ByteStreams;
import com.google.inject.Inject;
import com.google.inject.Singleton;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
@Singleton
public class ImageCacheServlet extends HttpServlet {

  private final Logger LOG = LoggerFactory.getLogger(ImageCacheServlet.class);
  private static final long serialVersionUID = 8681716273998041332L;
  private ImageCacheService cache;

  @Inject
  public ImageCacheServlet(ImageCacheService cache) {
    this.cache = cache;
  }

  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    final ImageSize size = ImageSize.fromString(req.getParameter("size"));

    URL url = null;
    try {
      url = new URL(req.getParameter("url"));
      Preconditions.checkNotNull(url);
    } catch (Exception e) {
      LOG.warn("Invalid image url requested: " + url);
      resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Please provide a valid image url parameter");
    }

    try {
      CachedImage img = cache.get(url, size);
      resp.setHeader("Content-Type", img.getMimeType());
      ByteStreams.copy(img, resp.getOutputStream());

    } catch (IOException e) {
      resp.sendError(HttpServletResponse.SC_NOT_FOUND, "No image found for url " + url);

    } finally {
      resp.flushBuffer();
    }
  }
}
