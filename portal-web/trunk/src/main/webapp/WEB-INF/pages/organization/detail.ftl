<#import "/WEB-INF/macros/common.ftl" as common>
<html>
<head>
  <title>Organization Detail</title>
</head>
<body class="species">


<#assign tab="info"/>
<#assign memberType="organization"/>
<#include "/WEB-INF/pages/member/inc/infoband.ftl">

<#include "/WEB-INF/pages/member/inc/admin.ftl">

<@common.article id="information" title="Organization Information">
    <div class="left">
      <#include "/WEB-INF/pages/member/inc/basics.ftl">
    </div>

    <div class="right">
      <#if member.logoURL?has_content>
        <div class="logo_holder">
          <img src="${member.logoURL}"/>
        </div>
      </#if>

      <h3>Endorsed by</h3>
      <p><#if node??><a href="<@s.url value='/node/${node.key}'/>">${node.title}</a><#else>Not endorsed yet</#if></p>

      <#assign type="organization"/>
      <#include "/WEB-INF/inc/manage_tags.ftl">

    </div>
</@common.article>

<@common.article id="appearsin" title="Published Datasets">
  <div class="left">
      <h3>Datasets</h3>
      <ul class="notes">
        <#list datasets as d>
          <li>
            <a href="<@s.url value='/dataset/${d.key}'/>">${d.title!"???"}</a>
          </li>
        </#list>
      </ul>
      <p>
        <a class="more_link" href="<@s.url value='/dataset/search?owning_org={member.key}'/>">see all</a>
      </p>
  </div>
</@common.article>


</body>
</html>
