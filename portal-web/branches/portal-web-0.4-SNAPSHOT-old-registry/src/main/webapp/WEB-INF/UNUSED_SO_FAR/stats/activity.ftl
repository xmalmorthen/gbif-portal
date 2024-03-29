<html>
<head>
  <title>Activity - GBIF</title>
  <content tag="extra_scripts">
    <script type="text/javascript" charset="utf-8">
      $(function() {

        if ($("#map").length) {
          var latlng = new google.maps.LatLng(-34.397, 150.644);
          var myOptions = { zoom: 5, center: latlng, disableDefaultUI: true, mapTypeId: google.maps.MapTypeId.ROADMAP };
          var map = new google.maps.Map(document.getElementById("map"), myOptions);
        }

        $("#dataset-graph1").addGraph(generateRandomValues(50), {width:275, height:200});
        $("#dataset-graph2").addGraph(generateRandomValues(50), {width:275, height:200});
        $("#dataset-graph3").addGraph(generateRandomValues(50), {width:275, height:200});
      });
    </script>
  </content>
</head>
<body class="species typesmap">

  <content tag="infoband">
    <h1>GBIF Data Portal statistics</h1>

    <h3>Status in numbers</h3>
  </content>

  <content tag="tabs">
    <ul>
      <li><a href="<@s.url value='/stats'/>"><span>Content</span></a></li>
      <li><a href="<@s.url value='/stats/history'/>" title="History"><span>History </span></a></li>
      <li class='selected'><a href="<@s.url value='/stats/activity'/>"><span>Activity</span></a></li>
    </ul>
  </content>

  <article>
    <header></header>
    <div class="content">
      <div class="header">
        <div class="left"><h2>GBIF Data Portal usage</h2></div>
      </div>
      <div class="left">
        <h3>How do people use the data portal?</h3>

        <p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet
          dolore magna aliquam erat volutpat. Ut wisi enim ad minim veniam, quis nostrud exerci tation ullamcorper
          suscipit lobortis nisl ut aliquip ex ea commodo consequat.</p>

        <p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu
          feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril
          delenit augue duis dolore te feugait nulla facilisi.</p>
      </div>
      <div class="right">
        <h3>More usage stats</h3>
        <ul>
          <li><a href="#">Documented use of GBIF - mediated data</a></li>
        </ul>
      </div>
    </div>
    <footer></footer>
  </article>

<@common.article id="minigrpahs" title="Usage summary" class="mono_line">
    <div class="minigraphs">
      <div id="dataset-graph1" class="minigraph">
        <h3>45<span>unique visits</span></h3>
        <a href="#" title="Help" id="help3" class="help"><img
                src="<@s.url value='/img/icons/questionmark.png'/>"/></a>

        <div class="percentage down">21% last year</div>
        <div class="start">1998</div>
        <div class="end">2011</div>
        <div class="lt"></div>
        <div class="rt"></div>
      </div>
      <div id="dataset-graph2" class="minigraph">
        <h3>25<span>searches</span></h3>
        <a href="#" title="Help" id="help3" class="help"><img
                src="<@s.url value='/img/icons/questionmark.png'/>"/></a>

        <div class="percentage up">21% last year</div>
        <div class="start">1998</div>
        <div class="end">2011</div>
        <div class="lt"></div>
        <div class="rt"></div>
      </div>
      <div id="dataset-graph3" class="minigraph last">
        <h3>123,599<span>downloads</span></h3>
        <a href="#" title="Help" id="help" class="help"><img src="<@s.url value='/img/icons/questionmark.png'/>"/></a>

        <div class="percentage down">21% last year</div>
        <div class="start">1998</div>
        <div class="end">2011</div>
        <div class="lt"></div>
        <div class="rt"></div>
      </div>
    </div>
</@common.article>

<@common.article id="rankings" title="Rankings">
    <div class="left">
      <h3>Top search terms</h3>
      <ul class="three_cols no_bottom">
        <li><a href="">Puma concolor</a></li>
        <li><a href="">Mammals</a></li>
        <li><a href="">Marine mammals</a></li>
        <li><a href="">Africa</a></li>
        <li><a href="">Coastal</a></li>
      </ul>
      <ul class="three_cols">
        <li><a href="">Puma concolor</a></li>
        <li><a href="">Mammals</a></li>
        <li><a href="">Marine mammals</a></li>
        <li><a href="">Africa</a></li>
        <li><a href="">Coastal</a></li>
      </ul>
      <ul class="three_cols">
        <li><a href="">Puma concolor</a></li>
        <li><a href="">Mammals</a></li>
        <li><a href="">Marine mammals</a></li>
        <li><a href="">Africa</a></li>
        <li><a href="">Coastal</a></li>
      </ul>
    </div>
    <div class="right">
      <h3>Users by countries</h3>
      <ul>
        <li>USA</li>
        <li>UK</li>
        <li>Germany</li>
        <li>Poland</li>
      </ul>
    </div>
</@common.article>

</body>
</html>
