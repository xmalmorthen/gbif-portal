<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js"></script>
        <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.5/jquery-ui.min.js"></script>
        <script type="text/javascript" src="<c:url value="/js/cas.js" />"></script>
  <footer>
    <div class="content">
      <ul>
        <li><h3>EXPLORE THE DATA</h3></li>
        <li><a href="/portal-web-dynamic/occurrence">Occurrences</a></li>
        <li><a href="/portal-web-dynamic/dataset">Datasets</a></li>
        <li><a href="/portal-web-dynamic/species">Species</a></li>
        <li><a href="/portal-web-dynamic/country">Countries</a></li>
        <li><a href="/portal-web-dynamic/member">GBIF Network</a></li>
        <li><a href="/portal-web-dynamic/theme">Themes</a></li>
      </ul>

      <ul>
        <li><h3>VIEW THE STATISTICS (not implemented)</h3></li>
        <li><a href="#">Global numbers</a></li>
        <li><a href="#">Taxonomic coverage</a></li>
        <li><a href="#">Providers</a></li>
        <li><a href="#">Countries</a></li>
      </ul>

      <ul>
        <li><h3>JOIN THE COMMUNITY</h3></li>
        <li><a href="/portal-web-dynamic/user/register/step1">Create a new account</a></li>
        <li><a href="/portal-web-dynamic/dataset/register/step1">Share your data</a></li>
        <li><a href="/portal-web-dynamic/terms">Terms and Conditions</a></li>
        <li><a href="/portal-web-dynamic/about">About</a></li>
      </ul>

      <ul class="first">
      </ul>

      <ul class="first">
        <li class="no_title">
          <p id="blog1title"></a>
            <span id="blog1data" class="date"></span></p>
          <p id="blog1body"></p>
        </li>
      </ul>

      <ul>
        <li class="no_title">
          <p id="blog2title">
            <span id="blog2date" class="date"></span></p>
          <p id="blog2body"></p>
        </li>
      </ul>

      <ul>
        <li class="no_title">
          <p id="blog3title">
            <span id="blog3date" class="date"></span></p>
          <p id="blog3body"></p>
        </li>
      </ul>

    </div>
  </footer>        
        
  <div class="copyright">
    <p>2011 &copy; GBIF. Data publishers retain all rights to data.</p>
  </div>

  <!-- JavaScript at the bottom for fast page loading -->
  <!-- scripts concatenated and minified via ant build script  -->
  <script type="text/javascript" src="/portal-web-dynamic/js/vendor/jquery-1.7.1.min.js"></script>
  <script type="text/javascript" src="/portal-web-dynamic/js/vendor/jquery-ui-1.8.17.min.js"></script>
  <script type="text/javascript" src="/portal-web-dynamic/js/vendor/autocomplete.js"></script>
  <script type="text/javascript" src="/portal-web-dynamic/js/vendor/jquery.uniform.min.js"></script>
  <script type="text/javascript" src="/portal-web-dynamic/js/vendor/mousewheel.js"></script>
  <script type="text/javascript" src="/portal-web-dynamic/js/vendor/jscrollpane.min.js"></script>
  <script type="text/javascript" src="/portal-web-dynamic/js/vendor/jquery-scrollTo-1.4.2-min.js"></script>
  <script type="text/javascript" src="/portal-web-dynamic/js/vendor/underscore-min.js"></script>
  <script type="text/javascript" src="/portal-web-dynamic/js/helpers.js"></script>
  <script type="text/javascript" src="/portal-web-dynamic/js/widgets.js"></script>
  <script type="text/javascript" src="/portal-web-dynamic/js/graphs.js"></script>
  <script type="text/javascript" src="/portal-web-dynamic/js/rss.js"></script>
  <script type="text/javascript" src="/portal-web-dynamic/js/app.js"></script>
  <script type="text/javascript" src="/portal-web-dynamic/js/vendor/raphael-min.js"></script>
  <script type="text/javascript" src="/portal-web-dynamic/js/vendor/resourcebundle.js"></script>
  <!-- end scripts-->

  <!--[if lt IE 7 ]>
  <script src="/portal-web-dynamic/js/libs/dd_belatedpng.js"></script>
  <script>DD_belatedPNG
          .fix("img, .png_bg"); // Fix any <img> or .png_bg bg-images. Also, please read goo.gl/mZiyb </script>
  <![endif]-->



</body>
</html>