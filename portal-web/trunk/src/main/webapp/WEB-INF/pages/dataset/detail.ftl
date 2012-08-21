<#import "/WEB-INF/macros/common.ftl" as common>
<#import "/WEB-INF/macros/manage_tags.ftl" as manage>
<html>
<head>
  <title>${dataset.title!"???"} - Dataset detail</title>
  <content tag="extra_scripts">
    <link rel="stylesheet" href="<@s.url value='/js/vendor/leaflet/leaflet.css'/>" />
    <!--[if lte IE 8]><link rel="stylesheet" href="<@s.url value='/js/vendor/leaflet/leaflet.ie.css'/>" /><![endif]-->
    <script type="text/javascript" src="<@s.url value='/js/vendor/leaflet/leaflet.js'/>"></script>
    <script type="text/javascript" src="<@s.url value='/js/map.js'/>"></script>
  </content>  
</head>
<body onload="initBB()" class="densitymap">

<#assign tab="info"/>
<#include "/WEB-INF/pages/dataset/infoband.ftl">

<#-- SUMMARY -->
<@common.article id="taxonomic_coverage" title="Summary">
<div class="left">
  <#if dataset.description?has_content>
    <h3>Description</h3>

    <p>${dataset.description}</p>
  </#if>
<#-- purpose doesn't exist yet -->
  <#if dataset.purpose?has_content>
    <h3>Purpose</h3>

    <p>${dataset.purpose}</p>
  </#if>
<#-- additionalInformation doesn't exist yet -->
  <#if dataset.additionalInfo?has_content>
    <h3>Additional Information</h3>

    <p>${dataset.additionalInfo}</p>
  </#if>

  <#if dataset.temporalCoverages?has_content>
    <h3>Temporal coverages</h3>
    <#list dataset.temporalCoverages as cov>
      <#if cov.type?has_content && cov.type=="FORMATION_PERIOD">
        <h4>Formation period (verbatim)</h4>

        <p>${cov.period!""}</p>
        <#elseif cov.type?has_content && cov.type =="LIVING_TIME_PERIOD">
          <h4>Living time period (verbatim)</h4>

          <p>${cov.period!""}</p>
        <#elseif cov.date?has_content>
          <h4>Single date</h4>

          <p>${cov.date?date}</p>
        <#elseif cov.start?has_content && cov.start?has_content>
          <h4>Date range</h4>

          <p>${cov.start?date} - ${cov.end?date}</p>
      </#if>
    </#list>
  </#if>

  <#if dataset.metadataLanguage?has_content>
    <h3>Language of Metadata</h3>

    <p>${dataset.metadataLanguage}</p>
  </#if>

  <#if dataset.language?has_content>
    <h3>Language of Data</h3>
  <@common.enum dataset.dataLanguage />
  </#if>

  <#if (preferredContacts?size>0) >
    <h3>Primary Contacts</h3>
    <ul class="team">
      <#list preferredContacts as cnt>
        <li><@common.contact con=cnt /></li>
      </#list>
    </ul>
  </#if>

</div>

<div class="right">
  <#assign max_show_length = 30>

<@manage.manageTags type="dataset"/>

  <#if dataset.logoURL?has_content>
    <div class="logo_holder">
      <img class="logo" src="<@s.url value='${dataset.logoURL}'/>"/>
    </div>
  </#if>

  <h3>Dataset Type</h3>
  <#if dataset.type?has_content>
    <p><@s.text name="enum.datasettype.${dataset.type}"/></a></p>
    <#else>
      <p>Unknown</p>
  </#if>

  <h3>Publication Date</h3>

  <p>${(dataset.pubDate?date)!"Unkown"}</p>

  <h3>Published by</h3>
  <#if dataset.owningOrganizationKey?has_content>
    <p><a href="<@s.url value='/organization/${dataset.owningOrganizationKey}'/>"
          title="${owningOrganization.title!"Unknown"}">${owningOrganization.title!"Unknown"}</a></p>
    <#else>
      <p>Unknown</p>
  </#if>

  <!-- Only show hosting organization if it's different from owning / publishing org -->
  <#if hostingOrganization?has_content && dataset.hostingOrganizationKey != dataset.owningOrganizationKey>
    <h3>Hosted by</h3>

    <p><a href="<@s.url value='/organization/${dataset.hostingOrganizationKey}'/>"
          title="${hostingOrganization.title!"Unknown"}">${hostingOrganization.title!"Unknown"}</a></p>
  </#if>

  <!-- Could be an external dataset, with an owning org, but no endorsing node since it's not in GBIF Network -->
  <#if (owningOrganization.endorsingNode)?has_content>
    <h3>Endorsed by</h3>

    <p><a href="<@s.url value='/node/${owningOrganization.endorsingNode.key}'/>"
          title="${owningOrganization.endorsingNode.title!"Unknown"}">${owningOrganization.endorsingNode.title!"Unknown"}</a>
    </p>
  </#if>

  <!-- Ideally the alt. identifier has a type which is displayed as a link to the identifier. Otherwise, a trimmed version is displayed. In both cases, a popup appears to display the full identifier. -->
  <#if (dataset.identifiers?size>0)>
    <h3>Alternative Identifiers</h3>
    <ul>
      <#list dataset.identifiers as idt>
        <#if idt.type?has_content>
          <#if idt.type == "LSID" || idt.type == "URL">
            <li><a href="${idt.identifier}">${common.limit(idt.identifier!"",max_show_length)}</a></li>
            <#elseif idt.type == "UNKNOWN">
              <li>${common.limit(idt.identifier!"",max_show_length)}<@common.popup message=idt.identifier title="Alternate Identifier"/></li>
            <#else>
              <li><a href="${idt.identifier}"><@s.text name="enum.identifiertype.${idt.type}"/></a></li>
          </#if>
          <#else>
            <li>${common.limit(idt.identifier!"",max_show_length)}<@common.popup message=idt.identifier title="Alternate Identifier"/></li>
        </#if>
      </#list>
    </ul>
  </#if>

  <#if dataset.endpoints?has_content>
    <h3>Online Services</h3>
    <ul>
      <#list dataset.endpoints as point>
        <#if point.type?has_content && point.url?has_content>
          <li>
            <a href="<@s.url value='${point.url}'/>" title="${point.type} endpoint">
            <@s.text name="enum.endpointtype.${point.type}"/>
              <#if point.type=="EML">
            <@common.popup message="This is a link to the original metadata document. The metadata may be different from the version that is displayed if it has been updated since the time the dataset was last indexed." title="Warning"/>
            </#if>
            </a>
          </li>
        </#if>
      </#list>
    </ul>
  </#if>

  <h3>External Links</h3>
  <ul>
    <#if dataset.homepage?has_content>
      <li><a href="<@s.url value='${dataset.homepage}'/>" title="Dataset homepage">Dataset homepage</a></li>
    </#if>
    <li><a class="placeholder_temp" href="#" title="Author's blog">Author's blog</a></li>
    <li><a class="placeholder_temp" href="#" title="Methodology">A discussion board over the methodology</a></li>
  </ul>

  <h3>Metadata</h3>
  <ul>
    <li class="download, placeholder_temp">EML file <a class="placeholder_temp" href="#"><abbr>[ENG]</abbr></a> &middot;
      <a href="#"><abbr>[SPA]</abbr></a> &middot; <a href="#"><abbr>[GER]</abbr></a></li>
    <li class="download, placeholder_temp">ISO 1939 file <a class="placeholder_temp"
                                                            href="#"><abbr>[ENG]</abbr></a> &middot; <a href="#"><abbr>[SPA]</abbr></a> &middot;<a
            href="#"><abbr>[GER]</abbr></a></li>
  </ul>
</div>

</@common.article>


<#-- TAXONOMIC COVERAGE -->
<@common.article id="taxonomic_coverage" title="Taxonomic Coverage">
<div class="left">
  <#if (dataset.taxonomicCoverages?size>0)>
  <#-- descriptions -->
    <#list dataset.taxonomicCoverages as cov>
      <#if cov.description?has_content>
        <p>${cov.description}</p>
      </#if>
    </#list>
  <#-- keywords -->
    <#assign more=false/>
    <ul class="three_cols">
      <#list dataset.taxonomicCoverages as cov>
        <#if more>
          <#break />
        </#if>
        <#if cov.coverages?has_content>
          <#list cov.coverages as innerCov>
            <#if (innerCov.scientificName?has_content || innerCov.commonName?has_content)>
              <li>
                <a href="<@s.url value='/species/search?q=${innerCov.scientificName!innerCov.commonName}'/>">
                  <#if innerCov.scientificName?has_content>
                  ${innerCov.scientificName} <#if innerCov.commonName?has_content>(${innerCov.commonName})</#if>
                    <#else>
                    ${innerCov.commonName}
                  </#if>
                  <a/>
              </li>
            </#if>
            <#if innerCov_index==8>
              <#assign more=true/>
              <#break />
            </#if>
          </#list>
          <#if more>
            <p><span>The complete list has ${cov.coverages?size} elements.</span></p>
          </#if>
        </#if>
      </#list>
      <p><a href="#" class="download" title="Download all the elments">&nbsp;Download them all</a>.</p>
    </ul>
  </#if>
</div>

<div class="right">
 <#if metrics??>
  <#if metrics.countByKingdom?has_content>
    <h3>By Kingdom</h3>
    <ul>
      <#list kingdomEnum as k>
        <#if metrics.countByKingdom(k)?has_content>
          <li><@s.text name="enum.kingdom.${k}"/> <span class="number">${metrics.countByKingdom(k)!0}</span></li>
        </#if>
      </#list>
    </ul>
  </#if>

  <#if metrics.countByRank?has_content>
    <h3>By Rank</h3>
    <ul>
      <#list rankEnum as k>
        <#if metrics.countByRank(k)?has_content>
          <li><@s.text name="enum.rank.${k}"/> <span class="number">${metrics.countByRank(k)!0}</span></li>
        </#if>
      </#list>
    </ul>
  </#if>

  <#if metrics.countExtensionRecords?has_content>
    <h3>Associated Data</h3>
    <ul>
      <#list extensionEnum as k>
        <#if ((metrics.getExtensionRecordCount(k)!0)>0)>
          <li><@s.text name="enum.extension.${k}"/> <span class="number">${metrics.getExtensionRecordCount(k)!0}</span></li>
        </#if>
      </#list>
    </ul>
  </#if>
 </#if>
</div>
</@common.article>

<#if dataset.type?has_content && dataset.type == "CHECKLIST">
<@common.article id="taxonomy" title="Browse Classification" class="taxonomies">
<div class="left">
  <#include "/WEB-INF/pages/species/taxbrowser.ftl">
</div>
<div class="right">
</div>
</@common.article>
</#if>

<article class="map">
  <header></header>
  <div id="map" type="DATASET" key="${dataset.key}"></div>
  
  <script>
    // create an array of the bounding boxes from the geographic coverages
    // we ignore anything that is global as that tells us very little
    var bboxes = [
    <#list dataset.geographicCoverages as geo>
       <#if geo.boundingBox?has_content && (!geo.boundingBox.isGlobalCoverage())>
         [${geo.boundingBox.minLatitude},${geo.boundingBox.maxLatitude},${geo.boundingBox.minLongitude},${geo.boundingBox.maxLongitude},],
       </#if>
    </#list>
    ];
  </script>
  
  <div class="content">
      <div class="header">
        <div class="right"><h2>Geographic Coverages</h2></div>
      </div>
	  <div class="right">
        <#list dataset.geographicCoverages as geo>
            <#assign extended_desc_len = 150>
            <p>${common.limit(geo.description!"",extended_desc_len)}
              <#if (geo.description?length>extended_desc_len) ><@common.popup message=geo.description title="Description"/></#if>
            </p>
        </#list>
	  </div>
  </div>
  <footer></footer>
</article>


<#-- PROJECT -->
<#if dataset.project?has_content || (otherContacts?size>0) >
<@common.article id="project" title='${(dataset.project.title)!"Project"}'>
<div class="left">
  <#if dataset.project?has_content>
    <#assign proj=dataset.project />
    <#if proj.studyAreaDescription?has_content>
      <h3>Study area description</h3>

      <p>${proj.studyAreaDescription}</p>
    </#if>

    <#if proj.designDescription?has_content>
      <h3>Design description</h3>

      <p>${proj.designDescription}</p>
    </#if>

    <#if proj.funding?has_content>
      <h3>Funding</h3>

      <p>${proj.funding}</p>
    </#if>

    <#if proj.contacts?has_content>
      <h3>Project Personnel</h3>
      <ul class="team">
        <#list proj.contacts as per>
          <li>
          <@common.contact con=per />
          </li>
        </#list>
      </ul>
    </#if>
  </#if>
</div>

<div class="right">
  <#if (otherContacts?size>0) >
    <h3>Associated parties</h3>
    <ul class="team">
      <#list otherContacts as ap>
        <li><@common.contact con=ap /></li>
      <#-- only show 3 references at max. If we have 3 (index=2) we know there are more to show -->
        <#if ap_index==2>
          <p><a class="more_link, placeholder_temp" href="">see all</a></p>
          <#break />
        </#if>
      </#list>
    </ul>
  </#if>
</div>
</@common.article>
</#if>

<#-- METHODS -->
<#if dataset.samplingDescription?has_content>
<@common.article id="methods" title="Methodolgy">
  <#assign sd=dataset.samplingDescription />
<div class="left">

  <#if sd.studyExtent?has_content>
    <h3>Study extent</h3>

    <p>${sd.studyExtent}</p>
  </#if>

  <#if sd.sampling?has_content>
    <h3>Sampling description</h3>

    <p>${sd.sampling}</p>
  </#if>

  <#if sd.qualityControl?has_content>
    <h3>Quality control</h3>

    <p>${sd.qualityControl}</p>
  </#if>

  <#if sd.methodSteps?has_content>
    <h3>Method Steps</h3>
    <ul>
      <#list sd.methodSteps as step>
        <h4>Method Step ${step_index+1}</h4>
        <#if step.title?has_content>
          <li>Title: ${step.title}</li>
        </#if>
        <#if step.description?has_content>
          <li>Description: ${step.description}</li>
        </#if>
        <#if step.instrumentation?has_content>
          <li>Instrumentation: ${step.instrumentation}</li>
        </#if>
      </#list>
    </ul>
  </#if>
</div>

<div class="right">
  <#if dataset.collections?has_content>
    <#list dataset.collections as col>
      <#if col.collectionName?has_content>
        <h3>Collection name</h3>

        <p>${col.collectionName}</p>
      </#if>

      <#if col.collectionIdentifier?has_content>
        <h3>Collection Identifier</h3>

        <p>${col.collectionIdentifier}</p>
      </#if>

      <#if col.parentCollectionIdentifier?has_content>
        <h3>Parent Collection Identifier</h3>

        <p>${col.parentCollectionIdentifier}</p>
      </#if>

      <#if col.specimenPreservationMethod?has_content>
        <h3>Specimen Preservation method</h3>

        <p><@s.text name="enum.preservationmethodtype.${col.specimenPreservationMethod}"/></a></p>
      </#if>

      <#if col.curatorialUnits?has_content >
        <h3>Curational Units</h3>
        <ul>
          <#list col.curatorialUnits as unit>
            <#if unit.typeVerbatim?has_content && unit.lower!=0 && unit.upper!=0>
              <h4>Count range</h4>
              <li>${unit.typeVerbatim!""}: between ${unit.lower} and ${unit.upper}</li>
              <#elseif unit.typeVerbatim?has_content && unit.count!=0>
                <h4>Count with uncertainty</h4>
                <li>${unit.typeVerbatim!""}: ${unit.count} ± ${unit.deviation!""}</li>
            </#if>
          </#list>
        </ul>
      </#if>
    </#list>
  </#if>
</div>
</@common.article>
</#if>

<#-- DATA DESCRIPTIONS -->
<#if dataset.dataDescriptions?has_content>
<@common.article id="data_descriptions" title="Related Data">
<div class="left">
  <#list dataset.dataDescriptions as dd>
    <h3>${dd.name!"Data object"}</h3>

    <#if dd.charset?has_content>
      <h4>Character Set</h4>

      <p>${dd.charset}</p>
    </#if>

    <#if dd.format?has_content>
      <h4>Data Format</h4>

      <p>${dd.format}</p>
    </#if>

    <#if dd.formatVersion?has_content>
      <h4>Data Format Version</h4>

      <p>${dd.formatVersion}</p>
    </#if>

    <#if dd.url?has_content>
      <h4>Download URL</h4>

      <p><a href="${dd.url}">${dd.url}</a></p>
    </#if>
  </#list>
</div>
</@common.article>
</#if>

<#-- CITATIONS -->
<#if ( dataset.citation?has_content && (dataset.citation.identifier?has_content || dataset.citation.text?has_content)) || dataset.bibliographicCitations?has_content >
<@common.article id="references" title="Citations">
<div class="left">
  <#if dataset.citation.identifier?has_content || dataset.citation.text?has_content>
    <h3>Citation</h3>

    <p><@common.citation dataset.citation/></p>
  </#if>

  <#if (dataset.bibliographicCitations?size>0)>
    <h3>Bibliographic Citations</h3>
    <#list dataset.bibliographicCitations as ref>
      <p><@common.citation ref/></p>
    <#-- only show 9 references at max. If we have 10 (index=9) we know there are more to show -->
      <#if ref_index==7>
        <p><a class="more_link, placeholder_temp" href="">see all</a></p>
        <#break />
      </#if>
    </#list>
  </#if>
</div>
</@common.article>
</#if>

<#-- LEGAL -->
<@common.article id="legal" title="Dataset usage & legal issues" class="mono_line">
<div class="left">
  <#if dataset.intellectualRights?has_content>
    <h3>Usage rights</h3>

    <p>${dataset.intellectualRights}</p>
  </#if>

  <h3>How to cite it</h3>

  <p>${dataset.title!"???"} (accessed through GBIF data portal, <a href="${baseUrl}/dataset/${dataset.key}"
                                                                   title="${dataset.title!}">${baseUrl}
    /dataset/${dataset.key}</a>, ${.now?date})</p>
</div>
</@common.article>

</body>
</html>
