<#import "/WEB-INF/macros/common.ftl" as common>
<#import "/WEB-INF/pages/developer/inc/api.ftl" as api>
<html>
<head>
  <title>GBIF Occurrence API</title>
  <link rel="stylesheet" href="<@s.url value='/css/bootstrap-tables.css'/>" type="text/css" media="all"/>
</head>

<#assign tab="occurrence"/>
<#include "/WEB-INF/pages/developer/inc/tabs.ftl" />

<body class="api">


<@api.introArticle>
<div class="left">
    <p>
        This API works against the Occurrence index and its metrics.
    </p>
</div>
<div class="right">
    <ul>
        <li><a href="#occurrences">Occurrences</a></li>
        <li><a href="#search">Search Occurrences</a></li>
        <li><a href="#downloads">Downloads</a></li>
    </ul>
</div>
</@api.introArticle>



<#-- define some often occurring defaults -->
<#macro trow url method="GET" resp="Occurrence" respLink="#" paging=false params=[]>
<@api.trow url="/occurrence"+url httpMethod=method resp=resp respLink=respLink paging=paging params=params><#nested /></@api.trow>
</#macro>


<@common.article id="occurrences" title="Occurrences">
    <div class="fullwidth">
        <p>...</p>

    <@api.apiTable>
      <@trow url="" paging=true params=[2]>Page through all occurrences across all datasets</@trow>
      <@trow url="/{int}" params=[2]>Gets the single occurrence detail</@trow>
      <@trow url="/{int}/verbatim" resp="VerbatimOccurrence">Gets the verbatim occurrence</@trow>
    </@api.apiTable>

  </div>
</@common.article>



<@common.article id="search" title="Searching">
    <div class="fullwidth">
        <p>...</p>

    <@api.apiTable>
      <@trow url="" paging=true params=[2]>Page through all occurrences across all datasets</@trow>
      <@trow url="/{int}" params=[2]>Gets the single occurrence detail</@trow>
      <@trow url="/{int}/verbatim" resp="VerbatimOccurrence">Gets the verbatim occurrence</@trow>
    </@api.apiTable>

  </div>
</@common.article>



<@common.article id="downloads" title="Occurrence Downloads">
    <div class="fullwidth">
        <p>This is asynchroneous and you get an email!</p>

    <@api.apiTable>
      <@trow url="down" method="POST" paging=true params=[2]>Page through all occurrences across all datasets</@trow>
    </@api.apiTable>

  </div>
</@common.article>



<#assign params = {
  "user": "User account name",
  "language": "default=en or use HTTP header for this",
  "datasetKey": "The checklist dataset key as a uuid",
"sourceId": "",
"rank": "The taxonomic rank given as our <a href='http://builds.gbif.org/view/Common/job/gbif-api/site/apidocs/org/gbif/api/vocabulary/Rank.html'>rank enum</a>",
"name": "case insensitive, canonical namestring. For example Puma concolor",
"strict": "if true it (fuzzy) matches only the given name, but never a taxon in the upper classification",
"verbose": "if true show alternative matches considered which had been rejected",
"highlighting": "Highlight matching query in fulltext search fields.",
"facet": "A list of facet names (names identical to respective filter names) used to retrieve the 100 most frequent values. Allowed facets are:
X, Y, Z (tbd)"
} />

<@api.paramArticle params=params />


</body>
</html>