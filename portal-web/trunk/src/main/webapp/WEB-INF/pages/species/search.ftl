<#import "/WEB-INF/macros/pagination.ftl" as macro>
<html>
<head>
  <title>Species Search Results for ${q!}</title>
  <meta name="menu" content="species"/>  
  <content tag="extra_scripts">    
    <script type="text/javascript" src="<@s.url value='/js/facets.js'/>">
    </script>
  </content>
</head>
<body class="search">  
  <content tag="infoband">
    <h2>Search species</h2>
    <form action="<@s.url value='/species/search'/>" method="GET">
      <input type="text" name="q"/>
    </form>
  </content>

  <form action="<@s.url value='/species/search'/>">
  <article class="results light_pane">
    <input type="hidden" name="q" value="${q!}"/>
    <header></header>
    <div class="content">
      <div class="header">
        <div class="left">
          <h2>${searchResponse.count!} results for "${q!}"</h2>
          <#-- <a href="#" class="sort" title="Sort by relevance">Sort by relevance <span class="more"></span></a> -->
        </div>
        <div class="right"><h3>Refine your search</h3></div>
      </div>

      <div class="left">

      <#list searchResponse.results as u>
        <div class="result">
          <h2>
            <a href="<@s.url value='/species/${u.key?c}'/>" title="${u.scientificName}"><strong>${u.scientificName}</strong></a>
            <span class="note">
             <#if u.rank??><@s.text name="enum.rank.${u.rank}"/></#if>
             <#if u.synonym><#if u.proParte>pro parte </#if>synonym</#if>
            </span>
          </h2>
          <#if showAccordingTo>
            <p>according to ${u.checklistTitle}</p>
          </#if>
          <#if u.synonym>
            <p>Accepted name <a href="<@s.url value='/species/${u.acceptedKey?c}'/>">${u.accepted!"???"}</a></p>
          </#if>
          <div class="footer">
          <p>
            <#if u.vernacularNamesLanguages?has_content>
             <#list u.vernacularNamesLanguages as vn>
                <strong>${vn!c}</strong>
                <#if vn_has_next> - </#if>
              </#list>
             </#if>
            </p>
            <ul class="taxonomy">
            <#assign classification=u.higherClassificationMap />            
            <#list classification?keys as usageKey>
              <li<#if !usageKey_has_next>class="last"</#if>><a class="higherTaxonLink" key="${usageKey}" href="#">${classification.get(usageKey)!"???"}</a></li>
            </#list>             
            </ul>
          </div>
        </div>
      </#list>

        <div class="footer">
          <@macro.pagination page=searchResponse url=currentUrl/>
        </div>
      </div>
      <div class="right">
      <#if (facets?has_content)>      		
		<div class="refine">
          <h4>Selected filters: </h4>
          <div id="selectedFilters" class="facet">                               
          <#list facets?keys as facetFilter>
            <#list facets.get(facetFilter) as filterValue>
            	<div class="facetFilter">
	              	<p>
	              	 <span class="flabel" val="${filterValue.name!}">${facetFilter}</span> : ${filterValue.title!"Unknown"} <a href="#">[X]</a>
	                </p>
              	</div>
            </#list>
          </#list>                                      
          </div>
        </div>
	   </#if>

        <#list ["HIGHERTAXON","RANK","CHECKLIST","TAXSTATUS","EXTINCT","THREAT","HABITAT"] as facetName>
                      
            <#if (facetCounts[facetName]?has_content && facetCounts[facetName]?size > 1)>
             <div class="refine">
              <h4><@s.text name="search.facet.${facetName}" /></h4>
              <div class="facet">
              <ul id="facetfilter${facetName}">
              <#list facetCounts[facetName] as count>
                <#if (count_index > MaxFacets)>
                  <#break>
                </#if>                
                <li>
                	<a href="#" title="${count.title!"Unknown"}">${count.title!"Unknown"}</a> (${count.count})
                	<input type="checkbox" value="&${facetName?lower_case}=${count.name!}${action.getDefaultFacetsFiltersQuery()}" <#if (action.isInFilter(facetName,count.name))>checked</#if>>
                </li>
              </#list>
              </ul>
              <#if (facetCounts[facetName]?size > MaxFacets)>
                <div class="facetPanel">
                    <a href="#">see all...</a>
                   <div class="infowindow dialogPopover" style="z-index:100000">
                      <div class="lheader"></div>
                      <span class="close"></span>
                      <div class="content">
                        <h2>Filter by <@s.text name="search.facet.${facetName}" /></h2>
                       <ul>
                         <#list facetCounts[facetName] as count>
                        <li>
                        	<a href="#" title="${count.title!"Unknown"}">${count.title!"Unknown"}</a> (${count.count})
                			<input type="checkbox" value="&${facetName?lower_case}=${count.name!}${action.getDefaultFacetsFiltersQuery()}" <#if (action.isInFilter(facetName,count.name))>checked</#if>>
                        </li>
                        </#list>
                       </ul>
                     </div>
                     <div class="lfooter"></div>
                   </div>
                 </div>
              </#if>
              </div>
              </div>
            </#if>                      
        </#list>
	   
        <a href="#" title="Add another criterion" class="add_criteria placeholder_temp">Add another criterion <span class="more"></span></a>
	
        <div class="download placeholder_temp">
          <div class="dropdown">
            <a href="#" class="title" title="Download list"><span>Download list</span></a>
            <ul>
              <li><a href="#a"><span>Download list</span></a></li>
              <li><a href="#b"><span>Download metadata</span></a></li>
              <li class="last"><a href="#b"><span>Download metadata</span></a></li>
            </ul>
          </div>
        </div>
      </div>
    </div>
    <footer></footer>
    <div class="infowindow" id="waitDialog">
	  
	  <div class="light_box">
	   <div class="content" >
		    <h3>Processing request</h3>
		    <p>Wait while your request is processed...</p>	
		    <img src="/img/ajax-loader.gif"/>   
		 </div>	  	  
	 </div>
	 
   </div>                 
  </article>  
  </form>    
</body>
</html>
