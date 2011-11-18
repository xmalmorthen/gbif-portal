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
          <a href="#" class="sort" title="Sort by relevance">Sort by relevance <span class="more"></span></a>
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
             <#if u.synonym>synonym</#if>
            </span>
          </h2>
          <p>according to ${u.checklistTitle}</p>          
          <div class="footer">
          <p>
            <#if u.vernacularStringNames?has_content>
             <#list u.vernacularStringNames as vn>
                <strong>${vn!c}</strong>
                <#if vn_has_next> - </#if>
              </#list>
             </#if>
            </p>
            <ul class="taxonomy">
            <#assign classification=u.higherClassificationMap />            
            <#list classification?keys as usageKey>                 	
              <li <#if !usageKey_has_next>class="last"</#if>><a href="<@s.url value='/species/${usageKey}'/>">${classification.get(usageKey)}</a></li>              
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
		<div class="refine">
          <h4>Selected filters: </h4>
          <div id="selectedFilters" class="facet">
          <#if facets?has_content>                      
              <#list facets?keys as facetFilter>
                <#list facets[facetFilter] as filterValue>
                	<div class="facetFilter">
		              	<p>
		              	 <span class="flabel">${facetFilter}</span> : ${filterValue} <a href="#" title="${facetFilter}:${filterValue}">[X]</a>
		                </p>
		                <span style="display:none">${facetFilter}</span>
		              	<span style="display:none">${filterValue}</span>
	              	</div>
                </#list>
              </#list>         
          </#if>                    
          </div>
        </div>
        
        <div class="refine">
          <h4>Higher taxon</h4>
          <a href="#" title="Any taxon">Any</a>
        </div>
        <div class="refine">
          <h4>Taxonomic rank</h4>
          <div class="facet">
          <#if facetCounts['RANK']?has_content>
            <ul>
	          <#list facetCounts['RANK'] as count>
	            <#if (count_index > MaxFacets)>
	              <#break>
	            </#if>	            
	            <li><a href="${macro.getStripUrl(currentUrl)}&facets['RANK']=${count.name}" title="${count.name}">${count.name}</a> (${count.count})</li>
	          </#list>
            </ul>
            <#if (facetCounts['RANK']?size > MaxFacets)>
            	<div class="facetPanel">
	                <a href="#">see all...</a>
		           	<div class="infowindow dialogPopover" style="z-index:100000">
		           	   <div class="lheader"></div>
		           	   <span class="close"></span>
		           	   <div class="content">
		           	     <h2>Filter by rank</h2>
						   <ul>
				           	  <#list facetCounts['RANK'] as count>	            
					            <li><a href="${macro.getStripUrl(currentUrl)}&facets['RANK']=${count.name}" title="${count.name}">${count.name}</a> (${count.count})</li>
					          </#list>
				          </ul>
			          </div>
			          <div class="lfooter"></div>
		           	</div>
	           	</div>
            </#if>
          </#if>           
          </div>
        </div>

        <div class="refine">
          <h4>Checklist</h4>
          <div class="facet">
          <#if facetCounts['CHECKLIST']?has_content>                      
            <ul>
              <#list facetCounts['CHECKLIST'] as count>
               <#if (count_index > MaxFacets)>
	              <#break>
	            </#if>
              	<li><a href="${macro.getStripUrl(currentUrl)}&facets['CHECKLIST']=${count.name}" title="${count.name}">${count.name}</a> (${count.count})</li>
              </#list>
            </ul>			
           <#if (facetCounts['CHECKLIST']?size > MaxFacets)>
            	<div class="facetPanel">
	                <a href="#">see all...</a>
		           	<div class="infowindow dialogPopover" style="z-index:100000">
		           	   <div class="lheader"></div>
		           	   <span class="close"></span>
		           	   <div class="content">
		           	     <h2>Filter by checklist</h2>
						   <ul>
				           	  <#list facetCounts['CHECKLIST'] as count>	            
					            <li><a href="${macro.getStripUrl(currentUrl)}&facets['CHECKLIST']=${count.name}" title="${count.name}">${count.name}</a> (${count.count})</li>
					          </#list>
				          </ul>
			          </div>
			          <div class="lfooter"></div>
		           	</div>
	           	</div>
            </#if>
          </#if>          
          </div>
        </div>

        <div class="refine">
          <h4>Status</h4>
          <a href="#" title="Any">Any<span class="more"></span></a>
        </div>

        <div class="refine">
          <h4>Extinction status</h4>
          <a href="#" title="Any">Any<span class="more"></span></a>
        </div>

        <div class="refine">
          <h4>Habitat</h4>
          <a href="#" title="Any">Any<span class="more"></span></a>
        </div>
        
        <a href="#" title="Add another criterion" class="add_criteria">Add another criterion <span class="more"></span></a>

        <div class="download">
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
</body>
</html>
