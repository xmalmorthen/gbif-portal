<html>
<head>
  <title>Countries - GBIF</title>
  <content tag="extra_scripts">
    <script type="text/javascript" src="<@s.url value='/js/vendor/OpenLayers.js'/>"></script>
    <script type="text/javascript" src="<@s.url value='/js/openlayers_addons.js'/>"></script>
    <script type="text/javascript" src="<@s.url value='/js/Infowindow.js'/>"></script>
    <script type="text/javascript" src="<@s.url value='/js/full_map.js'/>"></script>
  </content>
</head>
<body class="dataset mapfull">

  <div id="map"></div>
  <a class="zoom_in" href="#zoom_in">zoom in</a>
  <a class="zoom_out" href="#zoom_out">zoom out</a>

  <article class="mapfull countries dataset">
    <header></header>
    <div class="content">
      <h1>Search for a country</h1>

      <form action="<@s.url value='/country/search'/>" method="GET">
      <span class="input_text">
        <input type="text" name="q" placeholder="Search countries..." class="focus"/>
      </span>
        <button type="submit" class="search_button"><span>Search</span></button>
      </form>
      <div class="results">
        <p class="explore">or <a href="">explore the world</a></p>
      </div>
    </div>
    <footer></footer>
  </article>

</body>
</html>
