var CONFIG = { // global config var
  minZoom: 0,
  maxZoom: 14,
  center: [0, 0],
  defaultZoom: 1
};


// The map layers can be controlled
var LAYER_OBSERVATION = ["OBS_NO_YEAR","OBS_PRE_1900","OBS_1900_1910","OBS_1910_1920","OBS_1920_1930","OBS_1930_1940","OBS_1940_1950","OBS_1950_1960","OBS_1960_1970","OBS_1970_1980","OBS_1980_1990","OBS_1990_2000","OBS_2000_2010","OBS_2010_2020"];
var LAYER_LIVING = ["LIVING"];
var LAYER_FOSSIL = ["FOSSIL"];
var LAYER_SPECIMEN = ["SP_NO_YEAR","SP_PRE_1900","SP_1900_1910","SP_1910_1920","SP_1920_1930","SP_1930_1940","SP_1940_1950","SP_1950_1960","SP_1960_1970","SP_1970_1980","SP_1980_1990","SP_1990_2000","SP_2000_2010","SP_2010_2020"];
var LAYER_OTHER = ["OTH_NO_YEAR","OTH_PRE_1900","OTH_1900_1910","OTH_1910_1920","OTH_1920_1930","OTH_1930_1940","OTH_1940_1950","OTH_1950_1960","OTH_1960_1970","OTH_1970_1980","OTH_1980_1990","OTH_1990_2000","OTH_2000_2010","OTH_2010_2020"];
var LAYER_ALL = [
  "OBS_NO_YEAR","OBS_PRE_1900","OBS_1900_1910","OBS_1910_1920","OBS_1920_1930","OBS_1930_1940","OBS_1940_1950","OBS_1950_1960","OBS_1960_1970","OBS_1970_1980","OBS_1980_1990","OBS_1990_2000","OBS_2000_2010","OBS_2010_2020",
  "LIVING",
  "FOSSIL",
  "SP_NO_YEAR","SP_PRE_1900","SP_1900_1910","SP_1910_1920","SP_1920_1930","SP_1930_1940","SP_1940_1950","SP_1950_1960","SP_1960_1970","SP_1970_1980","SP_1980_1990","SP_1990_2000","SP_2000_2010","SP_2010_2020",
  "OTH_NO_YEAR","OTH_PRE_1900","OTH_1900_1910","OTH_1910_1920","OTH_1920_1930","OTH_1930_1940","OTH_1940_1950","OTH_1950_1960","OTH_1960_1970","OTH_1970_1980","OTH_1980_1990","OTH_1990_2000","OTH_2000_2010","OTH_2010_2020"  
];

// window scrolling needs to be disabled on full screan maps
// but we need to return it on exiting
var scrollPosition;

// builds the layer parameters from the input array 
function buildLayer(layers) {
  var s="";
  $.each(layers, function() {
    s += "&layer=" + this;
  });
  return s;
}

// Necessary things to run these kind of map
// - class map to body
$(function() {

  // optimize this by ignoring any page with no suitable class
  if ($('body').hasClass('densitymap') || $('body').hasClass('pointmap')) {

    var // see http://maps.cloudmade.com/editor for the styles - 69341 is named GBIF Original
    cmAttr = 'Map data &copy; 2011 OpenStreetMap contributors, Imagery &copy; 2011 CloudMade',
    cmUrl  = 'http://{s}.tile.cloudmade.com/BC9A493B41014CAABB98F0471D759707/{styleId}/256/{z}/{x}/{y}.png';

    var
    gbifBase  = L.tileLayer(cmUrl, {styleId: 69341, attribution: cmAttr}),
    minimal   = L.tileLayer(cmUrl, {styleId: 997,   attribution: cmAttr}),
    midnight  = L.tileLayer(cmUrl, {styleId: 999,   attribution: cmAttr});

    var baseLayers = {
      "Classic":    gbifBase,
      "Minimal":    minimal,
      "Night View": midnight
    };

    // Density Maps use the tile-server to overlay tiles
    if ($('body').hasClass('densitymap')) {

      var
      key        = $("#map").attr("key"),
      type       = $("#map").attr("type"),
      gbifUrl    = cfg.tileServerBaseUrl + '/density/tile?key=' + key + '&x={x}&y={y}&z={z}&type=' + type,
      l_all    = gbifUrl+ buildLayer(LAYER_ALL) + "&palette=yellow_reds",
      l_obs    = gbifUrl+ buildLayer(LAYER_OBSERVATION)  + "&palette=blues",
      l_liv    = gbifUrl+ buildLayer(LAYER_LIVING)  + "&palette=greens",
      l_fos    = gbifUrl+ buildLayer(LAYER_FOSSIL)  + "&palette=purples",
      l_spe    = gbifUrl+ buildLayer(LAYER_SPECIMEN)  + "&palette=reds",
      l_oth    = gbifUrl+ buildLayer(LAYER_OTHER)  + "&palette=orange",
      gbifAttrib = 'GBIF contributors',
      gbifAll       = new L.TileLayer(l_all, { minZoom: CONFIG.minZoom, maxZoom: CONFIG.maxZoom , attribution: gbifAttrib }),
      gbifObs       = new L.TileLayer(l_obs, { minZoom: CONFIG.minZoom, maxZoom: CONFIG.maxZoom , attribution: gbifAttrib }),
      gbifLiv       = new L.TileLayer(l_liv, { minZoom: CONFIG.minZoom, maxZoom: CONFIG.maxZoom , attribution: gbifAttrib }),
      gbifFos       = new L.TileLayer(l_fos, { minZoom: CONFIG.minZoom, maxZoom: CONFIG.maxZoom , attribution: gbifAttrib }),
      gbifSpe       = new L.TileLayer(l_spe, { minZoom: CONFIG.minZoom, maxZoom: CONFIG.maxZoom , attribution: gbifAttrib }),
      gbifOth       = new L.TileLayer(l_oth, { minZoom: CONFIG.minZoom, maxZoom: CONFIG.maxZoom , attribution: gbifAttrib });

      var overlays = { 
        "All types": gbifAll,
        "Preserved specimens": gbifSpe, 
        "Observations": gbifObs, 
        "Living specimens": gbifLiv, 
        "Fossils": gbifFos, 
        "Other types": gbifOth
       };

      var map = L.map('map', {
        center: CONFIG.center,
        zoom: CONFIG.defaultZoom,
        layers: [minimal, gbifAll],
        zoomControl: false
      });
      
      setupZoom(map);

      // draw the bounding boxes should they exist (for example from a geographic coverage in the dataset)
      if (typeof bboxes !== "undefined") {
        // bboxes have minLat,maxLat,minLng,maxLng
        $.each(bboxes, function(index, box) {
      	  // handle boxes that are really points
      	  if (box[0]==box[1] && box[2]==box[3]) {
	        L.marker([box[0], box[2]]).addTo(map);
      	  } else {
        	var bounds = [[box[0], box[2]], [box[1], box[3]]];
            L.rectangle(bounds, {color: "#ff7800", weight: 2}).addTo(map);
            // Some small boxes don't show, so provide a marker
            L.marker([box[0] + ((box[1]-box[0])/2), box[2] + ((box[3]-box[2])/2)]).addTo(map);
      	  }
      	});
      }

      L.control.layers(baseLayers, overlays).addTo(map);
      
      $(".tileControl").on("click", function(e) {
        e.preventDefault();
        if ($(this).attr("data-action") == 'show-specimens') {
          gbifUrl = cfg.tileServerBaseUrl + '/density/tile?key=' + key + '&x={x}&y={y}&z={z}&type=' + type
          + buildLayer(LAYER_SPECIMEN);
          
        } else if ($(this).attr("data-action") == 'show-observations') {
          gbifUrl = cfg.tileServerBaseUrl + '/density/tile?key=' + key + '&x={x}&y={y}&z={z}&type=' + type
          + buildLayer(LAYER_OBSERVATION);
        
        } else if ($(this).attr("data-action") == 'show-all') {
          gbifUrl = cfg.tileServerBaseUrl + '/density/tile?key=' + key + '&x={x}&y={y}&z={z}&type=' + type
          + buildLayer(LAYER_ALL);
                  
        }
        gbif.setUrl(gbifUrl);
      });
      
      // entering fullscreen disables the window scrolling
      map.on('enterFullscreen', function(){
        scrollPosition = [
          self.pageXOffset || document.documentElement.scrollLeft || document.body.scrollLeft,
          self.pageYOffset || document.documentElement.scrollTop  || document.body.scrollTop
        ];
        var html = jQuery('html'); // it would make more sense to apply this to body, but IE7 won't have that
        html.data('scroll-position', scrollPosition);
        html.data('previous-overflow', html.css('overflow'));
        html.css('overflow', 'hidden');
        window.scrollTo(scrollPosition[0], scrollPosition[1]);  
      });

      // enable the window scrolling exiting fullscreen
      map.on('exitFullscreen', function(){
        var html = jQuery('html');
        var scrollPosition = html.data('scroll-position');
        html.css('overflow', html.data('previous-overflow'));
        window.scrollTo(scrollPosition[0], scrollPosition[1]);  
      });
      
      // modify the "view all records in visibile area" with the bounds of the map
      $('.viewableAreaLink').bind('click', function(e) {
        var target = $(this).attr("href");
        var bounds=map.getBounds();
        var sw=bounds.getSouthWest(); // south west
        var ne=bounds.getNorthEast();
        
        $(this).attr("href", target + "&BOUNDING_BOX=" + ne.lat  + "," + sw.lng + "," + sw.lat +"," + ne.lng );        
      });
      

    } else if ($('body').hasClass('pointmap')) {

      var map = L.map('map', {
        center: CONFIG.center,
        zoom: 10,
        layers: [minimal],
        zoomControl: false
      });

      setupZoom(map);

      var baseLayers = {
        "Classic":    gbifBase,
        "Minimal":    minimal,
        "Night View": midnight
      };

      L.control.layers(baseLayers, overlays).addTo(map);

      var // coordinates
      lat = $('#map').attr('data-latitude'),
      lng = $('#map').attr('data-longitude');

      if (lat != null && lng != null) {
        L.marker([lat, lng]).addTo(map);
        map.setView([lat, long], 4);
      }

    }
  }
});
