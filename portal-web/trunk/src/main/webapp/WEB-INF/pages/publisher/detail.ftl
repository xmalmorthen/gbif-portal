<#import "/WEB-INF/macros/common.ftl" as common>
<html>
<head>
  <title>Data Publisher - ${member.title}</title>
</head>
<body class="publisher">


<#assign tab="info"/>
<#include "/WEB-INF/pages/member/inc/infoband.ftl">

<@common.article id="information" title="Data publisher information">
  <#assign extraRight>
      <h3>Endorsed by</h3>
      <p><#if node??><a href="<@s.url value='/node/${node.key}'/>">${node.title}</a><#else>Not endorsed yet</#if></p>
  </#assign>
  <#include "/WEB-INF/pages/member/inc/basics.ftl">
</@common.article>

<#if page.results?has_content>
<@common.article id="datasets" title="Published Datasets">
  <div class="left">
      <ul class="notes">
        <#list page.results as d>
          <li>
            <a href="<@s.url value='/dataset/${d.key}'/>">${d.title!"???"}</a>
            <span class="note">A ${d.subtype!} <@s.text name="enum.datasettype.${d.type!}"/>
              <#if d.pubDate??>${d.pubDate?date?string.medium}</#if></span>
          </li>
        </#list>
        <#if !page.isEndOfRecords()>
          <li class="more">
            <a href="<@s.url value='/publisher/${member.key}/datasets'/>">more</a>
          </li>
        </#if>
      </ul>
  </div>
</@common.article>
</#if>


</body>
</html>
