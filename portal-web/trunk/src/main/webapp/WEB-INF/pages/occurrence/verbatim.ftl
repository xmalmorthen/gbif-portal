<#import "/WEB-INF/macros/common.ftl" as common>
<html>
<head>
  <title>Occurrence detail - GBIF</title>
  <meta name="menu" content="occurrences"/>
</head>
<body class="stats">

<#assign tab="info"/>
<#include "/WEB-INF/pages/occurrence/infoband.ftl">



<div class="back">
  <div class="content">
    <a href="<@s.url value='/occurrence/${id?c}'/>" title="Back to regular view">Back to regular view</a>
  </div>
</div>

<@common.notice title="Occurrence verbatim data">
  <p>This listing shows the orignal information as received by GBIF from the data publisher, without further
    interpretation processing. Alternatively you can also
    <a href="<@s.url value='/occurrence/${id?c}/raw'/>">view the raw XML</a>.
  </p>
</@common.notice>

<#list verbatim?keys as group>
  <@common.article id="record_level" title="Record level" class="raw odd">
  <div class="left">
    <#list verbatim[group]?keys as term>
      <div class="row <#if term_index==0>first</#if> <#if term_index % 2 == 0>odd<#else>even</#if> <#if !term_has_next>last</#if>">
        <h4>${term}</h4>
        <div class="value">${verbatim[group][term]}</div>
      </div>
    </#list>
  </div>
  </@common.article>
</#list>

</body>
</html>
