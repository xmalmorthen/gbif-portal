<#import "/WEB-INF/macros/common.ftl" as common>
<html>
<head>
  <title>Node detail</title>
</head>
<body class="species">

<#assign tab="info"/>
<#assign memberType="node"/>
<#include "/WEB-INF/pages/member/inc/infoband.ftl">

<#include "/WEB-INF/pages/member/inc/admin.ftl">

<@common.article id="information" title="Node Information">
    <div class="left">
      <#include "/WEB-INF/pages/member/inc/basics.ftl">
    </div>

    <div class="right">
      <#if member.logoURL?has_content>
        <div class="logo_holder">
          <img src="${member.logoURL}"/>
        </div>
      </#if>
    </div>
</@common.article>

<@common.article id="appearsin" title="Endorsed Organizations">
  <div class="left">
      <ul class="notes">
        <#list organizations as org>
          <li>
            <a href="<@s.url value='/organization/${org.key}'/>">${org.title!"???"}</a>
            <span class="note">An organization <#if org.city?? || org.country??>from <@common.cityAndCountry org/></#if> with ${org.numDatasets!"?"} published datasets</span>
          </li>
        </#list>
        <#if more>
          <li>
            <a class="more_link" href="<@s.url value='/node/${member.key}/organizations'/>">see all</a>
          </li>
        </#if>
      </ul>
  </div>
</@common.article>

</body>
</html>
