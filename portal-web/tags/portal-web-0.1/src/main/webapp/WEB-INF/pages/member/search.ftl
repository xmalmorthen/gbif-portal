<#import "/WEB-INF/macros/pagination.ftl" as macro>
<html>
<head>
  <title>Member Search Results for ${q!}</title>
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
    <h2>Search members</h2>
    <form action="<@s.url value='/member/search'/>" method="GET" id="formSearch">
      <input type="text" name="q" value="${q!}" class="focus"/>
      <#list facets?keys as facetFilter>
        <#list facets.get(facetFilter) as filterValue>
        <input type="hidden" name="${facetFilter!?lower_case}" value="${filterValue.name!}"/>
        </#list>
      </#list>
    </form>
  </content>

  <form action="<@s.url value='/member/search'/>">
  <article class="results light_pane">
    <input type="hidden" name="q" value="${q!}"/>
    <header></header>
    <div class="content">
      <div class="header">
        <div class="left">
          <h2>${searchResponse.count!} results for "${q!}"</h2>
        </div>
        <div class="right"><h3>Refine your search</h3></div>
      </div>

      <div class="left">
      <#list searchResponse.results as mb>
        <div class="result">
            <h2><a href="<@s.url value='/organization/${mb.key}'/>"><strong>${mb.title!"???"}</strong></a></h2>

            <div class="footer">
              <ul>
                <li>${mb.getClass().getSimpleName()}</li>
                <li>${mb.country!mb.isoCountryCode!}</li>
                <li class="last placeholder_temp">11 datasets with 33.522 occurences</li>
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
        </div>


        <#--
        TODO: add more facets
        -->

      <#assign seeAllFacets = []>
      <#assign facets= []>
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