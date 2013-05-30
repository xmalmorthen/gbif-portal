<#import "/WEB-INF/macros/common.ftl" as common>
<html>
<head>
  <title>Countries</title>
  <link rel="stylesheet" href="<@s.url value='/js/vendor/jvectormap/jquery-jvectormap-1.2.2.css'/>" type="text/css" media="screen"/>
  <script type="text/javascript" src="<@s.url value='/js/vendor/jvectormap/jquery-jvectormap-1.2.2.min.js'/>"></script>
  <script type="text/javascript" src="<@s.url value='/js/vendor/jvectormap/jquery-jvectormap-world-mill-en.js'/>"></script>
  <script type='text/javascript'>
      $(function() {
        // http://jvectormap.com/tutorials/getting-started/
        var nodes = {
          <#list nodes as n>
              "${n.getIso2LetterCode()}": 1<#if n_has_next>,</#if>
          </#list>
        };
        $('#map').vectorMap({
            map: 'world_mill_en',
            backgroundColor: "white",
            series: {
              regions: [{
                values: nodes,
                scale: ['#4B8A08'],
                min: '1',
                max: '1'
              }]
            },
            regionStyle: {
              initial: {
                fill: '#6EA038',
                "fill-opacity": 0.8,
                stroke: 'none',
                "stroke-width": 0,
                "stroke-opacity": 1
              },
              hover: {
                fill: '#E7C535'
              }
            },
            onRegionClick: function(e, code){
              window.location = cfg.baseUrl + "/country/" + code;
            }
        });
        $('#country_list').hide();
        $("#toggleCountryList").click(function() {
          $('#country_list').slideToggle({
              "easing":"easeOutBounce",
              "duration":"3000"
          });
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
      <p><a id="toggleCountryList" href="#">List of all countries</a></p>
    </div>

    <footer></footer>
  </article>

<#assign leftColSize = (countries.size()/2)?ceiling />
<@common.article id="country_list" title="Country List">
  <div class="fullwidth">
      <div class="col">
          <ul>
            <#list countries as c>
              <#if c.isOfficial() && c_index lt leftColSize>
                <li><a href="<@s.url value='/country/${c.getIso2LetterCode()}'/>">${c.getTitle()}</a></li>
              </#if>
            </#list>
          </ul>
      </div>
      <div class="col">
          <ul>
            <#list countries as c>
              <#if c.isOfficial() && c_index +1 gt leftColSize>
                <li><a href="<@s.url value='/country/${c.getIso2LetterCode()}'/>">${c.getTitle()}</a></li>
              </#if>
            </#list>
          </ul>
      </div>
  </div>
</@common.article>

</body>
</html>
