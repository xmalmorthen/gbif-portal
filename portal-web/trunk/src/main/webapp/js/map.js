// Necessary things to run these kind of map
// - class map to body
$(function() {
  // optimize this by ignoring any page with no suitable class 
  if ($('body').hasClass('densitymap') || $('body').hasClass('pointmap')) {

    
    // See http://maps.cloudmade.com/editor for the styles - 69341 is named GBIF Original
    var cmAttr = 'Map data &copy; 2011 OpenStreetMap contributors, Imagery &copy; 2011 CloudMade',
	  cmUrl = 'http://{s}.tile.cloudmade.com/BC9A493B41014CAABB98F0471D759707/{styleId}/256/{z}/{x}/{y}.png';
    var gbifBase = L.tileLayer(cmUrl, {styleId: 69341, attribution: cmAttr}),
      minimal   = L.tileLayer(cmUrl, {styleId: 997, attribution: cmAttr}),
      midnight  = L.tileLayer(cmUrl, {styleId: 999,   attribution: cmAttr});

    var baseLayers = {
      "Classic": gbifBase,
      "Minimal": minimal,
      "Night View": midnight
    };

    // Density Maps use the tile-server to overlay tiles
    if ($('body').hasClass('densitymap')) {
      console.log("Rendering map key[" + key + "], type[" + type + "]");
      var key = $("#map").attr("key");
      var type = $("#map").attr("type");
      var gbifUrl=cfg.tileServerBaseUrl + '/density/tile?key=' + key + '&x={x}&y={y}&z={z}&type=' + type;
      var gbifAttrib='GBIF contributors';
      var gbif = new L.TileLayer(gbifUrl, {minZoom: 0, maxZoom: 14, attribution: gbifAttrib});		
      	
      var overlays = {
        "GBIF": gbif
      };

      var map = L.map('map', {
        center: [0, 0],
        zoom: 1,
        layers: [minimal, gbif]
	  });
      L.control.layers(baseLayers, overlays).addTo(map);   
    
    } else if ($('body').hasClass('pointmap')) {
      console.log("Rendering pointmap");
  
      var map = L.map('map', {
	    center: [0, 0],
	    zoom: 1,
	    layers: [minimal]
	  });
	
      var baseLayers = {
        "Classic": gbifBase,
        "Minimal": minimal,
        "Night View": midnight
      };
      L.control.layers(baseLayers, overlays).addTo(map);     
	  
	  var latitude = $('#map').attr('latitude');
	  var longitude = $('#map').attr('longitude');
	  if (latitude != null && longitude!=null) {
	    L.marker([latitude, longitude]).addTo(map);
	    map.setView([latitude, longitude], 4);
	  }
	  
	  
    }
  }
});