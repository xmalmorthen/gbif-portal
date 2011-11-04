<#import "/WEB-INF/macros/pagination.ftl" as paging>
<html>
<head>
  <title>Synonyms of ${usage.canonicalOrScientificName!}</title>
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
          <h2>${page.count!} Synonyms for "${usage.canonicalOrScientificName!}"</h2>
        </div>
        <div class="right"><h3>Refine your search</h3></div>
      </div>

      <div class="left">

        <#list page.results as item>
        <div class="result">
          <h2><strong>${item.scientificName}</strong><span class="note"></span></h2>
          <#if usage.nub>
            <a class="sourcePopup" id="source${item.key?c}" source="${item.source!}" remarks="${checklists.get(item.checklistKey).name}"></a>
          </#if>
          <div class="footer">${item.taxonomicStatus!} ${item.rank!}</div>
        </div>
        </#list>

        <div class="footer">
          <@paging.pagination page=page url=currentUrl/>
        </div>

      </div>

      <div class="right">
        <div class="refine placeholder_temp">
          <h4>Type of synonym</h4>
          <a href="#" title="Any">Any</a>
        </div>
      </div>

    </div>
    <footer></footer>
  </article>

</body>
</html>
