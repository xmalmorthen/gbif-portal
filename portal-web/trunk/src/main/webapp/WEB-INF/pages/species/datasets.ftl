<#import "/WEB-INF/macros/pagination.ftl" as paging>
<#import "/WEB-INF/macros/common.ftl" as common>
<html xmlns="http://www.w3.org/1999/html">
<head>
  <title>Datasets with ${usage.canonicalOrScientificName!}</title>
</head>

<body class="species">

<#assign tab="info"/>
<#assign tabhl=true />
<#include "/WEB-INF/pages/species/inc/infoband.ftl">

  <div class="back">
    <div class="content">
      <a href="<@s.url value='/species/${id?c}'/>" title="Back to species overview">Back to species overview</a>
    </div>
  </div>

  <article class="results">
    <header></header>
    <div class="content">

      <div class="header">
        <div class="left">
          <h2><@s.text name="enum.datasettype.${type!'UNKNOWN'}"/>s with "${usage.canonicalOrScientificName!}"</h2>
        </div>
      </div>

      <div class="fullwidth">

      <#list results as item>
        <#assign ds = item.dataset/>
        <div class="result">
          <h2><strong>
            <a title="${ds.title!}" href="<@s.url value='/dataset/${ds.key}'/>">${common.limit(ds.title!, 100)}</a>
            </strong>
          </h2>

          <div class="footer">
            <@s.text name="enum.datasettype.${ds.type!'UNKNOWN'}"/>
          <#if ds.type=="CHECKLIST">
            including <em><a href="<@s.url value='/species/${item.usage.key?c}'/>">${item.usage.scientificName}</a></em>
          <#else>
            with <a href="<@s.url value='/occurrence/search?nubKey=${usage.nubKey?c}&datasetKey=${ds.key}'/>">${item.numOccurrences} records of <em>${usage.canonicalOrScientificName!}</em></a>
          </#if>
          </div>

        </div>
      </#list>

      </div>

    </div>
    <footer></footer>
  </article>

</body>
</html>
