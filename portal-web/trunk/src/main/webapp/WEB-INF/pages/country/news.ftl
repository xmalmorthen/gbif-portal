<#import "/WEB-INF/macros/common.ftl" as common>
<html>
<head>
  <title>Country News for ${country.title}</title>
</head>
<body>

<#assign tab="news"/>
<#include "/WEB-INF/pages/country/inc/infoband.ftl">


<@common.article id="news" title="News">
    <div class="left">
    </div>

    <div class="right">
    </div>
</@common.article>


</body>
</html>
