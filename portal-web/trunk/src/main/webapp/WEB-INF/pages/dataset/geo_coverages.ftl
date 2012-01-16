<script type="text/javascript" src="http://maps.google.com/maps/api/js?sensor=false"></script>
<script type="text/javascript">
  function initBB()
  {
    // Global variables
    var map;

    var maxy = parseFloat("${(dataset.geographicCoverages[0].boundingBox.minLongitude)!}");
    var miny = parseFloat("${(dataset.geographicCoverages[0].boundingBox.minLatitude)!}");
    var maxx = parseFloat("${(dataset.geographicCoverages[0].boundingBox.maxLongitude)!}");
    var minx = parseFloat("${(dataset.geographicCoverages[0].boundingBox.maxLatitude)!}");

    var mapOptions = {
      zoom: 2,
      center: new google.maps.LatLng((maxy+miny)/2, (maxx+minx)/2),
      scaleControl: true,
      scaleControlOptions: {
        position: google.maps.ControlPosition.TOP_LEFT
      },
      mapTypeControl: true,
      mapTypeControlOptions: {
        style: google.maps.MapTypeControlStyle.DROPDOWN_MENU
      },
      navigationControl: true,
      navigationControlOptions: {
        style: google.maps.NavigationControlStyle.ANDROID,
        position: google.maps.ControlPosition.BOTTOM_LEFT
      },
      mapTypeId: google.maps.MapTypeId.TERRAIN
    }

    map = new google.maps.Map(document.getElementById('map'), mapOptions);
  }

</script>

<article class="map">
  <header></header>
  <div id="map"></div>

  <div class="content">

    <div class="header">
      <div class="right"><h2>Boundaries</h2></div>
    </div>

    <div class="right">
      <h3>Geographic coverage</h3>

      <p class="maptype"><a class="selected" href="#" title="points">points</a> | <a href="#" title="grid">grid</a> | <a
              href="#" title="polygons">polygons</a></p>

      <h3>Download</h3>
      <ul>
        <li class="download"><a href="#" title="One Degree cell density">One Degree cell density <abbr
                title="Keyhole Markup Language">(KML)</abbr></a></li>
        <li class="download"><a href="#" title="Placemarks">Placemarks <abbr
                title="Keyhole Markup Language">(KML)</abbr></a></li>
      </ul>
    </div>
  </div>
  <footer></footer>
</article>
