<#import "/WEB-INF/macros/pagination.ftl" as paging>
<#import "/WEB-INF/macros/common.ftl" as common>
<html>
<head>
  <title>Distributions for ${usage.canonicalOrScientificName!}</title>
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
          <h2>${page.count!} Distributions for "${usage.canonicalOrScientificName!}"</h2>
        </div>
        <div class="right"><h3>Statistics</h3></div>
      </div>

      <div class="left">
      <#list page.results as item>
        <div class="result">
          <h2><strong>${item.locality!item.locationId!(item.country.interpreted)!(item.country.verbatim)!"Unknown"}</strong>
            <span class="note">${item.status!"Present"}</span>
            <@common.usageSource component=item showChecklistSource=usage.nub />
          </h2>

          <div class="footer">
          ${item.locationId!} ${(item.country.interpreted)!(item.country.verbatim)!} ${item.locality!}
          </div>
          <div class="footer">
          ${item.lifeStage!} ${item.temporal!} <#if item.startDayOfYear?? || item.endDayOfYear??>Days of the
            year: ${item.startDayOfYear!}-${item.endDayOfYear!}</#if>
          </div>
          <div class="footer">
          ${(item.threatStatus.interpreted)!(item.threatStatus.verbatim)!} ${(item.establishmentMeans.interpreted)!(item.establishmentMeans.verbatim)!} ${(item.appendixCites.interpreted)!}
          </div>
        </div>
      </#list>
        <div class="footer">
        <@paging.pagination page=page url=currentUrl/>
        </div>
      </div>

      <div class="right placeholder_temp">
        <h3>References by continent</h3>
        <ul>
          <li>Europe <a class="number">200</a></li>
          <li>America <a class="number">32</a></li>
          <li>Asia <a class="number">152</a></li>
        </ul>
      </div>
    </div>

    </div>
    <footer></footer>
  </article>

</body>
</html>
