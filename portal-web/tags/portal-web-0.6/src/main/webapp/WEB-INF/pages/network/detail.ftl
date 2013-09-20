<#import "/WEB-INF/macros/common.ftl" as common>
<html>
<head>
  <title>Network detail</title>
</head>
<body class="species">

<#assign tab="info"/>
<#include "/WEB-INF/pages/member/inc/infoband.ftl">

<@common.article id="information" title="Network information">
  <#include "/WEB-INF/pages/member/inc/basics.ftl">
</@common.article>

<#if page.results?has_content>
<@common.article id="datasets" title="Participating datasets: ${member.numConstituents}">
  <div class="fullwidth">
      <ul class="notes">
        <#list page.results as d>
          <li>
            <a href="<@s.url value='/dataset/${d.key}'/>">${d.title!"???"}</a>
            <span class="note">${d.subtype!} <@s.text name="enum.datasettype.${d.type!}"/>
              <#if d.pubDate??>${d.pubDate?date?string.medium}</#if>
              <#if d.owningOrganizationKey??>
                <#assign publisher=action.getOrganization(d.owningOrganizationKey) />
                published by <a href="<@s.url value='/publisher/${publisher.key}'/>" title="${publisher.title}">${publisher.title}</a>.
              </#if>
            </span>
          </li>
        </#list>
        <#if !page.isEndOfRecords()>
          <li class="more">
            <a href="<@s.url value='/network/${member.key}/datasets'/>">more</a>
          </li>
        </#if>
      </ul>
  </div>
</@common.article>
</#if>

</body>
</html>
