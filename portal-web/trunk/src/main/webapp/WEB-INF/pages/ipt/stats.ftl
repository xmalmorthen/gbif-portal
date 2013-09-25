<#import "/WEB-INF/macros/common.ftl" as common>
<#import "/WEB-INF/pages/developer/inc/api.ftl" as api>
<html>
<head>
  <title>IPT Stats</title>
</head>

<#assign tab="stats"/>
<#include "/WEB-INF/pages/ipt/inc/infoband.ftl" />


<body class="ipt">


<@common.article title="IPT instances worldwide" titleRight="Overview">
  <div class="left">
      <div id="iptmap" class="map" style="height:400px"></div>

      <link rel="stylesheet" href="<@s.url value='/js/vendor/leaflet/leaflet.css'/>" />
      <!--[if lte IE 8]><link rel="stylesheet" href="<@s.url value='/js/vendor/leaflet/leaflet.ie.css'/>" /><![endif]-->
      <script type="text/javascript" src="<@s.url value='/js/vendor/leaflet/leaflet.js'/>"></script><script>

      var // see http://maps.cloudmade.com/editor for the styles - 69341 is named GBIF Original
      cmAttr = 'Map data &copy; 2011 OpenStreetMap contributors, Imagery &copy; 2011 CloudMade',
      cmUrl  = 'http://{s}.tile.cloudmade.com/BC9A493B41014CAABB98F0471D759707/{styleId}/256/{z}/{x}/{y}.png';

      var
      gbifBase  = L.tileLayer(cmUrl, {styleId: 69341, attribution: cmAttr}),
      minimal   = L.tileLayer(cmUrl, {styleId: 997,   attribution: cmAttr}),
      midnight  = L.tileLayer(cmUrl, {styleId: 999,   attribution: cmAttr});

      // setup map on page
      var map = L.map('iptmap', {
          center: [0,0],
          zoom: 1,
          layers: [minimal],
          zoomControl: false
      });

      // render a circle on the map for each Feature in the FeatureCollection
      // TODO: URL is hardcoded, they will need to be updated when migrated to UAT for example

      $.getJSON("http://apidev.gbif.org/installation/location/IPT_INSTALLATION", function(data){
          console.log(data);
          L.geoJson(data).addTo(map);
      });

  </script>
  </div>
  <div class="right">
      <ul>
          <li>110 installations in 30 countries serving:</li>
          <li>45 checklists published by 12 different organizations</li>
          <li>65 occurrence datasets published by 90 different organizations totaling 219,000,000 records.</li>
          <li>Please note, these numbers are fabricated and serve only as placeholders for the time being.</li>
      </ul>
    <p>&nbsp;</p>
      <h2>Don’t see your IPT?</h2>
      <p>Send <a href="mailto:helpdesk@gbif.org" title="Mail to GBIF Helpdesk requesting IPT be added to map">GBIF</a> your coordinates.</p>
  </div>
</@common.article>

</body>
</html>