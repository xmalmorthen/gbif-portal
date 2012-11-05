<#import "/WEB-INF/macros/common.ftl" as common>
<html>
<head>
  <title>Organization Detail</title>
</head>
<body class="organization">


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

      <h3>Organization Graph</h3>
      <div class="logo_holder">
        <a target="_blank" href="${cfg.wsReg}organization/${member.key}/graph?format=png">
          <img src="${cfg.wsReg}organization/${member.key}/graph?format=png" />
        </a>
      </div>

      <#assign type="organization"/>
      <#include "/WEB-INF/inc/manage_tags.ftl">

    </div>
</@common.article>

<#if datasets?has_content>
<@common.article id="datasets" title="Published Datasets">
  <div class="left">
      <ul class="notes">
        <#list datasets as d>
          <li>
            <a href="<@s.url value='/dataset/${d.key}'/>">${d.title!"???"}</a>
            <span class="note">A ${d.subtype!} <@s.text name="enum.datasettype.${d.type!}"/>
              <#if d.pubDate??>${d.pubDate?date?string.medium}</#if></span>
          </li>
        </#list>
        <#if more>
          <li>
            <a class="more_link" href="<@s.url value='/organization/${member.key}/datasets'/>">see all</a>
          </li>
        </#if>
      </ul>
  </div>
</@common.article>
</#if>


</body>
</html>
