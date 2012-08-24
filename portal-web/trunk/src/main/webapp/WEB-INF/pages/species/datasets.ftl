<#import "/WEB-INF/macros/pagination.ftl" as paging>
<#import "/WEB-INF/macros/common.ftl" as common>
<html>
<head>
  <title>Datasets with ${usage.canonicalOrScientificName!}</title>

</head>
<body class="species">

<#include "/WEB-INF/pages/species/inc/infoband.ftl">

  <div class="back">
    <div class="content">
      <a href="<@s.url value='/species/${id?c}'/>" title="Back to species overview">Back to species overview</a>
    </div>
  </div>

  <article class="results light_pane">
    <header></header>
    <div class="content">

      <div class="header">
        <div class="left">
          <h2>Datasets with "${usage.canonicalOrScientificName!}"</h2>
        </div>
        <div class="right"><h3>Statistics</h3></div>
      </div>

      <div class="left">

      <#list page.results as item>
        <div class="result">
          <h2><strong>
            <#if item.type=="CHECKLIST">
              <a href="<@s.url value='/species/${relatedUsages[item_index].key?c}'/>">
            <#else>
              <a href="<@s.url value='/occurrence/search?nubKey=${usage.nubKey?c}&datasetKey=${item.key}'/>">
            </#if>
            ${item.title!}</a>
            </strong>
          </h2>

          <div class="footer">
          <#if item.type=="CHECKLIST">
            ${relatedUsages[item_index].scientificName},
          </#if>
            ${item.type},
            ${item.networkOfOrigin} network
          </div>

          <div class="footer">
            <#if item.citation?has_content>
              <@common.citation item.citation/>
            </#if>
          </div>
        </div>
      </#list>

        <div class="footer">
        <@paging.pagination page=page url=currentUrl/>
        </div>

      </div>

      <div class="right placeholder_temp">
        <h3>Dataset Type</h3>
        <ul>
          <li>Nomenclature <a class="number">3</a></li>
          <li>Taxonomy <a class="number">6</a></li>
          <li>Genetics <a class="number">2</a></li>
        </ul>
      </div>

    </div>
    <footer></footer>
  </article>

</body>
</html>
