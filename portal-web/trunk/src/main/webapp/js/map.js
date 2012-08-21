var CONFIG = { // global config var
  minZoom: 0,
  maxZoom: 14,
  center: [0, 0],
  defaultZoom: 1
};

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

      console.log("Rendering map key[" + key + "], type[" + type + "]");

      var
      key        = $("#map").attr("key"),
      type       = $("#map").attr("type"),
      gbifUrl    = cfg.tileServerBaseUrl + '/density/tile?key=' + key + '&x={x}&y={y}&z={z}&type=' + type,
      gbifAttrib = 'GBIF contributors',
      gbif       = new L.TileLayer(gbifUrl, { minZoom: CONFIG.minZoom, maxZoom: CONFIG.maxZoom , attribution: gbifAttrib });

      var overlays = { "GBIF": gbif };

      var map = L.map('map', {
        center: CONFIG.center,
        zoom: CONFIG.defaultZoom,
        layers: [minimal, gbif],
        zoomControl: false
      });

      setupZoom(map);

      L.control.layers(baseLayers, overlays).addTo(map);

    } else if ($('body').hasClass('pointmap')) {

      console.log("Rendering pointmap");

      var map = L.map('map', {
        center: CONFIG.center,
        zoom: CONFIG.defaultZoom,
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
      lat = $('#map').attr('latitude'),
      lng = $('#map').attr('longitude');

      if (lat != null && lng != null) {
        L.marker([lat, lng]).addTo(map);
        map.setView([lat, long], 4);
      }

    }
  }
});
