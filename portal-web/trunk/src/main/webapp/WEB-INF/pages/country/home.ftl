<html>
<head>
  <title>Countries</title>
  <link rel="stylesheet" href="<@s.url value='/js/vendor/jvectormap/jquery-jvectormap-1.2.2.css'/>" type="text/css" media="screen"/>
  <script type="text/javascript" src="<@s.url value='/js/vendor/jvectormap/jquery-jvectormap-1.2.2.min.js'/>"></script>
  <script type="text/javascript" src="<@s.url value='/js/vendor/jvectormap/jquery-jvectormap-world-mill-en.js'/>"></script>
  <script type='text/javascript'>
      $(function() {
        // http://jvectormap.com/tutorials/getting-started/
        $('#map').vectorMap({
            map: 'world_mill_en',
            backgroundColor: "white",
            regionStyle: {
              initial: {
                fill: '#4B8A08',
                "fill-opacity": 0.8,
                stroke: 'none',
                "stroke-width": 0,
                "stroke-opacity": 1
              },
              hover: {
                "fill-opacity": 1
              }
            },
            onRegionClick: function(e, code){
              window.location = cfg.baseUrl + "/country/" + code;
            }
        });
      });
  </script>
    <style type="text/css">
        #map {
            width: 640px;
            height: 400px;
            padding-left: 30px;
        }
    </style>
</head>

<body class="dataset">


  <article class="dataset">
    <header></header>
    <div class="content">
      <h1>Countries</h1>
      <p>
        <div id="map"></div>
      </p>
    </div>

    <footer></footer>
  </article>

</body>
</html>
