<#import "/WEB-INF/macros/common.ftl" as common>
<html>
<head>
  <title>${dataset.title} - External dataset detail</title>
  <content tag="extra_scripts">
    <script type="text/javascript" src="<@s.url value='/js/vendor/OpenLayers.js'/>"></script>
    <script type="text/javascript" src="<@s.url value='/js/openlayers_addons.js'/>"></script>
    <script type="text/javascript" src="<@s.url value='/js/Infowindow.js'/>"></script>
    <script type="text/javascript" src="<@s.url value='/js/types_map.js'/>"></script>
    <script type="text/javascript" src="<@s.url value='/js/single_map.js'/>"></script>
  </content>
  <meta name="menu" content="datasets"/>
</head>
<body class="typesmap">

<#assign tab="info"/>
<#include "/WEB-INF/pages/dataset/infoband.ftl">

  <article>
    <header></header>
    <div class="content">

      <#include "/WEB-INF/pages/dataset/summary.ftl">

      <#include "/WEB-INF/pages/dataset/right_sidebar.ftl">

    </div>
    <footer></footer>
  </article>

<#include "/WEB-INF/pages/dataset/taxonomic_coverages.ftl">

  <article class="map">
    <header></header>
    <div id="map"></div>
    <a href="#zoom_in" class="zoom_in"></a>
    <a href="#zoom_out" class="zoom_out"></a>

    <div class="content">

      <div class="header">
        <div class="right"><h2>Boundaries</h2></div>
      </div>

      <div class="right">
        <h3>Geographic coverage</h3>

        <p>North America</p>

        <p class="maptype"><a href="#" title="points">points</a> | <a href="#" title="grid">grid</a> | <a href="#"
                                                                                                          title="polygons"
                                                                                                          class="selected">polygons</a>
        </p>

        <h3>Download</h3>
        <ul>
          <li class="download"><a href="#" title="One Degree cell density">One Degree cell density <abbr
                  title="Keyhole Markup Language">(KML)</abbr></a></li>
          <li class="download"><a href="#" title="Placemarks">Placemarks <abbr
                  title="Keyhole Markup Language">(KML)</abbr></a></li>
        </ul>
      </div>
    </div>
    <footer></footer>
  </article>

  <#include "/WEB-INF/pages/dataset/project.ftl">

  <#include "/WEB-INF/pages/dataset/methods.ftl">

  <#include "/WEB-INF/pages/dataset/legal.ftl">

</body>
</html>

