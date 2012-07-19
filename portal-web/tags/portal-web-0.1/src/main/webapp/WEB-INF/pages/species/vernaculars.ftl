<#import "/WEB-INF/macros/pagination.ftl" as paging>
<#import "/WEB-INF/macros/common.ftl" as common>
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
        <div class="right"><h3>Statistics</h3></div>
      </div>

      <div class="left">

        <#list page.results as item>
        <div class="result">
          <h2><strong>${item.vernacularName}</strong><span class="note">${item.language!}</span>
            <@common.usageSource component=item showChecklistSource=usage.nub />
          </h2>
          <div class="footer">${item.lifeStage!} ${item.sex!} ${item.country!} ${item.area!}</div>
        </div>
        </#list>

        <div class="footer">
          <@paging.pagination page=page url=currentUrl/>
        </div>

      </div>

      <div class="right placeholder_temp">
        <h3>Language</h3>
        <ul>
          <li>English <a class="number">1</a></li>
          <li>German <a class="number">4</a></li>
          <li>French<a class="number">2</a></li>
        </ul>
      </div>

    </div>
    <footer></footer>
  </article>

</body>
</html>
