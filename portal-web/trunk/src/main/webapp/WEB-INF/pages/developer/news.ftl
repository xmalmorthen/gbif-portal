<#import "/WEB-INF/macros/common.ftl" as common>
<#import "/WEB-INF/pages/developer/inc/api.ftl" as api>
<html>
<head>
  <title>GBIF News API</title>
  <link rel="stylesheet" href="<@s.url value='/css/bootstrap-tables.css'/>" type="text/css" media="all"/>
</head>

<#assign tab="news"/>
<#include "/WEB-INF/pages/developer/inc/tabs.ftl" />

<body class="api">


<@api.introArticle>
<div class="left">
    <p>
        This API is used to retrieve news from GBIF and is entirely based on RSS feeds.
    </p>
</div>
<div class="right">
    <ul>
        <li><a href="#name_usages">News Feeds</a></li>
        <li><a href="#searching">News search</a></li>
    </ul>
</div>
</@api.introArticle>


</body>
</html>