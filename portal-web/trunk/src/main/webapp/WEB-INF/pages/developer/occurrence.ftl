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
        This API works against the GBIF Occurrence Store, which handles occurrence records and makes them available through web service and download files.
    </p>
    <p>
        Internally we use a Java web service client for the consumption of these HTTP-based, RESTful web services. It may
        be of interest to those coding against the API, and can be found in the <ahref="https://gbif-occurrencestore.googlecode.com/svn/occurrence/trunk/occurrence-ws-client/" target="_blank">occurrence-ws-client</a>.
    </p>
    <p>
        Please note the old Registry API is still supported, but is now deprecated. Anyone starting new work is strongly
        encouraged to use the new API.
    </p>
</div>
<div class="right">
    <ul>
        <li><a href="#occurrences">Occurrences</a></li>
        <li><a href="#search">Search Occurrences</a></li>
        <li><a href="#downloads">Downloads</a></li>
        <li><a href="#metrics">Occurrence Metrics</a></li>
    </ul>
</div>
</@api.introArticle>



<#-- define some often occurring defaults -->
<#macro trowO url method="GET" resp="Occurrence" respLink="#" authRequired=false>
  <@api.trow_occurrence_simple url="/occurrence"+url httpMethod=method resp=resp respLink=respLink authRequired=authRequired><#nested /></@api.trow_occurrence_simple>
</#macro>

<#macro trowS url resp="Occurrence" respLink="#" paging=false params=[] authRequired=false  method="GET">
  <@api.trow_occurrence url="/occurrence/search"+url resp=resp respLink=respLink paging=paging params=params authRequired=authRequired httpMethod=method><#nested /></@api.trow_occurrence>
</#macro>

<#macro trowDR url resp="" method="GET" respLink="#" paging=false params=[] authRequired=false>
  <@api.trow_occurrence url="/occurrence/download/request"+url resp=resp httpMethod=method respLink=respLink paging=paging params=params authRequired=authRequired><#nested /></@api.trow_occurrence>
</#macro>

<#macro trowD url resp="" method="GET" respLink="#" paging=false params=[] authRequired=false>
  <@api.trow_occurrence url="/occurrence/download"+url resp=resp httpMethod=method respLink=respLink paging=paging params=params authRequired=authRequired><#nested /></@api.trow_occurrence>
</#macro>


<@common.article id="occurrences" title="Occurrences">
  <div class="fullwidth">
    <p>This API provides services related to the retrieval of single occurrence records.</p>

    <@api.apiTable_occurrence_no_params>      
      <@trowO url="/{key}" respLink="/occurrence/252408386" >Gets a single occurrence detail</@trowO>
      <@trowO url="/{key}/fragment" respLink="/occurrence/252408386/fragment" >Gets retrieves a single occurrence fragment in its raw form</@trowO>
      <@trowO url="/{key}/verbatim" resp="VerbatimOccurrence" respLink="/occurrence/252408386/verbatim">Gets the verbatim (no interpretation) occurrence record</@trowO>
    </@api.apiTable_occurrence_no_params>

  </div>
</@common.article>



<@common.article id="search" title="Searching">
    <div class="fullwidth">
        <p>This API provides services for searching occurrence records that have been indexed by GBIF.</p>

     <@api.apiTable_occurrence>
      <@trowS url="" respLink="/occurrence/search?TAXON_KEY=1"  paging=true params=[1,2,3,6,7,8,9,10,11,12,13,14,15,16,17,18,19]>Full search across all occurrences. 
      Results are ordered by relevance.</@trowS>
      <@trowS url="/catalog_number" respLink="/occurrence/search/catalog_number?q=122&limit=5" params=[20,21]>Search that returns  matching catalog numbers. 
      Results are ordered by relevance.</@trowS>
      <@trowS url="/collection_code" respLink="/occurrence/search/collection_code?q=12&limit=5" params=[20,21]>Search that returns matching collection codes. 
      Results are ordered by relevance.</@trowS>
      <@trowS url="/collector_name" respLink="/occurrence/search/collector_name?q=juan&limit=5" params=[20,21]>Search that returns matching collector names.
       Results are ordered by relevance.</@trowS>    
      <@trowS url="/institution_code" respLink="/occurrence/search/institution_code?q=GB&limit=5" params=[20,21]>Search that returns matching institution codes. 
      Results are ordered by relevance.</@trowS>        
    </@api.apiTable_occurrence>

  </div>
</@common.article>



<@common.article id="downloads" title="Occurrence Downloads">
    <div class="fullwidth">
        <p>This API provides services to download occurrence records and retrieve information about those downloads.</p>
        <p>Occurrence downloads are created asynchronously, the user requests a download whose response is notified by email.</p>

    <@api.apiTable_occurrence>
      <@trowDR url="" resp="Download key" method="POST" params=[22] authRequired=true>Starts the process of create a download file.</@trowDR>
      <@trowDR url="/{key}" resp="Download file" respLink="/occurrence/download/request/0000447-130906152512535" method="GET" authRequired=false>Retrieves the download file if it is available.</@trowDR>
      <@trowDR url="/{key}" method="DELETE" authRequired=true>Cancels the download process.</@trowDR>
      <@trowD url="" resp="Download" respLink="/occurrence/download" method="GET" authRequired=true>Lists all the downloads. This operation can be executed by the role ADMIN only.</@trowD>
      <@trowD url="/{key}" resp="Download" respLink="/occurrence/download/0000447-130906152512535" method="GET">Retrieves the occurrence download metadata by its unique key.</@trowD>
      <@trowD url="/{key}" method="PUT" authRequired=true>Update the status of a existing occurrence download. This operation can be executed by the role ADMIN only.</@trowD>
      <@trowD url="/{key}" method="POST" authRequired=true>Creates the metadata about an occurrence download. This operation can be executed by the role ADMIN only.</@trowD>
      <@trowD url="/user" method="GET" authRequired=true>Lists the downloads of the current user.</@trowD>
      <@trowD url="/user/{user}" method="GET" authRequired=true>Lists the downloads created by a user. Only role ADMIN can list downloads of other users.</@trowD>      
    </@api.apiTable_occurrence>

  </div>
</@common.article>


<@common.article id="metrics" title="Occurrence Metrics">
    <div class="fullwidth">
        <p>This API provides services to download occurrence records and retrieve status and information about those downloads.</p>
        <p>Downloads are created asynchronously, the user request a download and a response containing the download link is sent by email.</p>

    <@api.apiTable_occurrence_metrics>
      <@api.trow_occurrence_metrics url="/count" resp="Count" respLink="/occurrence/count">Returns occurrence counts from a set predifined list of dimensions. The supported dimensions are enumerated by this service <a href="http://api.gbif.org/occurrence/count/schema">/occurrence/count/schema</a></@api.trow_occurrence_metrics>
      <@api.trow_occurrence_metrics url="/count/schema" resp="Count" respLink="/occurrence/count/schema">List the supported schemas by the occurrence/count service.</@api.trow_occurrence_metrics>
      <@api.trow_occurrence_metrics url="/counts/basis_of_record" resp="Counts" respLink="/occurrence/counts/basis_of_record">Lists the occurrence counts by basis of record.</@api.trow_occurrence_metrics>
      <@api.trow_occurrence_metrics url="/counts/countries"resp="Counts" respLink="/occurrence/counts/countries?publishingCountry=US" params=[23]>Lists occurrence counts by publishing country.</@api.trow_occurrence_metrics>
      <@api.trow_occurrence_metrics url="/counts/year" resp="Counts" respLink="/occurrence/counts/year?from=2000&to=20012" params=[24,25]>Lists occurrence counts by year.</@api.trow_occurrence_metrics>            
    </@api.apiTable_occurrence_metrics>

  </div>
</@common.article>



<#assign params = {  
  "datasetKey": "The occurrence dataset key as a uuid",
  "year": "The 4 digit year. A year of 98 will be 98 after christ, no 1998.",
  "month": "The month of the year, starting with 1 for january.",
  "date": "Occurrence date in ISO 8601 formats:yyyy, yyyy-MM, yyyy-MM-dd and MM-dd.",
  "modified": "Occurrence modification date in ISO 8601 formats:yyyy, yyyy-MM, yyyy-MM-dd and MM-dd.",
  "latitude": "Latitude in decimals between -90 and 90 based on WGS 84.",
  "longitude": "Longitude in decimals between -180 and 180 based on WGS 84.",
  "country": "Country ISO 2 letters code the occurrence was recorded in.",
  "altitude": "Altitude/elevation in meters above sea level.",
  "depth" : "Depth in meters relative to altitude. For example 10 meters below a lake surface with given altitude.",
  "institutionCode" : "An identifier of any form assigned by the source to identify the institution the record belongs to. Not guaranteed to be unique.",
  "collectionCode": "An identifier of any form assigned by the source to identify the physical collection or digital dataset uniquely within the context of an institution.",
  "catalogNumber": "An identifier of any form assigned by the source within a physical collection or digital dataset for the record which may not be unique, but should be fairly unique in combination with the institution and collection code.",
  "collectorName": "The person who recorded the occurrence.",
  "basisOfRecord": "Basis of record, accepts the values PRESERVED_SPECIMEN, FOSSIL_SPECIMEN, LIVING_SPECIMEN, OBSERVATION, HUMAN_OBSERVATION, MACHINE_OBSERVATION, LITERATURE and UNKNOWN.",
  "taxonKey": "A taxon key from the GBIF backbone. All included and synonym taxa are included in the search, so a search for aves with taxonKey=212 will match all birds, no matter which species.",
  "georeferenced": "Searches for occurrence records which contain a value on its coordinate fields (latitude and longitude).GEOREFERENCED=true searches for occurrence records with a coordinate value. GEOREFERENCED=false searches for occurrence records without a coordinate value.",
  "geometry": "Searches for occurrence inside a polygon described in Well Known Text(WKT) format.E.g.: POLYGON ((30.0 10.0, 10.12 20.23, 20 40, 40 40, 30 10)).",
  "spatialIssues": "Includes/excludes occurrence records which contain spatial issues. spatialIssues=true exclude records with spatial issues. spatialIssues=false include records with spatial issues. The absence of this parameter returns any record with or without spatial issues.",
  "q" : "Simple search parameter. The value for this parameter can be a simple word or a phrase.",
  "limit": "maximum number of results to return.",
  "Download request predicate": "A JSON object that contains the query that produces the download.",
  "publishingCountry":"Country ISO 2 letters code the occurrence was published in.",
  "from":"Minimum year, used by the occurrence/year service.",
  "to":"Maximum year, used by the occurrence/year service."
} />


<@common.article id="parameters" title="Parameters">
  <div class="fullwidth">
    <p>The following parameters are for use exclusively with the Occurrence API described above.</p>

    <@api.apiTable_params>
      <#list params?keys as k>
        <@api.trow_param index="${k_index + 1}" key="${k_index + 1}. ${k}" description="${params[k]}" />
      </#list>
    </@api.apiTable_params>

  </div>
</@common.article>

</body>
</html>