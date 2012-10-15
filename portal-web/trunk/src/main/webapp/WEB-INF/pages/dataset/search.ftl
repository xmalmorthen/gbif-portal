<#import "/WEB-INF/macros/pagination.ftl" as macro>
<html>
<head>
  <title>Dataset Search Results for ${q!}</title>

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
      <#list searchRequest.parameters.asMap()?keys as p>
        <#list searchRequest.parameters.get(p) as val>
        <input type="hidden" name="${p}" value="${val!}"/>
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
          <h2>${searchResponse.count!} results <#if q?has_content>for &quot;${q}&quot;</#if></h2>
        </div>
        <div class="right"><h3>Refine your search</h3></div>
      </div>


      <div class="left">
      <#list searchResponse.results as dataset>
        <div class="result searchResult">
          <h2>
            <a href="<@s.url value='/dataset/${dataset.key!}'/>" title="${dataset.title!}"><strong>${dataset.title!}</strong></a>
          </h2>

          <p><@s.text name="enum.datasettype.${dataset.type!'UNKNOWN'}"/> 
            <#if recordCounts.get(dataset.key)??>
              with ${recordCounts.get(dataset.key)} records.
            </#if>
          </p>

          <div class="footer">
            <p>Published by <a href="<@s.url value='/organization/${dataset.owningOrganizationKey!}'/>" title="${dataset.owningOrganizationTitle!}">${dataset.owningOrganizationTitle!"Unknown"}</a></p>
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

      <#assign seeAllFacets = ["OWNING_ORG", "HOSTING_ORG", "KEYWORD", "COUNTRY", "DECADE"]>
      <#assign facets= ["TYPE", "SUBTYPE", "NETWORK_ORIGIN", "KEYWORD", "OWNING_ORG", "HOSTING_ORG", "COUNTRY", "DECADE"]>
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