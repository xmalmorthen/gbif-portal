<#import "/WEB-INF/macros/common.ftl" as common>
<#import "/WEB-INF/pages/developer/inc/api.ftl" as api>
<html>
<head>
  <title>GBIF Registry API</title>
  <link rel="stylesheet" href="<@s.url value='/css/bootstrap-tables.css'/>" type="text/css" media="all"/>
</head>

<#assign tab="registry"/>
<#include "/WEB-INF/pages/developer/inc/tabs.ftl" />

<body class="api">


<@api.introArticle>
<div class="left">
    <p>
        This API works against the GBIF registry.
    </p>
</div>
<div class="right">
    <ul>
        <li><a href="#datasets">Datasets</a></li>
        <li><a href="#publishers">Publishers</a></li>
    </ul>
</div>
</@api.introArticle>



<#-- define some often occurring defaults -->
<#macro trowD url method="GET" resp="Dataset" respLink="#" paging=false params=[]>
<@api.trow url="/dataset"+url httpMethod=method resp=resp respLink=respLink paging=paging params=params><#nested /></@api.trow>
</#macro>

<#macro trowP url method="GET" resp="Organization" respLink="#" paging=false params=[]>
<@api.trow url="/publisher"+url httpMethod=method resp=resp respLink=respLink paging=paging params=params><#nested /></@api.trow>
</#macro>



<@common.article id="datasets" title="Datasets">
    <div class="fullwidth">
        <p>...</p>

  <@api.apiTable>
    <@trowD url="" paging=true params=[2]>Page through all occurrences across all datasets</@trowD>
    <@trowD url="" method="POST" params=[2]>Gets the single occurrence detail</@trowD>
    <@trowD url="/{int}" params=[2]>Gets the single occurrence detail</@trowD>
  </@api.apiTable>

  </div>
</@common.article>


<@common.article id="publishers" title="Publishers">
    <div class="fullwidth">
        <p>...</p>

  <@api.apiTable>
    <@trowP url="" paging=true params=[2]>Page through all occurrences across all datasets</@trowP>
    <@trowP url="/{int}" params=[2]>Gets the single occurrence detail</@trowP>
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
"kingdom, phylum, class, order, family, genus": "optional classification parameters accepting a canonical name.
              If provided the default matching will also try to match against these if no direct match is found for the name alone.",
"facet": "A list of facet names (names identical to respective filter names) used to retrieve the 100 most frequent values. Allowed facets are:
X, Y, Z (tbd)"
} />

<@api.paramArticle params=params />


</body>
</html>