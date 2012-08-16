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

<article id="overview" class="map">
  <header></header>
  <#if occ.longitude?? && occ.latitude??>
    <div id="map" latitude="${occ.latitude}" longitude="${occ.longitude}"></div>
  <#else>
    <div id="map"></div>
  </#if>
  <div class="content">

    <div class="header">
      <div class="right"><h2>Geoposition</h2></div>
    </div>

    <div class="right">
      <h3>Position</h3>
      <p class="no_bottom">${occ.locality!"?"}<#if occ.country??>, ${occ.country}</#if></p>
    <#if occ.longitude?? && occ.latitude??>
      <p class="light_note">${occ.longitude}, ${occ.latitude} (± 0.25)</p>
    </#if>

    <#if occ.altitude??>
      <h3>Altitude</h3>
      <p>${occ.altitude}m</p>
    </#if>

    <#if occ.depth??>
      <h3>Depth</h3>
      <p>${occ.depth}m</p>
    </#if>

      <h3>Geoprecision</h3>
      <p class="placeholder_temp">100m</p>

      <h3>Download</h3>
      <ul>
        <li class="download placeholder_temp"><a href="#" title="Placemark">Placemark <abbr
                title="Keyhole Markup Language">(KML)</abbr></a>
        </li>
      </ul>
    </div>
  </div>
  <footer></footer>
</article>

<@common.article id="details" title="Occurrence details">
    <div class="left">
      <div class="col">
        <h3>Basis of record</h3>
        <p>${occ.basisOfRecord!"Unknown"}</p>

        <!-- remove this div once implemented -->
        <div class="placeholder_temp">
        <h3>Individual count</h3>
        <p>1</p>

        <h3>Behavior</h3>
        <p>Foraging</p>

        <h3>Type status</h3>
        <p>Holotype</p>

        <h3>Typified name string</h3>
        <p>Puma concolor</p>
        </div>
      </div>

      <div class="col placeholder_temp">
        <h3>Sex</h3>
        <p>Male</p>

        <h3>Life stage</h3>
        <p>Juvenile</p>

        <h3>Establishment means</h3>
        <p>Wild</p>

        <h3>Reproductive condition</h3>
        <p>Pregnant</p>

        <h3>Habitat</h3>
        <p>Oak savanna</p>
      </div>

      <h3 class="placeholder_temp">Occurrence notes</h3>
      <p class="placeholder_temp">Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et
        dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea
        commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat
        nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim
        id est laborum.</p>

    </div>
    <div class="right">
      <h3>Dataset</h3>
      <p>${dataset.title!}</p>

      <h3>Data publisher</h3>
      <p><a href="<@s.url value='/organization/${(dataset.owningOrganizationKey)!}'/>"
            title="">${(dataset.owningOrganizationKey)!"Unknown"}</a></p>

      <h3>DOWNLOAD</h3>
      <ul class="placeholder_temp">
        <li class="download"><a href="#" title="Placemark">Original record</a></li>
        <li class="download"><a href="#" title="Placemark">Cached record</a></li>
      </ul>
    </div>
</@common.article>

<@common.article id="taxonomy" title="Identification details <span class='subtitle'>according to GBIF Backbone Taxonomy</span>">
    <div class="left">
      <#if occ.nubKey??>
        <h3>Identified as</h3>
        <p><a href="<@s.url value='/species/${occ.nubKey?c}'/>">${occ.scientificName}</a></p>

        <div class="placeholder_temp">
        <h3>Identification Notes</h3>
        <p>cf. alpinum${occ.identificationQualifier!}. Flowers missing, maybe confused with R.alpestre? ${occ.identificationNotes!}</p>
        </div>

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
        <p>${occ.identificationDate?date?iso_utc}}</p>
      </#if>

      <#if occ.identifierName??>
        <h3>Identified by</h3>
        <p>${occ.identifierName}</p>
      </#if>

      <h3>Identification references</h3>
      <p class="placeholder_temp">Flora of Turkey ${occ.identificationReferences!}</p>
    </div>
</@common.article>

<@common.article id="collection" title="Collection details">
    <div class="left placeholder_temp">
      <div class="col">
        <h3>Collection date </h3>
        <p>Oct 23th, 2007</p>

        <h3>Collector name</h3>
        <p>Thomas Function</p>
      </div>

      <div class="col">
        <h3>Preparations</h3>
        <p>Skull</p>

        <h3>Disposition</h3>
        <p>Missing</p>
      </div>

      <h3>Collector notes</h3>
      <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et
        dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea
        commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat
        nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim
        id est laborum.</p>
    </div>
    <div class="right">

    <#if occ.catalogNumber??>
      <h3>Catalog number</h3>
      <p>${occ.catalogNumber}</p>
    </#if>

    <#if occ.institutionCode??>
      <h3>Institution code</h3>
      <p>${occ.institutionCode}</p>
    </#if>

    <#if occ.collectionCode??>
      <h3>Collection code</h3>
      <p>${occ.collectionCode}</p>
    </#if>

    <#if occ.identifierRecords?has_content>
      <h3>Occurrence identifiers</h3>
      <#list occ.identifierRecords as i>
        <p>${i.type}: ${i.identifier}</p>
      </#list>
    </#if>

    </div>
</@common.article>

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
