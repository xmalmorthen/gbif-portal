<#import "/WEB-INF/macros/pagination.ftl" as paging>
<html>
<head>
  <title>Species synonyms - GBIF</title>
  <meta name="menu" content="species"/>
</head>
<body class="species">

<#include "/WEB-INF/pages/species/infoband.ftl">

  <div class="back">
    <div class="content">
      <a href="<@s.url value='/species/${id!}'/>" title="Back to species overview">Back to species overview</a>
    </div>
  </div>

  <article class="results light_pane">
    <header></header>
    <div class="content">

      <div class="header">
        <div class="left">
          <h2>23 synonyms for "Puma Concolor"</h2>
        </div>
        <div class="right"><h3>Refine your search</h3></div>
      </div>

      <div class="left">

        <#list items as item>
        <div class="result">
          <h2><strong>${item.scientificName}</strong><span class="note">Linnaeus 1771</span></h2>
          <div class="footer">${item.taxonomicStatus!} ${item.rank!}</div>
        </div>
        </#list>

        <div class="footer">
          <@paging.pagination offset=page.offset limit=page.limit url=currentUrl/>
        </div>

      </div>

      <div class="right">

        <div class="refine placeholder_temp">
          <h4>Type of synonym</h4>
          <a href="#" title="Any">Any</a>
        </div>

        <div class="download">
        </div>

      </div>

    </div>
    <footer></footer>
  </article>

</body>
</html>
