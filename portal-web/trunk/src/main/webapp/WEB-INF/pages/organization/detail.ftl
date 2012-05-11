<#import "/WEB-INF/macros/common.ftl" as common>
<#import "/WEB-INF/macros/manage_tags.ftl" as manage>
<html>
<head>
  <title>Organization Detail</title>
  <meta name="gmap" content="true"/>
</head>
<body class="species typesmap">



<#assign tab="info"/>
<#include "/WEB-INF/inc/member/infoband.ftl">

<#include "/WEB-INF/inc/member/admin.ftl">

<article>
  <header></header>
  <div class="content">

    <div class="header">
      <div class="left"><h2>Organization Information</h2></div>
    </div>

    <div class="left">
      <#include "/WEB-INF/inc/member/basics.ftl">
    </div>

    <div class="right">
      <#if member.logoURL?has_content>
        <div class="logo_holder">
          <img src="${member.logoURL}"/>
        </div>
      </#if>

      <h3>Endorsed by</h3>
      <p><#if member.endorsingNode??><a href="<@s.url value='/node/${member.endorsingNode.key}'/>">${member.endorsingNode.title}</a><#else>Not endorsed yet</#if></p>

      <@manage.manageTags type="organization"/>

    </div>
  </div>
  <footer></footer>
</article>

<#include "/WEB-INF/inc/member/contribution.ftl">

<#include "/WEB-INF/inc/member/occmap.ftl">
  

</body>
</html>
