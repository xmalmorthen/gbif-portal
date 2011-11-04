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
          <h2>${page.count!""} References for "${usage.canonicalOrScientificName!}"</h2>
        </div>
        <div class="right"><h3>Refine your search</h3></div>
      </div>

      <div class="left">

        <#list page.results as item>
        <div class="result">
          <h2><strong>${item.title!item.citation!}</strong>
            <span class="note">${item.type!}<#if item.link?has_content> <a href="" target="_blank">link</a></#if></span>
            <#if usage.nub>
              <a class="sourcePopup" id="source${item.key?c}" title="Source" source="<a href='<@s.url value='/species/${item.usageKey?c}'/>'>${checklists.get(item.checklistKey).name}</a>"></a>
            </#if>
          </h2>
          <div class="footer">
            <#if item.citation?has_content>
              ${item.citation}
            <#else>
              ${item.author!} ${item.title!} ${(item.date?date?string)!}
            </#if>
            <br/>
            <#if item.doi?has_content>
              <a href="http://dx.doi.org/${item.doi}" target="_blank">DOI ${item.doi}</a>
            </#if>
        </div>
        </div>
        </#list>

        <div class="footer">
          <@paging.pagination page=page url=currentUrl/>
        </div>

      </div>

      <div class="right">
        <div class="refine placeholder_temp">
          <h4>Author</h4>
          <a href="#" title="Any">Any</a>
        </div>
      </div>


    </div>
    <footer></footer>
  </article>

</body>
</html>
