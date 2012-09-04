<#import "/WEB-INF/macros/pagination.ftl" as paging>
<html>
<head>
  <title>${dataset.title!"???"} - Dataset detail</title>
</head>
<body class="species">

<#assign tab="constituents"/>
<#assign hl="highlighted" />
<#include "/WEB-INF/pages/dataset/inc/infoband.ftl">

  <div class="back">
    <div class="content">
      <a href="<@s.url value='/dataset/${id}'/>" title="Back to dataset overview">Back to dataset overview</a>
    </div>
  </div>

  <article class="results light_pane">
    <header></header>
    <div class="content">

      <div class="header">
        <div class="left">
          <h2>${page.count!} Constituents of "${dataset.title!"???"}"</h2>
        </div>
      </div>

      <div class="left">

      <#list page.results as d>
        <div class="result">
          <h2>
            <a href="<@s.url value='/dataset/${d.key}'/>"><strong>${d.title!"???"}</strong></a>
          </h2>


          <h3 class="separator">
          </h3>

          <div class="footer">
            <#if d.type??><@s.text name="enum.datasettype.${d.type}"/><#else>Dataset</#if>
            published by <a href="<@s.url value='/organization/${d.owningOrganizationKey}'/>">TODO:???</a>
          </div>
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
