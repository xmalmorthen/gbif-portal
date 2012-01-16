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

    map = new google.maps.Map(document.getElementById('mapKyle'), mapOptions);
  }

</script>

<article>
  <header></header>

  <div class="content">

    <div class="left">
      <div id="mapKyle"></div>
    </div>

    <div class="right">
      <h3>Geographic coverage</h3>

      <p>North America</p>

      <p class="maptype"><a href="#" title="points">points</a> | <a href="#" title="grid">grid</a> | <a href="#"
                                                                                                        title="polygons"
                                                                                                        class="selected">polygons</a>
      </p>

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
