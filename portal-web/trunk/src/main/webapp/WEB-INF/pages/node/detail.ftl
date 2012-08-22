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

<@common.article id="appearsin" title="Appears in">
  <div class="left">
      <h3>Endorsed Organizations</h3>
      <ul class="notes">
        <#list organizations as org>
          <li>
            <a href="<@s.url value='/organization/${org.key}'/>">${org.title!"???"}</a>
          </li>
        </#list>
      </ul>
      <p>
        <a class="more_link" href="#">see all</a>
      </p>
  </div>
</@common.article>

</body>
</html>
