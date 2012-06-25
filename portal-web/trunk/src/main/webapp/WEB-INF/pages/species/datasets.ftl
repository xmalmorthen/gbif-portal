<#import "/WEB-INF/macros/pagination.ftl" as paging>
<#import "/WEB-INF/macros/common.ftl" as common>
<html>
<head>
  <title>Datasets with ${usage.canonicalOrScientificName!}</title>
  <meta name="menu" content="species"/>
</head>
<body class="species">

<#include "/WEB-INF/pages/species/infoband.ftl">

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
          <h2><strong><a href="<@s.url value='/dataset/${item.key}'/>">${item.title!}</a></strong>
            <span class="note">${item.type}, ${item.networkOfOrigin} network</span>
          </h2>

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
