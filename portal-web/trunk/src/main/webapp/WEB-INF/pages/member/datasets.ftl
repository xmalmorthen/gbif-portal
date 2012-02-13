<#import "/WEB-INF/macros/common.ftl" as common>
<html>
<head>
  <title>Member datasets - GBIF</title>
  <meta name="gmap" content="true"/>
  <content tag="extra_scripts">
  </content>
</head>
<body class="species typesmap">

<#assign tab="datasets"/>
<#include "/WEB-INF/pages/member/infoband.ftl">

<article>
  <header></header>
  <div class="content">

    <div class="header">
      <div class="left"><h2>Datasets</h2></div>
    </div>

    <div class="left">
      <h3>Datasets</h3>
      <p>${member.description!"&nbsp;"}</p>

    </div>

    <div class="right">
                &nbsp;
    </div>
  </div>
  <footer></footer>
</article>

 <article class="map">
  <header></header>
  <div id="map"></div>
  <a href="#zoom_in" class="zoom_in"></a>
  <a href="#zoom_out" class="zoom_out"></a>

  <div class="content placeholder_temp">

    <div class="header">
      <div class="right"><h2>1,453 georeferenced occurrences</h2></div>
    </div>

    <div class="right">
      <h3>Visualize</h3>

      <p class="maptype"><a class="selected" href="#" title="points">points</a> | <a href="#" title="grid">grid</a> | <a
              href="#" title="polygons">polygons</a></p>

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


</body>
</html>
