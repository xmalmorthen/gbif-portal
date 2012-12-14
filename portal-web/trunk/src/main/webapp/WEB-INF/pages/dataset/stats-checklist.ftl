<html>
<head>
  <title>${dataset.title} - Metrics</title>
</head>
<body>
  <#-- Set up the tabs to highlight the info tab, and includ a backlink -->
  <#assign tab="stats"/>
  <#include "/WEB-INF/pages/dataset/inc/infoband.ftl">
  <article class="results">
    <header></header>
    <div class="content">
      <div class="header">
        <div class="left">
          <h2>Dataset metrics</h2>
        </div>
      </div>
      <div class="fullwidth">

      <#if metrics.countByKingdom?has_content>
        <h2>By Kingdom</h2>
        <ul>
          <#list kingdoms as k>
            <#if metrics.countByKingdom(k)?has_content>
              <li><@s.text name="enum.kingdom.${k}"/> <span class="number">${metrics.countByKingdom(k)!0}</span></li>
            </#if>
          </#list>
        </ul>
      </#if>

      <#if metrics.countByRank?has_content>
        <h2>By Rank</h2>
        <ul>
          <#list rankEnum as k>
            <#if metrics.countByRank(k)?has_content>
              <li><@s.text name="enum.rank.${k}"/> <span class="number">${metrics.countByRank(k)!0}</span></li>
            </#if>
          </#list>
        </ul>
      </#if>

      <#if metrics.countNamesByLanguage?has_content>
        <h2>Vernacular Names By Language</h2>
        <ul>
          <#assign langs = metrics.countNamesByLanguage?keys?sort>
          <#list langs as l>
            <li>${l.getTitleEnglish()} [${l.getIso2LetterCode()}]<span class="number">${metrics.countNamesByLanguage(l)!0}</span></li>
          </#list>
        </ul>
      </#if>

      <#if metrics.countExtensionRecords?has_content>
        <h2>Associated Data</h2>
        <ul>
          <#list extensions as e>
            <#if ((metrics.getExtensionRecordCount(e)!0)>0)>
              <li><@s.text name="enum.extension.${e}"/> <span class="number">${metrics.getExtensionRecordCount(e)!0}</span></li>
            </#if>
          </#list>
        </ul>
      </#if>

      </div>
    </div>
    <footer></footer>
  </article>
</body>
</html>
