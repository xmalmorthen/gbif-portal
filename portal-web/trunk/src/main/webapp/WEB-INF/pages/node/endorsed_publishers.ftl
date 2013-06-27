<#import "/WEB-INF/macros/pagination.ftl" as paging>
<#import "/WEB-INF/macros/common.ftl" as common>
<#import "/WEB-INF/macros/records.ftl" as records>
<html>
<head>
  <title>Endorsed data publishers by node ${member.title!}</title>
</head>

<body class="species">

<#assign tabhl=true />
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
          <h2>${page.count!} Endorsed data publishers for "${member.title!}"</h2>
        </div>
      </div>

      <div class="fullwidth">

      <#list page.results as item>
        <@records.publisher publisher=item/>
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
