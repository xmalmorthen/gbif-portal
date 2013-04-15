<#import "/WEB-INF/macros/common.ftl" as common>
<html>
<head>
  <title>Data About ${country.title}</title>
    <link rel="stylesheet" href="<@s.url value='/js/vendor/leaflet/leaflet.css'/>" />
    <!--[if lte IE 8]><link rel="stylesheet" href="<@s.url value='/js/vendor/leaflet/leaflet.ie.css'/>" /><![endif]-->
    <script type="text/javascript" src="<@s.url value='/js/vendor/leaflet/leaflet.js'/>"></script>
    <script type="text/javascript" src="<@s.url value='/js/map.js'/>"></script>
    <script type="text/javascript">
        $(function() {
            $("#map").densityMap("${id}", "COUNTRY");
        });
    </script>
</head>
<body>

<#assign tab="about"/>
<#include "/WEB-INF/pages/country/inc/infoband.ftl">

<@common.article id="about" class="map" titleRight="About ${country.title}">
    <div class="map" id="map"></div>

    <div class="right">
      <p>Data about ${country.title} are contributed by 30 institutions in 26 countries:</p>

      <ul>
          <li>60 occurrence datasets with 15,644,091 records.</li>
          <li>4 checklist datasets with 38,922 records.</li>
      </ul>
    </div>
</@common.article>


</body>
</html>
