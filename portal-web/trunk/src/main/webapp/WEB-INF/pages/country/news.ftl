<#import "/WEB-INF/macros/common.ftl" as common>
<html>
<head>
  <title>Country News for ${country.title}</title>
  <script type="text/javascript" src="<@s.url value='/js/vendor/feedek/FeedEk.js'/>"></script>
  <script type="text/javascript">
      $(function() {
        <#if feed??>
          $('#nodenews').FeedEk({
              FeedUrl: '${feed}',
              MaxCount: 5,
              ShowDesc: false,
              ShowPubDate: false,
              DescCharacterLimit: 30
          });
        </#if>
      });
  </script>
  <#--
  copied from newsroom to avoid putting the class newsroom on body which has a lot of unwanted side effects
  TODO: would be good to cleanup our styles and share some across sections based on article classes only, excluding any
        body class rules
  -->
    <style type="text/css">
        article.news .left li {
            list-style: none;
            padding: 20px 0;
            border-bottom: 1px solid #D8DCE1;
        }
        article.news .date{
          margin: 0 0 7px 0;
          color: #999999;
          font-size: 13px;
          font-family: "DINOT-Regular",sans-serif;
        }
        article.news .title {
            display: block;
            margin: 0 0 5px 0;
            font-weight: bold;
            font-size: 19px;
        }
        article.news p {
            margin: 0 0 5px 0;
        }
    </style>
</head>
<body>

<#assign tab="news"/>
<#include "/WEB-INF/pages/country/inc/infoband.ftl">


<@common.article id="news" title="Global GBIF news" titleRight="News from node" class="news">
    <div class="left" id="gbifnews">
        <p>There are no global news for ${country.title}.</p>
        <#--
        <ul>
        		  <li>
        				<h4 class="date">April 7th, 2013</h4>

        				<a href="http://uat.gbif.org/page/177" class="title">Data portal on algae and protozoa launched </a>

        				<p>The host of the GBIF national node in Germany has launched a new special interest data portal on algae and protozoa.</p>

        				<a href="http://uat.gbif.org/page/177" class="read_more">Read more</a>

        			</li>
        					<li>
        				<h4 class="date">April 7th, 2013</h4>

        				<a href="http://uat.gbif.org/page/176" class="title">So many fish, one great map – ALA launches FishMap</a>

        				<p>Australia’s marine fish species are now at your fingertips thanks to FishMap, launched by the Atlas of Living Australia (ALA), the GBIF node in the country.</p>

        				<a href="http://uat.gbif.org/page/176" class="read_more">Read more</a>

        			</li>
        					<li>
        				<h4 class="date">April 7th, 2013</h4>

        				<a href="http://uat.gbif.org/page/175" class="title">GBIF Japan trains Indonesian node in data publishing</a>

        				<p>Seventy professionals from various agencies in Indonesia took part in a workshop on integrated biodiversity data management, as part of a GBIF mentoring project. </p>

        				<a href="http://uat.gbif.org/page/175" class="read_more">Read more</a>

        			</li>
        					<li>
        				<h4 class="date">April 7th, 2013</h4>

        				<a href="http://uat.gbif.org/page/174" class="title">Boost for biodiversity informatics capacity in Southern Africa</a>

        				<p>The South African National Biodiversity Institute (SANBI), which hosts the GBIF national node, has signed a Memorandum of Understanding with the University of the Western Cape (UWC) to underpin development of a post-graduate research hub for biodiversity information management. </p>

        				<a href="http://uat.gbif.org/page/174" class="read_more">Read more</a>

        			</li>
        					<li>
        				<h4 class="date">March 14th, 2013</h4>

        				<a href="http://uat.gbif.org/page/172" class="title">Brazil surveys data holdings and informatics capacity</a>

        				<p>The national biodiversity information system for Brazil, SiBBr, has launched a survey of the data on biodiversity and ecosystems held by more than 200 institutions in the country, helping to mobilize data from GBIF's newest Participant.</p>

        				<a href="http://uat.gbif.org/page/172" class="read_more">Read more</a>

        			</li>


        </ul>
        -->
    </div>

    <div class="right" id="nodenews">
      <#if feed??>
          <p>No node news feed registered.</p>
      <#else>
          <p>No node news feed registered.</p>
      </#if>
    </div>
</@common.article>


</body>
</html>
