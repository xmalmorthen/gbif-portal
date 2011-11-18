<html>
<head>
  <title>${usage.canonicalOrScientificName!} - Complete Classification</title>
  <meta name="menu" content="species"/>
</head>
<body class="species">


<#assign tab="info"/>
<#include "/WEB-INF/pages/species/infoband.ftl">

  <div class="back">
    <div class="content">
      <a href="<@s.url value='/species/${id!}'/>" title="Back to species overview">Back to species overview</a>
    </div>
  </div>

  <article class="classification">
    <header></header>
    <div class="content">

      <div class="header">
        <div class="left">
          <hgroup>
            <h2>${parents?size} taxonomy levels for "${usage.canonicalOrScientificName!"???"}"</h2>
            <h3>According to <a href="<@s.url value='/dataset/${usage.checklistKey}'/>">${checklist.name!"???"}</a></h3>
          </hgroup>
        </div>
      </div>

      <div class="left">
        <ul class="classification">
          <#assign indent = 30 />
          <#list parents as p>
            <li>
              <span class="taxon_level">${p.rank!}</span>
              <span class="separator" style="width:${indent}px"></span>
              <a href="<@s.url value='/species/${p.key?c}'/>">${p.scientificName!"???"}</a>
            </li>
            <#assign indent = indent + 10 />
          </#list>
        </ul>
      </div>

      <div class="right">
        <div class="refine placeholder_temp">
          <h3>Download</h3>
          <ul>
            <li class="download"><a href="#" title="Classification">Classification<abbr title="Comma separated values">(CSV)</abbr></a></li>
          </ul>
        </div>

        <div class="download">
        </div>
      </div>

    </div>
    <footer></footer>
  </article>
</body>
</html>
