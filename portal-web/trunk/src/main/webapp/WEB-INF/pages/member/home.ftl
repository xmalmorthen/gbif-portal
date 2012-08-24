<html>
<head>
  <title>Members - GBIF</title>
  <content tag="extra_scripts">
    <script type="text/javascript" src="<@s.url value='/js/vendor/OpenLayers.js'/>"></script>
    <script type="text/javascript" src="<@s.url value='/js/openlayers_addons.js'/>"></script>
    <script type="text/javascript" src="<@s.url value='/js/Infowindow.js'/>"></script>
    <script type="text/javascript" src="<@s.url value='/js/full_map.js'/>"></script>
  </content>
</head>
<body class="dataset mapfull">

  <a class="zoom_in" href="#zoom_in">zoom in</a>
  <a class="zoom_out" href="#zoom_out">zoom out</a>
  <div id="map"></div>

  <article class="mapfull cluster dataset">
    <header></header>
    <div class="content">
      <h1>Search GBIF Network members</h1>

      <form action="<@s.url value='/member/search'/>">
        <span class="input_text">
          <input type="text" name="q" placeholder="Search names,countries..." class="focus"/>
        </span>
        <button type="submit" class="search_button"><span>Search</span></button>
      </form>
      <div class="results">
        <ul>
          <li><a href="<@s.url value='/member/search?q=fake'/>" title="">121</a>participant</li>
          <li><a href="<@s.url value='/member/search?q=fake'/>" title="">654</a>publishers</li>
          <li><a href="<@s.url value='/member/search?q=fake'/>" title="">129</a>technical</li>
          <li class="last"><a href="<@s.url value='/member/search?q=fake'/>" title="">34</a>networks</li>
        </ul>
      </div>
      <p class="explore">...or <a href="#explore">explore the map</a></p>
    </div>
    <footer></footer>
  </article>

</body>
</html>
