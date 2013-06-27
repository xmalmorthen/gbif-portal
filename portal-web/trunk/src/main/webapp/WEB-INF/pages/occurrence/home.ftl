<#import "/WEB-INF/macros/common.ftl" as common>
<html>
<head>
  <title>Occurrence search</title>
   <content tag="extra_scripts"> 
    <link rel="stylesheet" href="<@s.url value='/js/vendor/leaflet/leaflet.css'/>" />
      <!--[if lte IE 8]><link rel="stylesheet" href="<@s.url value='/js/vendor/leaflet/leaflet.ie.css'/>" /><![endif]-->
      <script type="text/javascript" src="<@s.url value='/js/vendor/leaflet/leaflet.js'/>"></script>
      <script type="text/javascript" src="<@s.url value='/js/map.js'/>"></script>      
    <script>    
      $(document).ready(function() {
        var yearsValues = new Array();  
        <#assign yearCounts=action.yearCounts>  
        <#list yearCounts?keys as k>
          yearsValues.push(${yearCounts.get(k)?c});
        </#list>              
       console.debug("Years: " + yearsValues);
        $("#yearChart").addGraph(yearsValues, {height:240});
      });     
    
      $("#map").densityMap("1", "TAXON"); // TODO, change to ALL data
      </script>
   </content>
</head>
<body class="infobandless">


<article class="dataset">
    <header></header>
    <div class="content">
      <h1>Explore <a href="<@s.url value='/occurrence/search'/>" title="">${numOccurrences!0}</a> occurrences</h1>
      <p>Occurrence records document evidence of a named organism in nature.  
      Through this portal, you can <a href="<@s.url value='/occurrence/search'/>" title=""><strong>search</strong>, <strong>view</strong> and <strong>download</strong></a> records that are published through the GBIF network.
      </p>

      <div class="results">
        <ul>
          <li><a href="<@s.url value='/occurrence/search'/>" title="">${numOccurrences!0}</a>occurrences records</li>
          <li class="last"><a href="<@s.url value='/occurrence/search?GEOREFERENCED=true'/>" title="">${numGeoreferenced!0}</a>georeferenced records</li>
        </ul>
      </div>
    </div>
    <footer></footer>
</article>


<article class="occurrence_home">
  <header></header>
  <div class="content">
    <div class="header">
      <div class="left">
        <h2>Temporal characteristics</h2>
      </div>
    </div>
    <div class="left">
      <div id="yearChart" class="graph">
        <div class="start">${minYear?c}</div> <div class="end">${maxYear?c}</div>
      </div>
    </div>
    <div class="right">
      <p>This visualization shows the growth in occurrences reco <a href="<@s.url value='/occurrence/search?YEAR=1950%2C*'/>">after 1950</a>. 
      GBIF provides access to many older records, and you can add date range filters to search content for any period.</p>
      <p>For example, here is a filtered view for records <a href="<@s.url value='/occurrence/search?YEAR=1850%2C1950'/>">between 1850 and 1950</a>.</p>
    </div>
  </div>
  <footer></footer>
</article>

  <@common.article titleRight='${numGeoreferenced!0} georeferenced records' class="map">
    <div id="map" class="map"></div>
    <div class="right">
       <div class="inner">
         <h3>View records</h3>
         <p>
           <a href="<@s.url value='/occurrence/search?GEOREFERENCED=true'/>">All records</a>
           |
           <#-- Note this is intercepted in the map.js to append the bounding box -->
           <a href="<@s.url value='/occurrence/search'/>" class='viewableAreaLink'>In viewable area</a></li>
         </p>
         <h3>About</h3>
         <p>
           This map shows the density of georeferenced occurrence records published through the GBIF network.
         </p>
         <p> 
           To explore the records, zoom into the map or click on the links above and add further filters to customize search results. 
           Note: In this release, only Animalia are shown on the map. Future versions will show all data.  
         </p>
         
       </div>
    </div>
  </@common.article>

<article>
  <header></header>
  <div class="content">
    <h2>Taxonomic characteristics</h2>
    <div class="fullwidth">
      <p>The following provides a summary of number of records per kingdom.  Further filters, such as a location or temporal filter, may be applied when <a href="<@s.url value='/occurrence/search'/>" title="">exploring the data</a>.</p>
      <ul class="summary no_bullets">
        <#list kingdomCounts?keys as k>    
          <#if kingdomCounts.get(k) gt 0>       
            <li class="no_bullets">
            <div class="light_box">
              <h3><a href="<@s.url value='/occurrence/search?TAXON_KEY='/>${action.getKingdomNubUsageId(k)}">${(kingdomCounts.get(k)!0)}</a></h3>
              <div><span class="number" data-cnt="${(kingdomCounts.get(k)!0)?c}">(${(kingdomCounts.get(k) * 100 / numOccurrences)?string("0.####")}%)</span></div>
              <br/>
              <h4><@s.text name="enum.kingdom.${k}"/> records <br/> <br/> </h4>
            </div>
            </li>
          </#if>
        </#list>
      </ul>
    </div>
  </div>
  <footer></footer>
</article>

<article>
  <header></header>
  <div class="content">
    <h2>Characteristics about the nature of records</h2>
    <div class="fullwidth">
      <p>Records may originate from a variety of means, such as a scientist collecting a specimen or an individual recording the sighting of an organism.  This is classified by the <a target="_blank" href="http://rs.tdwg.org/dwc/terms/#basisOfRecord">Darwin Core basisOfRecord</a> standard.</p>
      <ul class="summary no_bullets">
        <#assign bofCounts=action.basisOfRecordCounts>
        <#assign bofCountsTotal=0>
        <#if bofCounts?has_content>
          <#list bofCounts?keys as k>    
            <#if bofCounts.get(k) gt 0>       
              <li class="no_bullets">
              <div class="light_box">
                <h3><a href="<@s.url value='/occurrence/search?BASIS_OF_RECORD='/>${k}">${(bofCounts.get(k)!0)}</a></h3>
                <div><span class="number" data-cnt="${(bofCounts.get(k)!0)?c}">(${(bofCounts.get(k) * 100 / numOccurrences)?string("0.###")}%)</span></div>
                <br/>
                <h4><@s.text name="enum.basisofrecord.${k}"/> records <br/> <br/> </h4> 
              </div>
              </li>
            </#if>
          </#list>
        </#if>
      </ul>
    </div>
  </div>
  <footer></footer>
</article>


</body>
</html>
