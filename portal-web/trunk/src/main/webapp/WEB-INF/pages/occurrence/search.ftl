<#import "/WEB-INF/macros/pagination.ftl" as macro>
<html>
<head>
  <title>Occurrence Search Results</title>
  <meta name="menu" content="occurrences"/>
</head>
<body class="search typesmap">

<content tag="infoband">
  <h2>Search occurrences</h2>

  <form action="<@s.url value='/occurrence/search'/>" method="GET">
    <input type="text" name="q"/>    
  </form>
</content>

<article class="results light_pane taxonomies">
  <header></header>
  <div class="content">

    <div class="header">
      <div class="left">
        <h2>${searchResponse.count} results</h2>
      </div>
      <div class="right"><h3>Refine your search</h3></div>
    </div>

    <div class="left no_border">

      <div class="result_summary">

        <div id="map_canvas">
          <div id="map"></div>
          <div class="tl"></div>
          <div class="tr"></div>
          <div class="bl"></div>
          <div class="br"></div>
        </div>

        <div class="geographic_coverage">
          <h3>Geographic coverage</h3>

          <p>145,273 geolocated results of ${searchResponse.count}</p>
        </div>

        <p class="maptype"><a class="selected" href="#" title="points">points</a></p>

        <div class="temporal_coverage">
          <h3>Temporal coverage</h3>

          <p>Jan 1st, 2001 → Jan 1st, 2009</p>
        </div>

        <div class="taxonomic_coverage">
          <h3>Taxonomical coverage</h3>

          <div id="taxonomy">
            <div class="inner">
              <div class="sp">
                <ul>
                  <li data="238"><span>Acantocephala</a></span></li>
                  <li data="128"><span>Annelida</a></span></li>
                  <li data="98"><span>Acantocephala</a></span></li>
                  <li data="96"><span>Annelida</a></span></li>
                  <li data="45"><span>Acantocephala</a></span></li>
                  <li data="37"><span>Annelida</a></span></li>
                  <li data="23"><span>Acantocephala</a></span></li>
                  <li data="9"><span>Annelida</a></span></li>
                  <li data="3"><span>Acantocephala</a></span></li>
                </ul>
              </div>
            </div>
          </div>

        </div>

        <a href="#" class="sort" title="Sort by relevance" id="sort_results">Sort by relevance <span class="more"></span></a>
      </div>
                   
      <#list searchResponse.results as occ>
          <div class="result searchResult">
            <h2>
              <a href="<@s.url value='/occurrence/${occ.id?c}'/>"><strong>${occ.scientificName}</strong>
              <#if occ.catalogNumber?has_content>
                - ${occ.catalogNumber}
              </#if>
              </a>
            </h2>
            <div class="footer">
              <#if occ.isoCountryCode?has_content>${occ.isoCountryCode} |</#if> 
              <#if occ.datasetKey?has_content><a href="<@s.url value='/dataset/${occ.datasetKey?c}'/>">Dataset Title</a> |</#if>
              <#if occ.basisOfRecord?has_content>${occ.basisOfRecord} |</#if>
              <#if occ.latitude?has_content>Latitude: ${occ.latitude?c} |</#if>
              <#if occ.longitude?has_content>Longitude: ${occ.longitude?c} |</#if>             
              <#if occ.occurrenceYear?has_content>Year: ${occ.occurrenceYear?c} |</#if>
              <#if occ.occurrenceMonth?has_content>Month: ${occ.occurrenceMonth?c}</#if>
            </div>
          </div>
        </#list>        
        <div class="footer">
            <@macro.pagination page=searchResponse url=currentUrl/>
        </div>                            
  </div>
  <div class="right">
    <form action="<@s.url value='/occurrence/search'/>" method="GET">
          <input type="hidden" name="offset" value="${offset!}"/>
          <div class="refine">
            <h4>Year</h4>
            <input type="text" name="year" value="${year!}"/>
          </div>
    
          <div class="refine">
            <h4>Month</h4>
            <input type="text" name="month" value="${month!}"/>
          </div>
    
          <div class="refine">
            <h4>Latitude</h4>
            <input type="text" name="latitude" value="${latitude!}"/>
          </div>
    
          <div class="refine">
            <h4>Longitude</h4>
            <input type="text" name="longitude" value="${longitude!}"/>
          </div>
          
          <div class="refine">
            <h4>Catalog number</h4>
            <input type="text" name="catalogueNumber" value="${catalogueNumber!}"/>
          </div>
          
          <div class="refine">
            <h4>Nub key</h4>
            <input type="text" name="nubKey" value="${nubKey!}"/>
          </div>
          
          <div class="refine">            
            <input type="submit" value="Search" />
          </div>
  </form>
          
          <div class="download">
            <div class="dropdown">
              <a href="#" class="title" title="Download description"><span>Download occurrences</span></a>
              <ul>
                <li><a href="#a"><span>Download occurrences</span></a></li>
                <li><a href="#a"><span>Download placemarks</span></a></li>
                <li class="last"><a href="#b"><span>Download metadata</span></a></li>
              </ul>
            </div>
          </div>
   </div>   
   </div>
   <footer></footer>  
</article>

</body>
</html>
