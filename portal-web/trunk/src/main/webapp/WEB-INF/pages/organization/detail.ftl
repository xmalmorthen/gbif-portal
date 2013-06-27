<#import "/WEB-INF/macros/common.ftl" as common>
<html>
<head>
  <title>Organization Detail</title>
</head>
<body class="organization">


<#assign tab="info"/>
<#assign memberType="organization"/>
<#assign memberTypeLabel="data publisher"/>
<#include "/WEB-INF/pages/member/inc/infoband.ftl">

<@common.article id="information" title="Data publisher information">
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
	
      <#--
      Disabled due to bad registry changes.  See http://dev.gbif.org/issues/browse/POR-528
      <h3>Organization Graph</h3>
      <div class="logo_holder">
        <a target="_blank" href="${cfg.wsReg}organization/${member.key}/graph?format=png">
          <img src="${cfg.wsReg}organization/${member.key}/graph?format=png" />
        </a>
      </div>
      -->

    </div>
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
            <a href="<@s.url value='/organization/${member.key}/datasets'/>">more</a>
          </li>
        </#if>
      </ul>
  </div>
</@common.article>
</#if>


</body>
</html>
