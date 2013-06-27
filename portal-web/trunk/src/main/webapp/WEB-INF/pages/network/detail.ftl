<#import "/WEB-INF/macros/common.ftl" as common>
<html>
<head>
  <title>Network detail</title>
</head>
<body class="species">

<#assign tab="info"/>
<#assign memberType="network"/>
<#assign memberTypeLabel="network"/>
<#include "/WEB-INF/pages/member/inc/infoband.ftl">

<@common.article id="information" title="Network Information">
  <#include "/WEB-INF/pages/member/inc/basics.ftl">
</@common.article>

</body>
</html>
