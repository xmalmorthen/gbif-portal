<#import "/WEB-INF/macros/pagination.ftl" as paging>
<#import "/WEB-INF/macros/common.ftl" as common>
<#import "/WEB-INF/macros/records.ftl" as records>
<html>
<head>
  <title>Species API</title>
  <link rel="stylesheet" href="<@s.url value='/css/bootstrap-tables.css'/>" type="text/css" media="all"/>
</head>

<#assign tab="species"/>
<#include "/WEB-INF/pages/developer/inc/tabs.ftl" />

<body class="api">

<@common.article id="overview" title="Introduction" titleRight="Quick links">
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
</@common.article>

<#macro trow url resp="NameUsage" paging=false params=[]>
<tr>
    <td>/species${url}</td>
    <td><a href="#" target="_blank">${resp}</a></td>
    <td><#nested/></td>
    <td>${paging?string}</td>
    <td><#list params as p><a href='#p${p}'>${p}</a><#if p_has_next>, </#if></#list></td>
</tr>
</#macro>

  <@common.article id="name_usages" title="Working with Name Usages">
    <div class="fullwidth">
        <p>A name usage is a usage of a scientific name according to one
            particular Checklist including the <a href="<@s.url value='dataset/d7dddbf4-2cf0-4f39-9b2a-bb099caae36c'/>">GBIF Taxonomic Backbone</a>
            which is just called <em>nub</em> in this API.
            Name usages from other checklists with names that also exist in the nub will
            have a nubKey that points to the related usage in the backbone.
        </p>
        
  <table class='table table-bordered table-striped table-params'>
      <thead>
      <tr>
          <th width="28%" class='total'>Endpoint URL</th>
          <th width="15%">Response</th>
          <th width="30%">Description</th>
          <th width="6%">Paging</th>
          <th width="15%">Parameters</th>
      </tr>
      </thead>

      <tbody>
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
      </tbody>
  </table>

    </div>
  </@common.article>




<@common.article id="name_usages" title="Searching Names">
  <div class="fullwidth">
      <p>GBIF provides 3 different ways of looking up / searching name usages.
      </p>

<table class='table table-bordered table-striped table-params'>
    <thead>
    <tr>
        <th width="18%" class='total'>Endpoint URL</th>
        <th width="11%">Response</th>
        <th width="43%">Description</th>
        <th width="6%">Paging</th>
        <th width="22%">Parameters</th>
    </tr>
    </thead>

    <tbody>
      <@trow url="" paging=true params=[2,3,6]>
        List all name usages across all or some checklists that have an exact same canonical name
      </@trow>
      <@trow url="/matching" paging=false params=[5,6,7,8,9]>
        Fuzzy matching against the GBIF Backbone Taxonomy with optional classification provided.
      </@trow>
      <@trow url="/search" paging=true params=[9,10,11,20,21,22,23,24,25,26]>Full text search across all name usages of all checklists.
      Results are ordered by relevance.</@trow>
    </tbody>
</table>

  </div>
</@common.article>



<@common.article id="parameters" title="Query parameters explained">
  <div class="left">
      <dl>
          <a name="p1"></a>
          <dt>user</dt>
          <dd></dd>

          <a name="p2"></a>
          <dt>language</dt>
          <dd>default=en or use HTTP header for this</dd>

          <a name="p3"></a>
          <dt>datasetKey</dt>
          <dd>The checklist dataset key as a uuid</dd>

          <a name="p4"></a>
          <dt>sourceId</dt>
          <dd></dd>

          <a name="p5"></a>
          <dt>rank</dt>
          <dd>The taxonomic rank given as our rank enum</dd>

          <a name="p6"></a>
          <dt>name</dt>
          <dd>case insensitive, canonical namestring. For example Puma concolor</dd>

          <a name="p7"></a>
          <dt>strict</dt>
          <dd>if true it (fuzzy) matches only the given name, but never a taxon in the upper classification</dd>

          <a name="p8"></a>
          <dt>verbose</dt>
          <dd>if true show alternative matches considered which had been rejected</dd>

          <a name="p9"></a>
          <dt>kingdom, phylum, class, order, family, genus</dt>
          <dd>optional classification parameters accepting a canonical name.
              If provided the default matching will also try to match against these if no direct match is found for the name alone.</dd>

          <a name="p10"></a>
          <dt>highlighting</dt>
          <dd>Highlight matching query in fulltext search fields.</dd>

          <a name="p11"></a>
          <dt>facet</dt>
          <dd>Every potential filter name below can also be used as a facet value to retrieve the 100 largest values.</dd>

          <a name="p20"></a>
          <dt>rank</dt>
          <dd>Filters by the rank of the name usage. Can be used as a <a href="#p11">facet parameter</a> value.</dd>

          <a name="p21"></a>
          <dt>highertaxon_key</dt>
          <dd>Filters by any of the higher linnean rank keys.
              Note this is within the respective checklist and not searching nub keys across all checklists.
              Can be used as a <a href="#p11">facet parameter</a> value.</dd>

          <a name="p22"></a>
          <dt>status</dt>
          <dd>Filter by the taxonomis status. Can be used as a <a href="#p11">facet parameter</a> value.</dd>

          <a name="p23"></a>
          <dt>extinct</dt>
          <dd>Boolean filter for extinct taxa. Can be used as a <a href="#p11">facet parameter</a> value.</dd>

          <a name="p24"></a>
          <dt>habitat</dt>
          <dd>Filter by the known habitats. Can be used as a <a href="#p11">facet parameter</a> value.</dd>

          <a name="p25"></a>
          <dt>threat</dt>
          <dd>Filter by the threat status.  Can be used as a <a href="#p11">facet parameter</a> value.</dd>

          <a name="p26"></a>
          <dt>name_type</dt>
          <dd>Filter by the name type enumeration. Can be used as a <a href="#p11">facet parameter</a> value</dd>

      </dl>
  </div>
</@common.article>

</body>
</html>
