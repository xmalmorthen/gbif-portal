<#import "/WEB-INF/macros/common.ftl" as common>
<html>
<head>
  <title>${dataset.title} - Checklist dataset detail</title>
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

<article>
  <header></header>
  <div class="content">

    <div class="header">
      <div class="left"><h2>Checklist preview</h2></div>
    </div>

    <div class="left">
      <ul class="three_cols">
        <li><a href="<@s.url value='/species/42/name_usage'/>" class="placeholder_temp">Araneae<a/></li>
        <li><a href="<@s.url value='/species/42/name_usage'/>" class="placeholder_temp">Opiliones</a></li>
        <li><a href="<@s.url value='/species/42/name_usage'/>" class="placeholder_temp">Parasitiformes</a></li>
        <li><a href="<@s.url value='/species/42/name_usage'/>" class="placeholder_temp">Pseudoscorpionida</a></li>
        <li><a href="<@s.url value='/species/42/name_usage'/>" class="placeholder_temp">Sarcoptiformes</a></li>
        <li><a href="<@s.url value='/species/42/name_usage'/>" class="placeholder_temp">Scorpiones</a></li>
        <li><a href="<@s.url value='/species/42/name_usage'/>" class="placeholder_temp">Trombidiformes</a></li>
        <li><a href="<@s.url value='/species/42/name_usage'/>" class="placeholder_temp">Pseudoscorpionida</a></li>
        <li><a href="<@s.url value='/species/42/name_usage'/>" class="placeholder_temp">Sarcoptiformes</a></li>
        <li><a href="<@s.url value='/species/42/name_usage'/>" class="placeholder_temp">Scorpiones</a></li>
      </ul>
      <ul class="three_cols">
        <li><a href="<@s.url value='/species/42/name_usage'/>" class="placeholder_temp">Araneae<a/></li>
        <li><a href="<@s.url value='/species/42/name_usage'/>" class="placeholder_temp">Opiliones</a></li>
        <li><a href="<@s.url value='/species/42/name_usage'/>" class="placeholder_temp">Parasitiformes</a></li>
        <li><a href="<@s.url value='/species/42/name_usage'/>" class="placeholder_temp">Pseudoscorpionida</a></li>
        <li><a href="<@s.url value='/species/42/name_usage'/>" class="placeholder_temp">Sarcoptiformes</a></li>
        <li><a href="<@s.url value='/species/42/name_usage'/>" class="placeholder_temp">Scorpiones</a></li>
        <li><a href="<@s.url value='/species/42/name_usage'/>" class="placeholder_temp">Trombidiformes</a></li>
        <li><a href="<@s.url value='/species/42/name_usage'/>" class="placeholder_temp">Pseudoscorpionida</a></li>
        <li><a href="<@s.url value='/species/42/name_usage'/>" class="placeholder_temp">Sarcoptiformes</a></li>
        <li><a href="<@s.url value='/species/42/name_usage'/>" class="placeholder_temp">Scorpiones</a></li>
      </ul>
      <ul class="three_cols">
        <li><a href="<@s.url value='/species/42/name_usage'/>" class="placeholder_temp">Araneae<a/></li>
        <li><a href="<@s.url value='/species/42/name_usage'/>" class="placeholder_temp">Opiliones</a></li>
        <li><a href="<@s.url value='/species/42/name_usage'/>" class="placeholder_temp">Parasitiformes</a></li>
        <li><a href="<@s.url value='/species/42/name_usage'/>" class="placeholder_temp">Pseudoscorpionida</a></li>
        <li><a href="<@s.url value='/species/42/name_usage'/>" class="placeholder_temp">Sarcoptiformes</a></li>
        <li><a href="<@s.url value='/species/42/name_usage'/>" class="placeholder_temp">Scorpiones</a></li>
        <li><a href="<@s.url value='/species/42/name_usage'/>" class="placeholder_temp">Trombidiformes</a></li>
        <li><a href="<@s.url value='/species/42/name_usage'/>" class="placeholder_temp">Pseudoscorpionida</a></li>
        <li><a href="<@s.url value='/species/42/name_usage'/>" class="placeholder_temp">Sarcoptiformes</a></li>
        <li><a href="<@s.url value='/species/42/name_usage'/>" class="placeholder_temp">Scorpiones</a></li>
      </ul>

      <p>The complete list has XXX more elements. You can <a href="#" class="download"
                                                             title="Download all the elments">download them all</a>.
      </p>
    </div>

    <div class="right">
      <h3>Taxonomic coverage</h3>

      <p class="placeholder_temp">Animalia</p>

      <h3>Second level data elements</h3>
      <ul>
        <li>References <span class="number placeholder_temp">123</span></li>
        <li>Common names <span class="number placeholder_temp">456</span></li>
        <li>Specimens <span class="number placeholder_temp">152</span></li>
      </ul>
    </div>
  </div>
  <footer></footer>
</article>

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

      <p class="placeholder_temp">North America</p>

      <p class="maptype"><a href="#" title="points" class="placeholder_temp">points</a> | <a href="#" title="grid"
                                                                                             class="placeholder_temp">grid</a>
        | <a href="#"
             title="polygons"
             class="selected placeholder_temp">polygons</a>
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

<article class="mono_line">
  <header></header>
  <div class="content">

    <div class="header">
      <h2>Dataset usage & legal issues</h2>
    </div>

    <div class="left">
      <h3>Usage rights</h3>

      <p class="placeholder_temp">This dataset is released under an Open Data licence, so it can be used to anyone who
        cites it. </p>

      <h3>How to cite it</h3>

      <p class="placeholder_temp">Alaska Ocean Observing System, Arctic Ocean Diversity (accessed through GBIF data
        portal, <a href="#"
                   title="Alaska Ocean Observing System, Arctic Ocean Diversity">http://data.gbif.org/datasets/resource/654</a>,
        2011-05-05)</p>
    </div>

  </div>
  <footer></footer>
</article>

</body>
</html>
