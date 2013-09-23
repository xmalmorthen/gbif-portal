<html>
  <head>
    <title>GBIF Data Portal - Home</title>
    
    <style>
      #map { 
        height: 490px;
        width:100%;
        display: block;
        position: absolute;
      }
      .leaflet-container { background: #519A45; }    
      /* only on the homepage.  credit given everywhere else */
      .leaflet-control-attribution { visibility: hidden }
      .leaflet-popup-content-wrapper {
        padding: 3px;
        text-align: left;
        -webkit-border-radius: 5px;
        border-radius: 5px;
  }      
    
    </style>    
    
        <link rel="stylesheet" href="<@s.url value='/js/vendor/leaflet/leaflet.css'/>" />		
 	    <!--[if lte IE 8]><link rel="stylesheet" href="<@s.url value='/js/vendor/leaflet/leaflet.ie.css'/>" /><![endif]-->		
	    <script type="text/javascript" src="<@s.url value='/js/vendor/leaflet/leaflet.js'/>"></script>		
	    <script type="text/javascript" src="<@s.url value='/js/map.js'/>"></script>		
    
    <script type="text/javascript">
      <#-- EXECUTED ON WINDOWS LOAD -->
      $(function() {
          $.getJSON(cfg.wsMetrics + 'occurrence/count?callback=?', function (data) {
            $("#countOccurrences").html(data);
          });
          $.getJSON(cfg.wsClbSearch + '?dataset_key=d7dddbf4-2cf0-4f39-9b2a-bb099caae36c&limit=1&rank=species&status=accepted&callback=?', function (data) {
            $("#countSpecies").html(data.count);
          });
          $.getJSON(cfg.wsRegSearch + '?limit=1&callback=?', function (data) {
            $("#countDatasets").html(data.count);
          });
          $.getJSON(cfg.wsReg + 'organization?limit=1&callback=?', function (data) {
            $("#countPublishers").html(data.count);
          });
          
          
          
          
      var southWest = new L.LatLng(80, -180),
      northEast = new L.LatLng(-80, 180),
      bounds = new L.LatLngBounds(southWest, northEast);    
      
      var startLat = Math.floor((Math.random()*90)+1) - 45; // random +/-45
      var startLng = Math.floor((Math.random()*180)+1) - 90; // random +/-90
      
      var map = L.map('map').setMaxBounds(bounds).setView([startLat, startLng], 1);
      L.tileLayer('img/tiles/{z}/{x}/{y}.png', {
        maxZoom: 4,
        minZoom: 3,
      }).addTo(map);      
          
      

      var points = [];      
      var visible = []; // at any time
      var size = 100; // batch size from server
      var maxVisible = 180; // at any time
      var delayMsecs = 1000;
      
      function initData() {
        for (var i=0;i<maxVisible;i++) {
        points.push(
          new L.CircleMarker([0, 0], {
              fillColor: '#223E1D',
              weight: 2,
              color: '#ffffff',
              fillOpacity: 1, 
              opacity: 0.6,
              radius: 4
            }));
        }
      }
      
      // sample 
      var publishers = [
        {id:1, name: "Berlin Botanical Gardens"},
        {id:2, name: "UK NBN"}
      ];
      var sciNames = [
        {id:1, name: "Puma concolor"},
        {id:2, name: "Abies alba"}
      ];

      function getOccurrences() {
        var occurrences = [];
        for (var i=0;i<size;i++) {
          var lat = Math.floor((Math.random()*160)+1) - 85; // random +/-80
          var lng = Math.floor((Math.random()*360)+1) - 180; // random +/-180
          var id = Math.floor((Math.random()*400000000)+1);
          var pubIndex = Math.floor((Math.random()*2));
          var nameIndex = Math.floor((Math.random()*2));
          occurrences.push(
            {id:id, lat:lat, lng:lng, name:sciNames[nameIndex], publisher: publishers[pubIndex]});
        }        
        occurrences.reverse; // so we can just pop off the end
        return occurrences;
      }
      
      var currentPointIdx=0;
      var occurrences = getOccurrences();
      
      function runMap() {
        

        // get a batch from the server
        if (occurrences.length==0) {
          occurrences = getOccurrences();
        }
      	      	
      	var point = points[currentPointIdx];
      	if(point._map && point._map.hasLayer(point._popup)) {
      	  // popup is open, can't remove this point
        } else {
      	  var occurrence = occurrences.pop();
        	//map.removeLayer(point);
        	//point.setStyle({opacity:1.0, fillOpacity:1.0});
        	point.setLatLng([occurrence.lat,occurrence.lng]);
        	point.unbindPopup(); // avoid memory leak
        	point.bindPopup(
                "<p><a href=''>" + occurrence.name.name +"</a></p>" + 
                "<p>Published by <a href=''>" + occurrence.publisher.name +"</a></p>")                 
        	point.addTo(map); // it should already be
        }      	
        
      	// move to next one
      	currentPointIdx = currentPointIdx + 1;
      	// reuse the points
      	if (currentPointIdx >= points.length) {
      	  currentPointIdx = 0;
      	}
      	
      	// fade those about to disappear (hoses CPU - removing)
      	/*
      	var x = currentPointIdx
      	for (var i=0;i<25;i++) {
      	  if (x >= points.length) {
      	    x = 0;
      	  }
      	  point = points[x];
      	  if(point._map && point._map.hasLayer(point._popup)) {
      	    // it's open
      	  } else {
      	    // TODO: take into consideration the starting opactiy
      	    point.setStyle({opacity:(i/25), fillOpacity:(i/25)});        	  
      	  }
      	  x=x+1;
      	}
      	*/
      	
      	
        
        setTimeout(runMap, delayMsecs);
      }
      initData();
      runMap();
      

        
          
          
          
          
          
          
          
          
        });
    </script>
      <style type="text/css">
          header #beta {
            left: 200px;
            top: 10px;
          }
      </style>
  </head>

  <content tag="logo_header">
  
  
    <div id="logo">
      <a href="<@s.url value='/'/>" class="logo"></a>
    </div>

    <div class="info">
      <h1>Global Biodiversity Information Facility</h1>
      <h2>Free and open access to biodiversity data</h2>

      <ul class="counters">
        <li><strong id="countOccurrences">?</strong> Occurrences</li>
        <li><strong id="countSpecies">?</strong> Species</li>
        <li><strong id="countDatasets">?</strong> Datasets</li>
        <li class="last"><strong id="countPublishers">?</strong> Data publishers</li>
      </ul>
    </div>
  </content>

  <body class="home">
  

    <div class="container">
    
    
    

    <article class="search">

    <header>
    </header>

    <div class="content">

      <ul>
        <li>
        <h3>Enables biodiversity data sharing and re-use</h3>
        <ul>
          <li><a href="#">Why publish your data?</a></li>
          <li><a href="#">How to publish your data</a></li>
          <li><a href="#">Data from citizen scientists</a></li>
        </ul>
        </li>

        <li>
        <h3>Supports biodiversity research</h3>
        <ul>
          <li><a href="#">Why publish your data?</a></li>
          <li><a href="#">How to publish your data</a></li>
          <li><a href="#">Data from citizen scientists</a></li>
        </ul>
        </li>

        <li>
        <h3>Collaborates as a global community</h3>
        <ul>
          <li><a href="#">Why publish your data?</a></li>
          <li><a href="#">How to publish your data</a></li>
          <li><a href="#">Data from citizen scientists</a></li>
        </ul>
        </li>

      </ul>
    </div>
    <div class="footer">

      <form action="/member/search">
        <span class="input_text">
          <input type="text" name="q" placeholder="Search GBIF for species, datasets or countries" class="focus">
        </span>
        <button type="submit" class="search_button"><span>Search</span></button>
      </form>

        <div class="footer">
           <a href="#">Birds</a> &middot;
           <a href="#">Butterflies</a> &middot;
           <a href="#">Lizards</a> &middot;
           <a href="#">Reptiles</a> &middot;
           <a href="#">Fishes</a> &middot;
           <a href="#">Mammals</a> &middot;
           <a href="#">Insects</a>
         </div>
    </div>
    <footer></footer>
    </article>

</div>

</body>
</html>
