// Necessary things to run these kind of map
// - class map to body
$(function(){
  // If body has map class - search #map and start rendering map
  if ($('body').hasClass('map')) {
    var key = $("#map").attr("key");
    var type = $("#map").attr("type");
    console.log("Rendering map key[" + key + "], type[" + type + "]");
	
	var gbifUrl=cfg.tileServerBaseUrl + '/density/tile?key=' + +key + '&x={x}&y={y}&z={z}&type=' + type;
	var gbifAttrib='GBIF contributors';
	var gbif = new L.TileLayer(gbifUrl, {minZoom: 0, maxZoom: 14, attribution: gbifAttrib});		
    
    // See http://maps.cloudmade.com/editor for the styles - 69341 is named GBIF Original
    var cmAttr = 'Map data &copy; 2011 OpenStreetMap contributors, Imagery &copy; 2011 CloudMade',
	  cmUrl = 'http://{s}.tile.cloudmade.com/BC9A493B41014CAABB98F0471D759707/{styleId}/256/{z}/{x}/{y}.png';
    var gbifBase = L.tileLayer(cmUrl, {styleId: 69341, attribution: cmAttr}),
      minimal   = L.tileLayer(cmUrl, {styleId: 29918, attribution: cmAttr}),
      midnight  = L.tileLayer(cmUrl, {styleId: 999,   attribution: cmAttr});

    var map = L.map('map', {
	  center: [0, 0],
	  zoom: 1,
	  layers: [gbifBase, gbif]
	});

    var baseLayers = {
      "Classic": gbifBase,
      "Minimal": minimal,
      "Night View": midnight
    };
    
    var overlays = {
      "GBIF": gbif
    };

    L.control.layers(baseLayers, overlays).addTo(map);    
  } 
  // else the body is missing the map attribute
});