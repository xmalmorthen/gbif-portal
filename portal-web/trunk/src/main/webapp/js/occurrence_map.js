$(function(){
  var gbifMapType = new google.maps.ImageMapType({
    getTileUrl: function(coord, zoom) {
      return "http://140.247.231.188/php/map/getEolTile.php?tile=" + coord.x + "_" + coord.y + "_" + zoom + "_" + $("#map").attr("nubid");
   },
   tileSize: new google.maps.Size(256, 256),
   isPng: true
  });

  var latlng = new google.maps.LatLng(0, 0);
  var myOptions = {
    zoom: 1,
    center: latlng,
    mapTypeId: google.maps.MapTypeId.TERRAIN,
    disableDefaultUI: true,
    zoomControl: true
  };

  var map = new google.maps.Map(document.getElementById("map"), myOptions);
  map.overlayMapTypes.insertAt(0, gbifMapType);

});
