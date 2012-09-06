<#import "/WEB-INF/macros/pagination.ftl" as paging>
<#import "/WEB-INF/macros/common.ftl" as common>
<html>
<head>
  <title>Vernacular Names for ${usage.canonicalOrScientificName!}</title>
</head>

<body class="species">

<#assign tabhl=true />
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
          <h2>${page.count!} Vernacular Names for "${usage.canonicalOrScientificName!}"</h2>
        </div>
      </div>

      <div class="fullwidth">

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

    </div>
    <footer></footer>
  </article>

</body>
</html>
