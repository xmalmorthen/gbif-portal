<#import "/WEB-INF/macros/pagination.ftl" as paging>
<#import "/WEB-INF/macros/common.ftl" as common>
<#import "/WEB-INF/macros/records.ftl" as records>
<html>
<head>
  <title>Published datasets by organization ${member.title!}</title>
</head>

<body class="species">

<#assign tabhl=true />
<#assign memberType="organization"/>
<#include "/WEB-INF/pages/member/inc/infoband.ftl">

  <div class="back">
    <div class="content">
      <a href="<@s.url value='/organization/${id}'/>" title="Back to organization page">Back to organization page</a>
    </div>
  </div>

  <article class="results">
    <header></header>
    <div class="content">

      <div class="header">
        <div class="left">
          <h2>${page.count!} Published datasets</h2>
        </div>
      </div>

      <div class="fullwidth">

      <#list page.results as item>
        <@records.dataset dataset=item/>
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
