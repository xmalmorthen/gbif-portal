<#import "/WEB-INF/macros/common.ftl" as common>
<html>
<head>
  <title>GBIF non-country Participant Nodes</title>

    <style type="text/css">
        #content article.dataset .content {
            padding-top: 31px;
            padding-bottom: 0px;
        }
        .active {
          text-decoration: underline;
        }
    </style>
</head>

<body class="infobandless">


<@common.article id="country_list" title="GBIF non-country Participant Nodes">
  <div class="fullwidth">
    <p>Index to GBIF Nodes from Participants that are not <a href="<@s.url value='/country'/>">countries</a>.
    </p>

    <ul>
      <#list nodes as n>
        <li <#if n.participationStatus=='VOTING' || n.participationStatus=='ASSOCIATE'> class="active"</#if>><a href="<@s.url value='/node/${n.key}'/>">${n.getTitle()}</a></li>
      </#list>
    </ul>

  </div>
</@common.article>


</body>
</html>
