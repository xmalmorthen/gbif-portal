<#import "/WEB-INF/macros/common.ftl" as common>
<html>
<head>
  <title>Network detail</title>
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
      <div class="left"><h2>Network Information</h2></div>
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

    </div>
  </div>
  <footer></footer>
</article>

<#include "/WEB-INF/inc/member/contribution.ftl">

<#include "/WEB-INF/inc/member/occmap.ftl">


</body>
</html>
