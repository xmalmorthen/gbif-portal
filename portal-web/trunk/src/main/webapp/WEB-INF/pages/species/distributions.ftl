<#import "/WEB-INF/macros/pagination.ftl" as paging>
<#import "/WEB-INF/macros/common.ftl" as common>
<html>
<head>
  <title>Distributions for ${usage.canonicalOrScientificName!}</title>
</head>

<body class="species">

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
          <h2>${page.count!} Distributions for "${usage.canonicalOrScientificName!}"</h2>
        </div>
      </div>

      <div class="fullwidth">
      <#list page.results as item>
        <div class="result">
          <h2><strong><#if item.country??>${item.country.title}</#if> ${item.locality!} ${item.locationId!}</strong>
            <span class="note"><@s.text name='enum.occurrencestatus.${item.status!"PRESENT"}'/></span>
            <@common.usageSource component=item showChecklistSource=usage.nub />
          </h2>
          <#if item.lifeStage?? || item.temporal?? || item.startDayOfYear?? || item.endDayOfYear??>
            <div class="footer">
              ${item.lifeStage!} ${item.temporal!}
              <#if item.startDayOfYear?? || item.endDayOfYear??>Days of the year: ${item.startDayOfYear!}-${item.endDayOfYear!}</#if>
            </div>
          </#if>
          <#if item.threatStatus?? || item.establishmentMeans?? || item.appendixCites??>
            <div class="footer">
              <#if item.establishmentMeans??><@s.text name='enum.establishmentmeans.${item.establishmentMeans}'/></#if>
              <#if item.threatStatus??><@s.text name="enum.threatstatus.${item.threatStatus}"/></#if>
              <#if item.appendixCites??>Cites: ${item.appendixCites}</#if>
            </div>
          </#if>
        </div>
      </#list>

        <div class="footer">
        <@paging.pagination page=page url=currentUrl/>
        </div>
      </div>
    </div>

    </div>
    <footer></footer>
  </article>

</body>
</html>
