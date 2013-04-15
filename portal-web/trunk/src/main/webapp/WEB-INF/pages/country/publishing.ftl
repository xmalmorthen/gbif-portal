<#import "/WEB-INF/macros/common.ftl" as common>
<html>
<head>
  <title>Data Published by ${country.title}</title>
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

<#assign tab="publishing"/>
<#include "/WEB-INF/pages/country/inc/infoband.ftl">


<@common.article id="publishing" class="map" titleRight="Published By ${country.title}">
    <div class="map" id="map"></div>

    <div class="right">
      <p>${country.title} publishes data concerning 244 countries, islands and territories:</p>

      <ul>
          <li>30 occurrence datasets with 5,644,091 records.</li>
          <li>3 checklist datasets with 18,733 records.</li>
      </ul>
    </div>
</@common.article>



</body>
</html>
