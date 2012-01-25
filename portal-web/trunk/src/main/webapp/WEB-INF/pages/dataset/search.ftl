<#import "/WEB-INF/macros/pagination.ftl" as macro>
<html>
<head>
  <title>Dataset Search Results for ${q!}</title>
  <meta name="menu" content="dataset"/>
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
    <h2>Search datasets</h2>
    <form action="<@s.url value='/dataset/search'/>" method="GET" id="formSearch">
      <input type="text" name="q" value="${q!}" class="focus"/>
      <#list facets?keys as facetFilter>
        <#list facets.get(facetFilter) as filterValue>
        <input type="hidden" name="${facetFilter!?lower_case}" value="${filterValue.name!}"/>
        </#list>
      </#list>
    </form>
  </content>

  <form action="<@s.url value='/dataset/search'/>">
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
      <#list searchResponse.results as dataset>
        <div class="result searchResult">
          <h2><a href="<@s.url value='/dataset/${dataset.key!}'/>"
                 title="${dataset.title!}"><strong>${dataset.title!}</strong></a>
          </h2>

          <p>Type <span>${dataset.type!"Unknown"}</span>, published by
            <a href="<@s.url value='/member/${dataset.owningOrganizationKey!}'/>"
               title="${dataset.owningOrganizationTitle!}">
              <strong>${dataset.owningOrganizationTitle!"Unknown"}</strong></a> in <span
                    class="placeholder_temp">1983</span>
          </p>

          <div class="placeholder_temp footer"><p>201.456 occurrences | covering Europe, Asia, Africa and Oceania</p>
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


        <#--
        TODO: add more facets
        DECADE, DATA_AVAILABLE, DATA_INDEXABLE, COUNTRY_CODE, CONTINENT
        -->

      <#assign seeAllFacets = ["OWNING_ORG", "HOSTING_ORG", "KEYWORD", "COUNTRY_CODE"]>
      <#assign facets= ["REGISTERED", "NETWORK_ORIGIN", "TYPE", "SUBTYPE", "KEYWORD", "OWNING_ORG", "HOSTING_ORG", "DECADE", "DATA_AVAILABLE", "COUNTRY_CODE"]>
      <#include "/WEB-INF/inc/facets.ftl">

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