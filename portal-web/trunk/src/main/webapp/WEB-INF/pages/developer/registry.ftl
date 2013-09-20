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

<#macro trowP url method="GET" auth=false resp="Organization" respLink="#" paging=false params=[]>
<@api.trow_registry url="/organization"+url httpMethod=method authRequired=auth resp=resp respLink=respLink paging=paging params=params><#nested /></@api.trow_registry>
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
        <p>The publisher service can be used to work with publishers (organizations, institutions) in the GBIF Registry.</p>

  <@api.apiTable_registry>
    <@trowP url="" respLink="/organization" paging=true params=[1,2]>Lists all publishers</@trowP>
    <@trowP url="" method="POST" auth=true>Creates a new publisher</@trowP>
    <@trowP url="/{UUID}" respLink="/organization/e2e717bf-551a-4917-bdc9-4fa0f342c530">Gets the single publisher detail</@trowP>
    <@trowP url="/{UUID}" method="PUT" auth=true>Updates the publisher</@trowP>
    <@trowP url="/{UUID}" method="DELETE" auth=true>Deletes the publisher</@trowP>
    <@trowP url="/{UUID}/contact" method="GET" respLink="/organization/e2e717bf-551a-4917-bdc9-4fa0f342c530/contact">Lists all contacts for the publisher</@trowP>
    <@trowP url="/{UUID}/contact" method="POST" auth=true>Create and add a publisher contact</@trowP>
    <@trowP url="/{UUID}/contact/{ID}" method="DELETE" auth=true>Deletes a publisher contact with contact identifier {ID}</@trowP>
    <@trowP url="/{UUID}/contact/{ID}" method="PUT" auth=true>Updates a publisher contact with contact identifier {ID}</@trowP>
    <@trowP url="/{UUID}/endpoint" method="GET" respLink="/organization/e2e717bf-551a-4917-bdc9-4fa0f342c530/endpoint">Lists the publisher endpoints</@trowP>
    <@trowP url="/{UUID}/endpoint" method="POST" auth=true>Creates a publisher endpoint</@trowP>
    <@trowP url="/{UUID}/endpoint/{ID}" method="DELETE" auth=true>Deletes a publisher endpoint with identifier {ID}</@trowP>
    <@trowP url="/{UUID}/identifier" method="GET" respLink="/organization/e2e717bf-551a-4917-bdc9-4fa0f342c530/identifier">Lists the publisher's identifiers</@trowP>
    <@trowP url="/{UUID}/identifier" method="POST" auth=true>Creates a new publisher identifier</@trowP>
    <@trowP url="/{UUID}/identifier/{ID}" method="DELETE" auth=true>Deletes a publisher's identifier with identifier {ID}></@trowP>
    <@trowP url="/{UUID}/tag" method="GET" respLink="/organization/e2e717bf-551a-4917-bdc9-4fa0f342c530/tag">Lists all tags for a publisher</@trowP>
    <@trowP url="/{UUID}/tag" method="POST" auth=true>Create and add a publisher tag</@trowP>
    <@trowP url="/{UUID}/tag/{ID}" method="DELETE" auth=true>Deletes the publisher tag with tag identifier {ID}</@trowP>
    <@trowP url="/{UUID}/machinetag" method="GET" respLink="/organization/e2e717bf-551a-4917-bdc9-4fa0f342c530/machinetag">Lists all machine tags for a publisher</@trowP>
    <@trowP url="/{UUID}/machinetag" method="POST" auth=true>Create and add a publisher machine tag</@trowP>
    <@trowP url="/{UUID}/machinetag/{ID}" method="DELETE">Deletes the publisher machine tag with machine tag identifier {ID}</@trowP>
    <@trowP url="/{UUID}/comment" method="GET" respLink="/organization/e2e717bf-551a-4917-bdc9-4fa0f342c530/comment">Lists all comments for a publisher</@trowP>
    <@trowP url="/{UUID}/comment" method="POST" auth=true>Create and add a publisher comment</@trowP>
    <@trowP url="/{UUID}/comment" method="DELETE" auth=true>Deletes the publisher comment with comment identifier {ID}</@trowP>
    <@trowP url="/{UUID}/hostedDataset" method="GET" respLink="/organization/e2e717bf-551a-4917-bdc9-4fa0f342c530/hostedDataset" paging=true>Lists the hosted datasets (datasets hosted by installations hosted by publisher)</@trowP>
    <@trowP url="/{UUID}/ownedDataset" method="GET" respLink="/organization/e2e717bf-551a-4917-bdc9-4fa0f342c530/ownedDataset" paging=true>Lists the owned datasets (datasets published by publisher)</@trowP>
    <@trowP url="/{UUID}/installation" method="GET" respLink="/organization/e2e717bf-551a-4917-bdc9-4fa0f342c530/installation" paging=true>Lists the technical installations hosted by this publisher</@trowP>
    <@trowP url="/deleted" method="GET" respLink="/organization/deleted" paging=true>Lists the deleted publishers</@trowP>
    <@trowP url="/pending" method="GET" respLink="/organization/pending" paging=true>Lists the publishers whose endorsement is pending</@trowP>
    <@trowP url="/nonPublishing" method="GET" respLink="/organization/nonPublishing" paging=true>Lists the publishers publishing 0 datasets</@trowP>
  </@api.apiTable_registry>

  </div>
</@common.article>



<#assign params = {
  "q": "Simple search parameter. The value for this parameter can be a simple word or a phrase. Wildcards can be added to the simple word parameters only, i.e. q=*puma*",
  "country": "Search by country given as our <a href='http://builds.gbif.org/view/Common/job/gbif-api/site/apidocs/org/gbif/api/vocabulary/Country.html'>Country enum</a>.",
  "type": "The metadata type given as our <a href='http://builds.gbif.org/view/Common/job/gbif-api/site/apidocs/org/gbif/api/vocabulary/MetadataType.html'>MetadataType enum</a>",
  "dataset_type": "Filters datasets by their dataset type given as our <a href='http://builds.gbif.org/view/Common/job/gbif-api/site/apidocs/org/gbif/api/vocabulary/DatasetType.html'>DatasetType enum</a>",
  "dataset_subtype": "(Search index has no data to filter on yet) Filters datasets by their dataset subtype given as our <a href='http://builds.gbif.org/view/Common/job/gbif-api/site/apidocs/org/gbif/api/vocabulary/DatasetSubtype.html'>DatasetSubtype enum</a>",
  "keyword": "Filters datasets by a case insensitive plain text keyword. The search is done on the merged collection of tags, the dataset keywordCollections and temporalCoverages.",
  "owning_organization_key": "Filters datasets by their owning organization UUID key",
  "hosting_organization_key": "Filters datasets by their hosting organization UUID key",
  "decade": "(Search index has no data to filter on yet) Filters datasets by their temporal coverage broken down to decades. Decade given as a full year, e.g. 1950, 1960 or 1980.",
  "country (filter/facet)": "(Search index has no data to filter on yet) Filters datasets by their country(ies) given as our <a href='http://builds.gbif.org/view/Common/job/gbif-api/site/apidocs/org/gbif/api/vocabulary/Country.html'>Country enum</a>. The search is done on the country of the geospatical coverage of the dataset.",
  "publishing_country": "Filters datasets by their owining organization's country given as our <a href='http://builds.gbif.org/view/Common/job/gbif-api/site/apidocs/org/gbif/api/vocabulary/Country.html'>Country enum</a>",
  "continent": "(Search filter not available yet) Filters datasets by their continent(s) given as our <a href='http://builds.gbif.org/view/Common/job/gbif-api/site/apidocs/org/gbif/api/vocabulary/Continent.html'>Continent enum</a>. The search is done on the continent of the geospatical coverage of the dataset.",
  "highlighting": "Highlight matching query in fulltext search fields, which includes: dataset_title, keyword, country, publishing_country, owning_organization_title, hosting_organization_title, description, full_text.",
  "facet": "A list of facet names (names identical to respective filter names) used to retrieve the 100 most frequent values. Allowed facets are:
dataset_type, dataset_subtype, keyword, owning_organization_key, hosting_organization_key, decade, country, publishing_country."
} />

<@api.paramArticle params=params />


</body>
</html>