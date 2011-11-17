<#import "/WEB-INF/macros/pagination.ftl" as paging>
<#import "/WEB-INF/macros/common.ftl" as common>
<#import "/WEB-INF/macros/specimen/specimenRecord.ftl" as specimenRecord>
<html>
<head>
  <title>Type Specimens for ${usage.canonicalOrScientificName!}</title>
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
          <h2>${page.count!} Type Specimens for "${usage.canonicalOrScientificName!}"</h2>
        </div>
        <div class="right"><h3>Refine your search</h3></div>
      </div>
      <div class="left">

      <#list page.results as item>
        <@specimenRecord.record ts=item showAsSearchResult=true />
      </#list>
        <div class="footer">
        <@paging.pagination page=page url=currentUrl/>
        </div>
      </div>

      <div class="right">
        <div class="refine placeholder_temp">
          <h4>Type</h4>
          <a href="#" title="Any">Any</a>
        </div>
      </div>

    </div>
    <footer></footer>
  </article>

</body>
</html>
