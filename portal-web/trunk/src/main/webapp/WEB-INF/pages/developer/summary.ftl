<#import "/WEB-INF/macros/common.ftl" as common>
<#import "/WEB-INF/pages/developer/inc/api.ftl" as api>
<html>
<head>
  <title>GBIF Occurrence API</title>
  <link rel="stylesheet" href="<@s.url value='/css/bootstrap-tables.css'/>" type="text/css" media="all"/>
</head>

<#include "/WEB-INF/pages/developer/inc/tabs.ftl" />

<body class="api">


<@api.introArticle>
<div class="left">
    <p>
        This is the GBIF Portal API
    </p>
</div>
<div class="right">
    <ul>
        <li><a href="#rest">JSON REST</a></li>
        <li><a href="#entities">Exposed entities</a></li>
        <li><a href="#paging">Paging</a></li>
        <li><a href="#search">Facetted search</a></li>
    </ul>
</div>
</@api.introArticle>


<@common.article id="rest" title="RESTful services">
    <div class="fullwidth">
        <p>...</p>
  </div>
</@common.article>


<@common.article id="entities" title="Exposed main entities" titleRight="Examples">
  <div class="left">
    <h3>Dataset</h3>
    <p>...</p>
  </div>
  <div class="right">
    <h3>Dataset</h3>
    <p>...</p>
  </div>
</@common.article>


</body>
</html>