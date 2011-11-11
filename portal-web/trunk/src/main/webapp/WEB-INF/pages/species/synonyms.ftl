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

        <#list page.results as u>
        <div class="result">
          <h2>
            <a href="<@s.url value='/species/${u.key?c}'/>"><strong>${u.scientificName}</strong></a>
            <span class="note"><@s.text name="enum.rank.${u.rank}"/></span>
          </h2>
          <#if usage.nub>
            <p>according to ${u.accordingTo!u.origin}</p>
          </#if>
          <div class="footer">${u.taxonomicStatus!} ${u.nomenclaturalStatus!}</div>
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
