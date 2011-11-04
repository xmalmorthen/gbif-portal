<#import "/WEB-INF/macros/pagination.ftl" as paging>
<html>
<head>
  <title>Vernacular Names for ${usage.canonicalOrScientificName!}</title>
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
          <h2>${page.count!} Vernacular Names for "${usage.canonicalOrScientificName!}"</h2>
        </div>
        <div class="right"><h3>Refine your search</h3></div>
      </div>

      <div class="left">

        <#list page.results as item>
        <div class="result">
          <h2><strong>${item.vernacularName}</strong><span class="note">${item.language!}</span></h2>
          <#if usage.nub || item.source?has_content>
            <a class="sourcePopup" id="source${item.key?c}" source="${item.source!}"
            <#if usage.nub>remarks="<a href='<@s.url value='/dataset/${item.checklistKey}'/>'>${checklists.get(item.checklistKey).title}</a>"</#if>
            ></a>
          </#if>
          <div class="footer">${item.lifeStage!} ${item.sex!} ${item.country!} ${item.area!}</div>
        </div>
        </#list>

        <div class="footer">
          <@paging.pagination page=page url=currentUrl/>
        </div>

      </div>

      <div class="right">
        <div class="refine placeholder_temp">
          <h4>Language</h4>
          <a href="#" title="Any">Any</a>
        </div>
      </div>

    </div>
    <footer></footer>
  </article>

</body>
</html>
