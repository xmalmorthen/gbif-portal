<#import "/WEB-INF/macros/common.ftl" as common>
<html>
<head>
  <title>Other participant nodes</title>

    <style type="text/css">
        #content article.dataset .content {
            padding-top: 31px;
            padding-bottom: 0px;
        }
        .node {
          text-decoration: underline;
        }
    </style>
</head>

<body class="infobandless">


<@common.article id="country_list" title="Other GBIF Participants">
  <div class="fullwidth">
    <p>Index to all GBIF Participants which are not a <a href="<@s.url value='/country'/>">Country Node</a>.</p>

    <ul>
      <#list nodes as n>
        <li class="node"><a href="<@s.url value='/node/${n.key}'/>">${n.getTitle()}</a></li>
      </#list>
    </ul>

  </div>
</@common.article>


</body>
</html>
