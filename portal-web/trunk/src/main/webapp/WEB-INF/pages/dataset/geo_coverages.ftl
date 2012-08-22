<#-- Removed as needs to be replaced by Leaflet -->
<#-- content tag="extra_scripts">
  <link rel="stylesheet" href="<@s.url value='/css/google.css'/>"/>
  <script type="text/javascript" src="http://maps.google.com/maps/api/js?v=3.2&amp;sensor=true"></script>
  <script type="text/javascript" src="<@s.url value='/js/vendor/OpenLayers.js'/>"></script>
  <script type="text/javascript" src="<@s.url value='/js/openlayers_addons.js'/>"></script>
  <script type="text/javascript" src="<@s.url value='/js/Infowindow.js'/>"></script>
  <script type="text/javascript" src="<@s.url value='/js/types_map.js'/>"></script>
-->
  <!-- needs to be well known text: http://en.wikipedia.org/wiki/Well-known_text#Geometric_Objects -->
  <script type="text/javascript">
    var map_features = new Array();
    <#list dataset.geographicCoverages as geo>
      <#if geo.boundingBox?has_content && !(geo.boundingBox.isGlobalCoverage())>
        <#if geo.boundingBox??>map_features.push("${geo.toWellKnownText()}");</#if>
      </#if>
    </#list>
  </script>
</content-->


<!-- don't display the map if it contains a bounding box representing global coverage-->
<#list dataset.geographicCoverages as geo>
  <#if geo.boundingBox?has_content && (geo.boundingBox.isGlobalCoverage())>
  <article>
    <header></header>
    <div class="content">

      <div class="header">
        <div class="left"><h2>Geographic Coverage</h2></div>
      </div>

      <#if (dataset.geographicCoverages?size>0) >
        <div class="left">

          <h3>Coverage</h3>

          <p>Global</p>

          <#if geo.description?has_content>
            <#assign extended_desc_len = 2000>

            <h3>Description</h3>

            <p>${common.limit(geo.description!"",extended_desc_len)}
            <#if (geo.description?length>extended_desc_len) ><@common.popup message=geo.description title="Description"/></#if>
            </p>
          </#if>
        </div>
      </#if>
    </div>
    <footer></footer>
  </article>
  <#else>
  <article class="map">
    <header></header>

    <div id="map" datasetid="${dataset.key}"></div>

    <a href="#zoom_in" class="zoom_in"></a>
    <a href="#zoom_out" class="zoom_out"></a>

    <div class="content">
      <div class="header">
        <div class="right"><h2>Geographic Coverage</h2></div>
      </div>

      <div class="left">
    <div class="projection placeholder_temp">
      <a class="projection" href="#projection">projection</a>
      <span>
        <p>PROJECTION</p>
        <ul>
          <li><a class="selected" href="#mercator">Mercator</a></li>
          <li class="disabled"><a href="#robinson">Robinson</a></li>
        </ul>
      </span>
    </div>
    </div>


      <#if (dataset.geographicCoverages?size>0) >
        <div class="right">
          <#list dataset.geographicCoverages as geo>
            <#if geo.description?has_content>
              <#assign short_desc_len = 100>

              <h3>Description</h3>

              <p>${common.limit(geo.description!"",short_desc_len)}
            <#if (geo.description?length>short_desc_len) ><@common.popup message=geo.description title="Description"/></#if>
              </p>
            </#if>
          </#list>
        </div>
      </#if>

      <div class="right">
        <h3>Visualize</h3>

        <p class="maptype">
          <a class="placeholder_temp" href="#" title="occurrence">points</a>
          | <a class="placeholder_temp" href="#" title="grid">grid</a>
          | <a href="#" title="polygons" class="selected">polygons</a>
        </p>

        <h3>Download</h3>
        <ul class="placeholder_temp">
          <li class="download"><a href="#" title="One Degree cell density">One Degree cell density <abbr
                  title="Keyhole Markup Language">(KML)</abbr></a></li>
          <li class="download"><a href="#" title="Placemarks">Placemarks <abbr
                  title="Keyhole Markup Language">(KML)</abbr></a></li>
        </ul>
      </div>

    </div>

    <footer></footer>
  </article>
  </#if>
</#list>

