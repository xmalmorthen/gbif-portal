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
        taxonomically indexes all registered <a href="<@s.url value='/dataset/search?type=CHECKLIST'/>">checklist datasets</a> in the GBIF network.
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
<#macro trow url resp="NameUsage" respLink="#" paging=false params=[]>
<@api.trow url="/species"+url resp=resp respLink=respLink paging=paging params=params><#nested /></@api.trow>
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
            <@trow url="" paging=true params=[2,3,4,6]>Lists all name usages across all checklists</@trow>
            <@trow url="/root/{uuid|shortname}" paging=true >Lists root usages of a checklist</@trow>
            <@trow url="/{int}" params=[2]>Gets the single name usage</@trow>
            <@trow url="/{int}/verbatim" resp="VerbatimNameUsage">Gets the verbatim name usage</@trow>
            <@trow url="/{int}/name" resp="ParsedName">Gets the parsed name for a name usage</@trow>
            <@trow url="/{int}/parents" params=[2]>Lists all parent usages for a name usage</@trow>
            <@trow url="/{int}/children" paging=true params=[2]>Lists all direct child usages for a name usage</@trow>
            <@trow url="/{int}/related" paging=false params=[2,3]>Lists all related name usages in other checklists</@trow>
            <@trow url="/{int}/synonyms" paging=true params=[2]>Lists all synonyms for a name usage</@trow>
            <@trow url="/{int}/descriptions" resp="Description" paging=true>Lists all descriptions for a name usage</@trow>
            <@trow url="/{int}/distributions" resp="Distribution" paging=true >Lists all distributions for a name usage</@trow>
            <@trow url="/{int}/images" resp="Image" paging=true>Lists all images for a name usage</@trow>
            <@trow url="/{int}/references" resp="Reference" paging=true >Lists all references for a name usage</@trow>
            <@trow url="/{int}/species_profiles" resp="SpeciesProfile" paging=true >Lists all species profiles for a name usage</@trow>
            <@trow url="/{int}/vernacular_names" resp="VernacularName" paging=true >Lists all vernacular names for a name usage</@trow>
            <@trow url="/{int}/type_specimens" resp="TypeSpecimen" paging=true >Lists all type specimens for a name usage</@trow>
            <@trow url="/{int}/" paging=true params=[2]></@trow>
      </@api.apiTable>

    </div>
  </@common.article>


<@common.article id="name_usages" title="Searching Names">
  <div class="fullwidth">
      <p>GBIF provides 3 different ways of looking up / searching name usages.</p>

  <@api.apiTable>
    <@trow url="" paging=true params=[2,3,6]>
      List all name usages across all or some checklists that have an exact same canonical name
    </@trow>
    <@trow url="/matching" paging=false params=[5,6,7,8,9]>
      Fuzzy matching against the GBIF Backbone Taxonomy with optional classification provided.
    </@trow>
    <@trow url="/search" paging=true params=[9,10,11,20,21,22,23,24,25,26]>Full text search across all name usages of all checklists.
    Results are ordered by relevance.</@trow>
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
X, Y, Z (tbd)",
"highertaxon_key": "Filters by any of the higher linnean rank keys.
              Note this is within the respective checklist and not searching nub keys across all checklists.
              Can be used as a <a href='#p11'>facet parameter</a> value.",
"status": "Filter by the taxonomis status. Can be used as a <a href='#p11'>facet parameter</a> value.",
"extinct": "Boolean filter for extinct taxa. Can be used as a <a href='#p11'>facet parameter</a> value.",
"habitat": "Filter by the known habitats. Can be used as a <a href='#p11'>facet parameter</a> value.",
"threat": "Filter by the threat status.  Can be used as a <a href='#p11'>facet parameter</a> value.",
"name_type": "Filter by the name type enumeration. Can be used as a <a href='#p11'>facet parameter</a> value"
} />

<@api.paramArticle params=params />


</body>
</html>