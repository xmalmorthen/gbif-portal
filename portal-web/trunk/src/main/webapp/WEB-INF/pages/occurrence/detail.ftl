<#import "/WEB-INF/macros/common.ftl" as common>
<html>
<head>
  <title>Occurrence Detail ${id?c}</title>
  <meta name="menu" content="occurrences"/>
<#-- RDFa -->
  <meta property="dwc:scientificName" content="${occ.scientificName!}"/>
  <meta property="dwc:kingdom" content="${occ.kingdom!}"/>
  <#if dataset.key??>
  <meta property="dwc:datasetID" content="${dataset.key!}"/>
  <meta property="dwc:datasetName" content="${dataset.title!}"/>
  <meta rel="dc:isPartOf" href="<@s.url value='/dataset/${dataset.key}'/>"/>
  </#if>
  <style type="text/css">
    article#taxonomy .content ul {
      margin: 0 1px 26px 0px;
    }
  </style>
  <link rel="stylesheet" href="<@s.url value='/js/vendor/leaflet/leaflet.css'/>" />
  <!--[if lte IE 8]><link rel="stylesheet" href="<@s.url value='/js/vendor/leaflet/leaflet.ie.css'/>" /><![endif]-->
  <content tag="extra_scripts">
    <script type="text/javascript" src="<@s.url value='/js/vendor/leaflet/leaflet.js'/>"></script>
    <script type="text/javascript" src="<@s.url value='/js/map.js'/>"></script>
  </content>  
</head>
<body class="pointmap">

<#assign tab="info"/>
<#include "/WEB-INF/pages/occurrence/infoband.ftl">

<#assign showMap=occ.longitude?? && occ.latitude??/>
<#if showMap>
  <#assign titleRight="Geoposition"/>
</#if>

<@common.article id="location" title="Geoposition" titleRight=titleRight! class="map">
  <#if showMap>
    <div id="map" latitude="${occ.latitude}" longitude="${occ.longitude}"></div>
    <div class="right">
      <h3>Locality</h3>
        <p class="no_bottom">${occ.locality!"?"}<#if occ.country??>, ${occ.country}</#if></p>
        <p class="light_note">${occ.longitude}, ${occ.latitude} (± 0.25)</p>

  <#else>
    <div class="left">
    <#if occ.continent??>
        <h3>Continent</h3>
        <p>${occ.continent}</p>
    </#if>

    <#if occ.country??>
        <h3>Country</h3>
        <p>${occ.country}</p>
    </#if>

    <#if occ.continent??>
        <h3>State/Province</h3>
        <p>${occ.province}</p>
    </#if>

    <#if occ.county??>
        <h3>County</h3>
        <p>${occ.county}</p>
    </#if>

    <#if occ.locality??>
        <h3>Locality</h3>
        <p>${occ.locality}</p>
    </#if>
  </#if>

    <#if occ.altitude??>
      <h3>Altitude</h3>
      <p>${occ.altitude}m</p>
    </#if>

    <#if occ.depth??>
      <h3>Depth</h3>
      <p>${occ.depth}m</p>
    </#if>
   </div>

</@common.article>


<@common.article id="source" title="Source details">
    <div class="left">
      <h3>Data publisher</h3>
      <p>
        <a href="<@s.url value='/organization/${publisher.key}'/>"
            title="">${publisher.title}</a>
      </p>
      <h3>Dataset</h3>
      <p>${dataset.title!}</p>


      <#if occ.institutionCode??>
        <h3>Institution code</h3>
        <p>${occ.institutionCode}</p>
      </#if>

      <#if occ.collectionCode??>
        <h3>Collection code</h3>
        <p>${occ.collectionCode}</p>
      </#if>
    </div>

    <div class="right">
      <h3>GBIF ID</h3>
      <p>${occ.id?c}</p>

      <#if occ.catalogNumber??>
        <h3>Catalog number</h3>
        <p>${occ.catalogNumber}</p>
      </#if>

      <#list occ.identifierRecords as i>
        <h3>${i.type}</h3>
        <p>${i.identifier}</p>
      </#list>
    </div>
</@common.article>

<#assign title>
Identification details <span class='subtitle'>According to <a href="<@s.url value='/dataset/d7dddbf4-2cf0-4f39-9b2a-bb099caae36c'/>">GBIF Backbone Taxonomy</a></span>
</#assign>
<@common.article id="taxonomy" title=title>
    <div class="left">
      <#if occ.nubKey??>
        <h3>Identified as ${occ.rank!"species"}</h3>
        <p><a href="<@s.url value='/species/${occ.nubKey?c}'/>">${occ.scientificName}</a></p>

        <#if occ.identificationNotes??>
          <h3>Notes</h3>
          <p>${occ.identificationNotes}</p>
        </#if>

        <h3>Taxonomic classification
          <div class="extended">[<a href="<@s.url value='/species/${occ.nubKey?c}/classification'/>">extended</a>]</div>
        </h3>
        <#assign classification=occ.higherClassificationMap />
        <ul class="taxonomy">
          <#list classification?keys as key>
            <li<#if !key_has_next> class="last"</#if>><a href="<@s.url value='/species/${key?c}'/>">${classification.get(key)}</a></li>
          </#list>
        </ul>
      </#if>
    </div>
    <div class="right">
      <#if occ.identificationDate??>
        <h3>Identification date </h3>
        <p>${occ.identificationDate?date?string.medium}</p>
      </#if>

      <#if occ.identifierName??>
        <h3>Identified by</h3>
        <p>${occ.identifierName}</p>
      </#if>

      <#-- TODO: uncomment once implemented
      <h3>Identification references</h3>
      <p>Flora of Turkey ${occ.identificationReferences!}</p>
      -->
    </div>
</@common.article>

<@common.article id="collection" title="Collection details">
  <div class="left">
    <div class="col">
      <h3>Basis of record</h3>
      <p>${occ.basisOfRecord!"Unknown"}</p>

      <#if occ.occurrenceDate??>
        <h3>Gathering date </h3>
        <#-- show year or month only if no full date exists. same for time !!! -->
        <p>${occ.occurrenceDate?datetime?string.medium}</p>
        <p>${.now?datetime?string.medium}</p>
      </#if>

      <#if occ.collectorName??>
        <h3>Collector name</h3>
        <p>${occ.collectorName}</p>
      </#if>

      <#-- TODO: uncomment once implemented
      <h3>Individual count</h3>
      <p>1</p>

      <h3>Preparations</h3>
      <p>Skull</p>

      <h3>Disposition</h3>
      <p>Missing</p>
      -->
    </div>

    <div class="col">
      <#-- TODO: uncomment once implemented
      <h3>Sex</h3>
      <p>Male</p>

      <h3>Life stage</h3>
      <p>Juvenile</p>

      <h3>Behavior</h3>
      <p>Foraging</p>

      <h3>Establishment means</h3>
      <p>Wild</p>

      <h3>Reproductive condition</h3>
      <p>Pregnant</p>

      <h3>Habitat</h3>
      <p>Oak savanna</p>
      -->
    </div>

<#-- TODO: uncomment once implemented
    <h3>Notes</h3>
    <p>${occ.notes}</p>
-->

  </div>

  <div class="right">
    <#-- TODO: uncomment once implemented
    <h3>Type status</h3>
    <p>Holotype</p>
    -->
  </div>

</@common.article>

<#-- TODO: uncomment once implemented
<@common.article id="geology" title="Geological context" class="placeholder_temp">
    <div class="left">
      <div class="col">
        <h3>Eon</h3>
        <p>XYZ</p>

        <h3>Era</h3>
        <p>XYZ</p>

        <h3>Period</h3>
        <p>XYZ</p>

        <h3>Epoch</h3>
        <p>XYZ</p>

        <h3>Age</h3>
        <p>XYZ</p>
      </div>

      <div class="col">
        <h3>Biostratigraphic zone</h3>
        <p>XYZ</p>

        <h3>Lithostratigraphic terms</h3>
        <p>XYZ</p>
      </div>
    </div>
    <div class="right">
      <h3>Group</h3>
      <p>XYZ</p>

      <h3>Formation</h3>
      <p>XYZ</p>

      <h3>Member</h3>
      <p>XYZ</p>

      <h3>Bed</h3>
      <p>XYZ</p>
    </div>
</@common.article>
-->

<@common.article id="legal" title="Usage & legal issues" class="mono_line placeholder_temp">
    <div class="left">
      <h3>USAGE RIGHTS</h3>
      <p>Released under an Open Data licence, so it can be used to anyone who cites it. </p>

      <h3>HOW TO CITE IT</h3>
      <p>Alaska Ocean Observing System, Arctic Ocean Diversity (accessed through GBIF data portal,
        <a href="http://data.gbif.org/datasets/resource/654">http://data.gbif.org/datasets/resource/654</a>,
        2011-05-05)</p>
    </div>
</@common.article>

<@common.notice title="Further information">
<p>There may be more details available about this occurrence in the
  <a href="<@s.url value='/occurrence/${id?c}/verbatim'/>">verbatim version</a> of the record</p>
</@common.notice>

</body>
</html>
