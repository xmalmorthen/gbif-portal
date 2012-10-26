<#import "/WEB-INF/macros/pagination.ftl" as paging>
<#import "/WEB-INF/macros/common.ftl" as common>
<#import "/WEB-INF/macros/network_entity/organization.ftl" as organization>
<html>
<head>
  <title>Endorsed organizations by node ${member.title!}</title>
</head>

<body class="species">

<#assign tabhl=true />
<#assign memberType="node"/>
<#include "/WEB-INF/pages/member/inc/infoband.ftl">

  <div class="back">
    <div class="content">
      <a href="<@s.url value='/node/${id}'/>" title="Back to node page">Back to node page</a>
    </div>
  </div>

  <article class="results">
    <header></header>
    <div class="content">

      <div class="header">
        <div class="left">
          <h2>${page.count!} Endorsed organizations for "${member.title!}"</h2>
        </div>
      </div>

      <div class="fullwidth">

      <#list page.results as item>
        <@organization.record organization=item/>
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
