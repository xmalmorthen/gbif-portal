<#import "/WEB-INF/macros/common.ftl" as common>
<html>
<head>
  <title>Countries, territories and islands</title>
  <#--

  COMMENTED OUT MAP IN THIS RELEASE

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
    -->
    <style type="text/css">
        #map {
            width: 640px;
            height: 400px;
            padding-left: 30px;
        }
        #content article.dataset .content {
            padding-top: 31px;
            padding-bottom: 0px;
        }
    </style>
</head>

<body class="infobandless">

<#--
  <article class="dataset">
    <header></header>
    <div class="content">
      <h1>Countries</h1>
      <p>
        <div id="map"></div>
      </p>
      <p>Countries, territories and islands are based on the
          <a href="http://www.iso.org/iso/country_codes/iso_3166_code_lists/country_names_and_code_elements.htm">ISO 3166-1</a> standard.
      </p>
      <p><a id="toggleCountryList" href="#">List of all countries, territories and islands</a></p>
    </h3>
    </div>

    <footer></footer>
  </article>
-->

<#macro countryList minIdx maxIdx>
  <div class="col">
      <ul>
        <#list countries as c>
          <#if c.isOfficial() && c_index lt maxIdx && c_index gt minIdx>
            <li<#if activeNodes.contains(c)> class="node"</#if>><a href="<@s.url value='/country/${c.getIso2LetterCode()}'/>">${c.getTitle()}</a></li>
          </#if>
        </#list>
      </ul>
  </div>
</#macro>

<@common.notice title="Names of countries, territories and islands">
    <p>Names of countries, territories and islands are based on the
        <a href="http://www.iso.org/iso/country_codes/iso_3166_code_lists/country_names_and_code_elements.htm">ISO 3166-1</a> standard.
    </p>
</@common.notice>


<#assign maxLftIdx = (countries.size()/2)?ceiling - 2 />
<@common.article id="country_list" title="Countries, territories and islands">
  <div class="fullwidth">
    <p>Index to all countries, active GBIF Nodes are underlined.<br/>
        <a href="<@s.url value='/participation/list#other'/>">Other GBIF Participant organizations</a> are not listed here.
    </p>
    <@countryList minIdx=-1 maxIdx=maxLftIdx />
    <@countryList minIdx=maxLftIdx-1 maxIdx=10+maxLftIdx*2/>
  </div>
</@common.article>


</body>
</html>
