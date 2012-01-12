<#import "/WEB-INF/macros/pagination.ftl" as macro>
<html>
<head>
  <title>Species Search Results for ${q!}</title>
  <meta name="menu" content="species"/>  
  <content tag="extra_scripts">    
    <script type="text/javascript" src="<@s.url value='/js/facets.js'/>">
    </script>
  </content>
  <style type="text/css">
#resetFacets{
  clear: both;
  overflow: hidden;
  margin-bottom: 20px;
}
  </style>
</head>
<body class="search">  
  <content tag="infoband">
    <h2>Search species</h2>
    <form action="<@s.url value='/species/search'/>" method="GET" id="formSearch">
      <input type="text" name="q" value="${q!}"/>
      <#list facets?keys as facetFilter>
        <#list facets.get(facetFilter) as filterValue>
        <input type="hidden" name="${facetFilter!?lower_case}" value="${filterValue.name!}"/>        	
        </#list>
      </#list>
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
        <div class="result searchResult">
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
              <li<#if !usageKey_has_next>class="last"</#if>><a class="higherTaxonLink" title="Add as higher taxon filter" key="${usageKey}" href="#">${classification.get(usageKey)!"???"}</a></li>
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

			<div id="resetFacets" currentUrl="">
        <input id="resetFacetsButton" value="reset" type="button"/>
        <input class="defaultFacet" type="hidden" name="checklist" value="nub"/>
			</div>

        <#assign seeAllFacets = ["HIGHERTAXON","RANK","CHECKLIST"]>
        <#list ["CHECKLIST","HIGHERTAXON","RANK","TAXSTATUS","EXTINCT","THREAT","MARINE"] as facetName>
          <#assign displayedFacets=0>
          <#assign seeAll=false>

            <#if (facetCounts[facetName]?has_content && facetCounts[facetName]?size > 1)>
             <div class="refine">
              <h4><@s.text name="search.facet.${facetName}" /></h4>
              <div class="facet">
                <ul id="facetfilter${facetName}">
                <#list selectedFacetCounts[facetName] as count>
                  <#assign displayedFacets = displayedFacets + 1>
                  <li>
                    <a href="#" title="${count.title!"Unknown"}">${count.title!"Unknown"}</a> (${count.count})
                    <input type="checkbox" value="&${facetName?lower_case}=${count.name!}" checked/>
                  </li>
                </#list>
                <#list facetCounts[facetName] as count>
                  <#if seeAllFacets?seq_contains(facetName) && (displayedFacets > MaxFacets)>
                    <#assign seeAll=true>
                    <#break>
                  </#if>
                  <#if !(action.isInFilter(facetName,count.name))>
                    <#assign displayedFacets = displayedFacets + 1>
                    <li>
                      <a href="#" title="${count.title!"Unknown"}">${count.title!"Unknown"}</a> (${count.count})
                      <input type="checkbox" value="&${facetName?lower_case}=${count.name!}"/>
                    </li>
                  </#if>
                </#list>
                <#if seeAll>
                  <li class="seeAllFacet">
                    <a class="seeAllLink" href="#">&nbsp;&nbsp;see all ...</a>
                    <div class="infowindow dialogPopover" style="z-index:100000">
                        <div class="lheader"></div>
                        <span class="close"></span>
                        <div class="content">
                          <h2>Filter by <@s.text name="search.facet.${facetName}" /></h2>
                         <ul>
                           <#list facetCounts[facetName] as count>
                          <li>
                            <a href="#" title="${count.title!"Unknown"}">${count.title!"Unknown"}</a> (${count.count})
                        <input type="checkbox" value="&${facetName?lower_case}=${count.name!}" <#if (action.isInFilter(facetName,count.name))>checked</#if>>
                          </li>
                          </#list>
                         </ul>
                       </div>
                       <div class="lfooter"></div>
                     </div>
                  </li>
                </#if>
                </ul>
              </div>
             </div>
            </#if>                      
        </#list>
	   
        <div class="last">
          <a href="#" title="Add another criterion" class="add_criteria placeholder_temp">Add another criterion <span class="more"></span></a>
	      </div>

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
  </article>  
  </form>    
  <div class="infowindow" id="waitDialog">	  
	  <div class="light_box">	  
		  <div class="content" >
		    <h3>Processing request</h3>
		    <p>Wait while your request is processed...	
		    <img src="<@s.url value='/img/ajax-loader.gif'/>"/></p>
		 </div>
	 </div>	 
   </div>         
</body>
</html>
