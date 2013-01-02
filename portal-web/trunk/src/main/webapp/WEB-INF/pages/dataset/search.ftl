<#import "/WEB-INF/macros/common.ftl" as common>
<#import "/WEB-INF/macros/pagination.ftl" as macro>
<html>
<head>
  <title>Dataset Search Results for ${q!}</title>

  <content tag="extra_scripts">
    <script type="text/javascript" src="<@s.url value='/js/facets.js'/>">
    </script>
    <script type="text/javascript" src="<@s.url value='/js/vendor/jquery-ui-1.8.17.min.js'/>"></script>
      <script type="text/javascript" src="<@s.url value='/js/dataset_autocomplete.js'/>"></script>
      <script>
        $("#q").datasetAutosuggest(cfg.wsRegSuggest,4,"#content");
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
      <input type="text" name="q" id="q" value="${q!}" class="focus" placeholder="Search title, description, publisher..."/>
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
        <div class="result">
          <h3><@s.text name="enum.datasettype.${dataset.type!'UNKNOWN'}"/></h3>

          <h2>
            <a href="<@s.url value='/dataset/${dataset.key!}'/>" title="${action.removeHighlighting(dataset.title!)}"><strong>${action.limitHighlightedText(dataset.title!, 80)}</strong></a>
          </h2>

          <#if dataset.owningOrganizationKey?has_content>
            <p>
              <#if recordCounts.get(dataset.key)??>
                ${recordCounts.get(dataset.key)} records published by
              <#else>
                Published by
              </#if>
              <a href="<@s.url value='/organization/${dataset.owningOrganizationKey}'/>" title="${action.removeHighlighting(dataset.owningOrganizationTitle!)}">${dataset.owningOrganizationTitle!"Unknown"}</a></p>
          <#elseif dataset.networkOfOriginKey?has_content>
            <p>Originates from <a href="<@s.url value='/network/${dataset.networkOfOriginKey}'/>" title="${action.removeHighlighting(titles[dataset.networkOfOriginKey]!)}">${titles[dataset.networkOfOriginKey]!"Unknown"}</a></p>
          </#if>

          <div class="footer">
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
		    <img src="<@s.url value='/img/ajax-loader.gif'/>" alt=""/>
		  </div>
	  </div>
   </div>
</body>
</html>
