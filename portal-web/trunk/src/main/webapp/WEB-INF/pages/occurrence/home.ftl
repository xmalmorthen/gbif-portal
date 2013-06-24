<html>
<head>
  <title>Occurrences - GBIF</title>
   <content tag="extra_scripts"> 
    <link rel="stylesheet" href="<@s.url value='/js/vendor/leaflet/leaflet.css'/>" />
      <!--[if lte IE 8]><link rel="stylesheet" href="<@s.url value='/js/vendor/leaflet/leaflet.ie.css'/>" /><![endif]-->
      <script type="text/javascript" src="<@s.url value='/js/vendor/leaflet/leaflet.js'/>"></script>      
    <script>    
      $(document).ready(function() {
        function setupPie(legend) {
                var total = parseInt($(legend).find(".total").val());
                var pieId = legend.attr("id") + "pie";
                $(legend).before("<div id='" +pieId+ "' class='multipie'></div>");
                var values = [];
                $("li span.number", legend).each(function() {
                    values.push( Math.round($(this).attr("data-cnt") * 100 / total))
                });
                console.debug(pieId + ": " + values);
                $("#"+pieId).bindMultiPie(36.5, values);
                $(legend).addMultiLegend();
              }
        setupPie($("#basisOfRecord"));
        setupPie($("#kingdom"));    
        var yearsValues = new Array();  
        <#assign yearCounts=action.yearCounts>  
        <#list yearCounts?keys as k>    
          <#if yearCounts.get(k) gt 0>       
           yearsValues.push(${yearCounts.get(k)?c});
          </#if>               
       </#list>
        $("#yearChart").addGraph(yearsValues, {height:120});
      });     
    </script>
    <script>
    var baseUrl = cfg.tileServerBaseUrl + '/density/tile?x={x}&y={y}&z={z}&type=TAXON&key=1';       
    var gbifAttrib='GBIF contributors';
    var gbif = new L.TileLayer(baseUrl, {minZoom: 0, maxZoom: 14, attribution: gbifAttrib});   
      var cmAttr = 'Map data &copy; 2011 OpenStreetMap contributors, Imagery &copy; 2011 CloudMade',
      cmUrl = 'http://{s}.tile.cloudmade.com/BC9A493B41014CAABB98F0471D759707/{styleId}/256/{z}/{x}/{y}.png';
      var minimal   = L.tileLayer(cmUrl, {styleId: 22677, attribution: cmAttr});
      var midnight  = L.tileLayer(cmUrl, {styleId: 999,   attribution: cmAttr});

    var map = L.map('map', {
      center: [0, 0],
      zoom: 1,
      layers: [midnight, gbif]
    });

    L.control.layers({"Minimal": minimal, "Midnight":midnight}, {"GBIF": gbif}).addTo(map);               
    
      </script>
   </content>
</head>
<body class="home_section">    
  <article class="occurrence_home">
   <header>      
   </header>
   <div class="content">
     <div class="header">
      <h2>Occurrence data</h2>
      <div class="description"><p>An occurrence record documents the existence of an organism at a certain place and time. 
      Different types of occurrence records relate to specimens in collections (vouchers), observations as well as image or sound recordings.</p></div>
      <ul>
        <li><a href="<@s.url value='/occurrence/search'/>" title="">${numOccurrences!0}</a>explore and download</li>
        <li><a href="<@s.url value='/occurrence/search?GEOREFERENCED=true'/>" title="">${numGeoreferenced!0}</a>georeferenced</li>          
      </ul>
     </div>             
    </div>            
   <footer></footer>
  </article>
  
  <article class="occurrence_home">
   <header>          
   </header>
   <div class="content">
      <h2>Data content characteristics</h2>        
     <div class="fullwidth">        
         <ul class="pies">
            <li style="height:145px;">
             <div id="yearChart" class="graph">                  
              <div class="start">${minYear?c}</div> <div class="end">${maxYear?c}</div>
             </div>                  
             <div class="chart_caption">Year of occurrence</div>
           </li> 
           <li style="height:145px;">
             <#assign kingdomCounts=action.kingdomCounts>
             <#assign kingdomCountsTotal=0>
             <#if kingdomCounts?has_content>
               <div id="kingdom" class="pieMultiLegend">
                 <ul>
                 <#list kingdomCounts?keys as k>    
                    <#if kingdomCounts.get(k) gt 0>       
                     <li><a href="<@s.url value='/occurrence/search?TAXON_KEY='/>${action.getKingdomNubUsageId(k)}"><@s.text name="enum.kingdom.${k}"/></a> <span class="number" data-cnt="${(kingdomCounts.get(k)!0)?c}">${kingdomCounts.get(k)!0}(${(kingdomCounts.get(k) * 100 / numOccurrences)?string("0.####")}%)</span></li>
                     <#assign kingdomCountsTotal=kingdomCountsTotal + kingdomCounts.get(k)>
                    </#if>               
                 </#list>
                 </ul>
                 <input type="hidden" class="total" value="${kingdomCountsTotal?c}"/>
               </div>
               <div class="chart_caption">Records per kingdom</div>
             </#if>
           </li> 
            <li style="height:145px;">
             <#assign bofCounts=action.basisOfRecordCounts>
             <#assign bofCountsTotal=0>
             <#if bofCounts?has_content>
               <div id="basisOfRecord" class="pieMultiLegend">
                 <ul>
                 <#list bofCounts?keys as k>    
                    <#if bofCounts.get(k) gt 0>       
                     <li><a href="<@s.url value='/occurrence/search?BASIS_OF_RECORD='/>${k}"><@s.text name="enum.basisofrecord.${k}"/></a> <span class="number" data-cnt="${(bofCounts.get(k)!0)?c}">${bofCounts.get(k)!0} (${(bofCounts.get(k) * 100 / numOccurrences)?string("0.##")}%)</span></li>
                     <#assign bofCountsTotal=bofCountsTotal + bofCounts.get(k)>
                    </#if>               
                 </#list>
                 </ul>
                 <input type="hidden" class="total" value="${bofCountsTotal?c}"/>
               </div>
               <div class="chart_caption">Records per basis of record</div>
             </#if>
           </li>                       
         </ul>
       </div>      
    </div>            
   <footer></footer>
  </article>
  
  
  <article class="occurrence_home">
   <header>          
   </header>
   <div class="content">
      <h2>${numGeoreferenced!0} georeferenced records</h2>        
      <div class="left">
        <div id="map" style="width: 600px; height: 400px;">        
             
        </div>
      </div>
      <div class="right">        
        <a href="<@s.url value='/occurrence/search?GEOREFERENCED=true'/>">View all records in visible area</a>
        <p style="font-size:10px;">Once you start exploring you can further customize the geographic bounds.</p>
      </div>           
   </div>                  
   <footer></footer>
  </article>            
</body>
</html>
