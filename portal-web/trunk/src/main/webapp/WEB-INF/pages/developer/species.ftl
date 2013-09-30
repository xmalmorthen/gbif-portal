<#import "/WEB-INF/macros/common.ftl" as common>
<#import "/WEB-INF/pages/developer/inc/api.ftl" as api>
<html>
<head>
  <title>Species API</title>
  <link rel="stylesheet" href="<@s.url value='/css/bootstrap-tables.css'/>" type="text/css" media="all"/>
</head>

<#assign tab="species"/>
<#include "/WEB-INF/pages/developer/inc/tabs.ftl" />

<body class="api">


<@api.introArticle>
<div class="left">
    <p>
        This API works against data kept in the GBIF Checklist Bank which
        taxonomically indexes all registered <a href="<@s.url value='/dataset/search?type=CHECKLIST'/>">checklist
        datasets</a> in the GBIF network.
    </p>
    <p>
        For statistics on checklist datasets, you can refer to the <a href="<@s.url value='/developer/registry#dataset_metrics'/>">dataset metrics</a> section of the Registry API.
    </p>
    <p>
        It is recommended to use the Java web service client to consume these HTTP-based RESTful web services. Specific
        instructions on how to configure the client can be found in its respective <a
            href="https://code.google.com/p/gbif-ecat/source/browse/checklistbank/trunk/checklistbank-ws-client/README"
            target="_blank">checklistbank-ws-client project</a>.
    </p>
</div>
<div class="right">
    <ul>
        <li><a href="#name_usages">Name Usages</a></li>
        <li><a href="#searching">Searching</a></li>
        <li><a href="#parameters">Query Parameters</a></li>
    </ul>
</div>
</@api.introArticle>


<#-- define some often occurring species defaults -->
<#macro trow url resp="NameUsage List" respLink="#" paging=false params=[]>
<@api.trow url="/species"+url resp=resp respLink=respLink paging=paging params=params><#nested /></@api.trow>
</#macro>
<#macro trow_search url resp="NameUsage List" respLink="#" paging=false params=[]>
  <@api.trow url=""+url resp=resp respLink=respLink paging=paging params=params><#nested /></@api.trow>
</#macro>


<@common.article id="name_usages" title="Working with Name Usages">
    <div class="fullwidth">
        <p>A name usage is a usage of a scientific name according to one
            particular Checklist including the <a href="<@s.url value='dataset/d7dddbf4-2cf0-4f39-9b2a-bb099caae36c'/>">GBIF Taxonomic Backbone</a>
            which is just called <em>nub</em> in this API.
            Name usages from other checklists with names that also exist in the nub will
            have a nubKey that points to the related usage in the backbone.
        </p>

      <@api.apiTable>
            <@trow url="" paging=true respLink="/species?datasetKey=00a0607f-fd7e-4268-9707-0f53aa265f1f&sourceId=ICIMOD_Barsey_Plants_001" params=[3,4,5,7]>Lists all name usages across all checklists</@trow>
            <@trow url="/root/{uuid|shortname}" respLink="/species/root/66dd0960-2d7d-46ee-a491-87b9adcfe7b1" paging=true >Lists root usages of a checklist</@trow>
            <@trow url="/{int}" resp="NameUsage" respLink="/species/5231190" params=[3]>Gets the single name usage</@trow>
            <@trow url="/{int}/verbatim" resp="VerbatimNameUsage" respLink="/species/5231190/verbatim">Gets the verbatim name usage</@trow>
            <@trow url="/{int}/name" resp="ParsedName" respLink="/species/5231190/name">Gets the parsed name for a name usage</@trow>
            <@trow url="/{int}/parents" params=[3] respLink="/species/5231190/parents">Lists all parent usages for a name usage</@trow>
            <@trow url="/{int}/children" paging=true params=[3] respLink="/species/5231190/children">Lists all direct child usages for a name usage</@trow>
            <@trow url="/{int}/related" paging=false params=[3,4] respLink="/species/5231190/related">Lists all related name usages in other checklists</@trow>
            <@trow url="/{int}/synonyms" paging=true params=[3] respLink="/species/5231190/synonyms">Lists all synonyms for a name usage</@trow>
            <@trow url="/{int}/descriptions" resp="Description List" paging=true respLink="/species/5231190/descriptions">Lists all descriptions for a name usage</@trow>
            <@trow url="/{int}/distributions" resp="Distribution List" paging=true respLink="/species/5231190/distributions">Lists all distributions for a name usage</@trow>
            <@trow url="/{int}/images" resp="Image List" paging=true respLink="/species/5231190/images">Lists all images for a name usage</@trow>
            <@trow url="/{int}/references" resp="Reference List" paging=true respLink="/species/5231190/references">Lists all references for a name usage</@trow>
            <@trow url="/{int}/species_profiles" resp="SpeciesProfile List" paging=true respLink="/species/5231190/species_profiles">Lists all species profiles for a name usage</@trow>
            <@trow url="/{int}/vernacular_names" resp="VernacularName List" paging=true respLink="/species/5231190/vernacular_names">Lists all vernacular names for a name usage</@trow>
            <@trow url="/{int}/type_specimens" resp="TypeSpecimen List" paging=true respLink="/species/5231190/type_specimens">Lists all type specimens for a name usage</@trow>
      </@api.apiTable>

    </div>
  </@common.article>


<@common.article id="searching" title="Searching Names">
  <div class="fullwidth">
      <p>GBIF provides 4 different ways of finding name usages.
       They differ in their matching behavior, response format and also the actual content covered.
      </p>

  <@api.apiTable>
    <@trow_search url="/species" respLink="/species?name=Puma%20concolor" paging=true params=[3,4,7]>
      List name usages across all or some checklists that have an exact same canonical name, i.e. without authorship.
    </@trow_search>
    <@trow_search url="/species/match" respLink="/species/match?verbose=true&kingdom=Plantae&name=Oenante" paging=false params=[6,7,8,9]>
      Fuzzy match scientific names against the GBIF Backbone Taxonomy with an optional classification provided.
    </@trow_search>
    <@trow_search url="/species/search" respLink="/species/search?q=Puma&rank=GENUS" paging=true params=[1,10,11,12,13,14,15,16,17,18,19,20,21,22,23]>
        Full text search of name usages covering the scientific and vernacular name, the species description, distribution and the entire classification
        across all name usages of all or some checklists. Results are ordered by relevance as this search usually returns a lot of results.</@trow_search>
    <@trow_search url="/species/suggest" respLink="/species/suggest?name=Puma%20concolor" paging=false params=[1,6,7,8,9,10]>
        A quick and simple autocomplete service that returns up to 20 name usages prefix matching the scientific name.
        Results are ordered by relevance.
    </@trow_search>
  </@api.apiTable>

  </div>
</@common.article>


<#assign params = {
  "q": "Simple search parameter. The value for this parameter can be a simple word or a phrase. Wildcards can be added to the simple word parameters only, e.g. q=*puma*",
  "user": "User account name",
  "language": "default=en or use HTTP header for this",
  "datasetKey": "Filters by the checklist dataset key as a uuid",
  "sourceId": "Filters by the source identifier",
  "rank": "The taxonomic rank given as our <a href='http://builds.gbif.org/view/Common/job/gbif-api/site/apidocs/org/gbif/api/vocabulary/Rank.html'>Rank enum</a>",
  "name": "A case insensitive, canonical namestring, e.g 'Puma concolor'",
  "strict": "If true it (fuzzy) matches only the given name, but never a taxon in the upper classification",
  "verbose": "If true it shows alternative matches considered which had been rejected",
  "kingdom, phylum, class, order, family, genus": "optional classification parameters accepting a canonical name. If provided the default matching will also try to match against these if no direct match is found for the name alone.",
  "highertaxon_key": "Filters by any of the higher linnean rank keys. Note this is within the respective checklist and not searching nub keys across all checklists.",
  "status": "Filter by the taxonomic status.",
  "extinct": "Boolean filter for extinct taxa.",
  "habitat": "Filter by the known habitats: marine (true) or not marine (false).",
  "threat": "Filter by the threat status. Be aware, the search index has no data for threat to filter on yet.",
  "name_type": "Filter by the name type enumeration.",
  "dataset_key": "Filter by the dataset by key as a uuid",
  "nomenclatural_status": "Filter by the nomenclatural status. Be aware, the search index has no data for nomenclatural_status to filter on yet.",
  "hl": "Set hl=true, to highlight matching query in fulltext search fields.",
  "facet": "A list of facet names used to retrieve the 100 most frequent values for a field. Allowed facets are: dataset_key, highertaxon_key, rank, status, extinct, habitat, threat (no data), nomenclatural_status (no data), and name_type.",
  "facet_only": "Used in combination with facet parameter. Set facet_only=true to exclude search results.",
  "facet_mincount": "Used in combination with facet parameter. Set facet_mincount={#} to exclude facets with a count less than {#}, e.g. <a href='http://api.gbif.org/species/search?facet=status&facet_only=true&facet_mincount=7000000'>/search?facet=status&facet_only=true&facet_mincount=7000000</a> only shows the type value 'ACCEPTED' because the other status have counts less than 7,000,000",
  "facet_multiselect": "Used in combination with facet parameter. Set facet_multiselect=true to still return counts for values that are not currently filtered, e.g. <a href='http://api.gbif.org/species/search?facet=status&facet_only=true&status=ACCEPTED&facet_multiselect=true'>/search?facet=status&facet_only=true&status=ACCEPTED&facet_multiselect=true</a> still shows all status values even though status is being filtered by status=ACCEPTED"
} />

<@common.article id="parameters" title="Parameters">
    <div class="fullwidth">
        <p>The following parameters are for use exclusively with the Species API described above.</p>

      <@api.apiTable_params>
        <#list params?keys as k>
          <@api.trow_param index="${k_index + 1}" key="${k_index + 1}. ${k}" description="${params[k]}" />
        </#list>
      </@api.apiTable_params>

    </div>
</@common.article>


</body>
</html>