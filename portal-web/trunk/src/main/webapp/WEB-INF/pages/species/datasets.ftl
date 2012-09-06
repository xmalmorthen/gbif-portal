<#import "/WEB-INF/macros/pagination.ftl" as paging>
<#import "/WEB-INF/macros/common.ftl" as common>
<html>
<head>
  <title>Datasets with ${usage.canonicalOrScientificName!}</title>
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
          <h2>Datasets with "${usage.canonicalOrScientificName!}"</h2>
        </div>
      </div>

      <div class="fullwidth">

      <#list page.results as item>
        <div class="result">
          <h2><strong>
            <#if item.type=="CHECKLIST">
              <a href="<@s.url value='/species/${relatedUsages[item_index].key?c}'/>">
            <#else>
              <a href="<@s.url value='/occurrence/search?nubKey=${usage.nubKey?c}&datasetKey=${item.key}'/>">
            </#if>
            ${common.limit(item.title!, 100)}</a>
            </strong>
          </h2>

          <div class="footer">
            <@s.text name="enum.datasettype.${item.type!'UNKNOWN'}"/> with
          <#if item.type=="CHECKLIST">
            ${relatedUsages[item_index].scientificName}
          <#else>
            99 occurrences of ${usage.canonicalOrScientificName!}
          </#if>
          </div>

          <#if item.citation?has_content>
            <div class="footer">
                <@common.citation item.citation/>
            </div>
          </#if>
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
