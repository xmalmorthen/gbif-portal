<#import "/WEB-INF/macros/pagination.ftl" as paging>
<html>
<head>
  <title>Synonyms of ${usage.canonicalOrScientificName!}</title>

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
          <h2>${page.count!} Synonyms for "${usage.canonicalOrScientificName!}"</h2>
        </div>
        <div class="right"><h3>Statistics</h3></div>
      </div>

      <div class="left">

      <#list page.results as u>
        <div class="result">
          <h2>
            <a href="<@s.url value='/species/${u.key?c}'/>"><strong>${u.scientificName}</strong></a>
            <span class="note"><@s.text name='enum.rank.${(u.rank.interpreted)!"UNRANKED"}'/></span>
          </h2>
          <#if usage.nub>
            <p>according to ${u.accordingTo!u.origin!}</p>
          </#if>
          <div class="footer">${(u.taxonomicStatus.interpreted)!} ${(u.nomenclaturalStatus.interpreted)!}</div>
        </div>
      </#list>

        <div class="footer">
        <@paging.pagination page=page url=currentUrl/>
        </div>

      </div>

      <div class="right placeholder_temp">
        <h3>Type of synonym</h3>
        <ul>
          <li>Synonym <a class="number">10</a></li>
          <li>Heterotypic <a class="number">4</a></li>
          <li>Homotypic <a class="number">1</a></li>
        </ul>
      </div>

    </div>
    <footer></footer>
  </article>

</body>
</html>
