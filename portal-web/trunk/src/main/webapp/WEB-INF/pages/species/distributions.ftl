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
          <h2><strong>${item.locality!item.locationId!item.country!"Unknown"}</strong>
            <span class="note">${item.status!"Present"}</span>
            <@common.usageSource component=item showChecklistSource=usage.nub />
          </h2>

          <div class="footer">
          ${item.locationId!} ${item.country!} ${item.locality!}
          </div>
          <div class="footer">
          ${item.lifeStage!} ${item.temporal!} <#if item.startDayOfYear?? || item.endDayOfYear??>Days of the
            year: ${item.startDayOfYear!}-${item.endDayOfYear!}</#if>
          </div>
          <div class="footer">
          ${item.threatStatus!} ${item.establishmentMeans} ${item.appendixCites!}
          </div>
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
