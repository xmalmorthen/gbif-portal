<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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


        <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js"></script>
        <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.5/jquery-ui.min.js"></script>
        <script type="text/javascript" src="<c:url value="/js/cas.js" />"></script>
    </body>
</html>
