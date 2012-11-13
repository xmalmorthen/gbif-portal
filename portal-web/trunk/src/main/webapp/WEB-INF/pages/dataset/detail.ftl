<#import "/WEB-INF/macros/common.ftl" as common>
<html>
<head>
  <title>${dataset.title!"???"} - Dataset detail</title>
  <content tag="extra_scripts">
    <link rel="stylesheet" href="<@s.url value='/js/vendor/leaflet/leaflet.css'/>" />
    <!--[if lte IE 8]><link rel="stylesheet" href="<@s.url value='/js/vendor/leaflet/leaflet.ie.css'/>" /><![endif]-->
    <script type="text/javascript" src="<@s.url value='/js/vendor/leaflet/leaflet.js'/>"></script>
<#if dataset.geographicCoverages?has_content>
    <script type="text/javascript" src="<@s.url value='/js/map.js'/>"></script>
</#if>
  </content>  
</head>
<body onload="initBB()" class="densitymap">

<#assign tab="info"/>
<#include "/WEB-INF/pages/dataset/inc/infoband.ftl">

<#-- SUMMARY -->
<@common.article id="taxonomic_coverage" title="Summary">
<div class="left">
  <h3>Full Title</h3>
  <p>${dataset.title}</p>

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
    <ul>
      <#list dataset.temporalCoverages as cov>
        <li>
        <#if cov.type?has_content && cov.period?has_content>
          <@s.text name="enum.verbatimtimeperiodtype.${cov.type}"/>: ${cov.period}
        <#elseif cov.date?has_content>
          Single date: ${cov.date?date}
        <#elseif cov.start?has_content && cov.end?has_content>
          Date range: ${cov.start?date} - ${cov.end?date}
        </#if>
        </li>
      </#list>
    </ul>
  </#if>

  <#if dataset.metadataLanguage?has_content>
    <h3>Language of Metadata</h3>
    <p>${dataset.metadataLanguage}</p>
  </#if>

  <#if dataset.language?has_content>
    <h3>Language of Data</h3>
    <@common.enumParagraph dataset.dataLanguage />
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

<#assign type="dataset"/>
<#include "/WEB-INF/inc/manage_tags.ftl">

  <#if dataset.logoURL?has_content>
    <div class="logo_holder">
      <img src="<@s.url value='${dataset.logoURL}'/>"/>
    </div>
  </#if>

  <#if dataset.pubDate?has_content>
    <h3>Publication Date</h3>
    <p>${(dataset.pubDate?date)}</p>
  </#if>

  <#if parentDataset??>
    <h3>Constituent of</h3>
    <p><a href="<@s.url value='/dataset/${parentDataset.key}'/>" title="${parentDataset.title!"Unknown"}">${parentDataset.title!"Unknown"}</a></p>
  </#if>

  <!-- Only show network of origin, if there was no owning organization, as is case for external datasets -->
  <#if owningOrganization??>
    <h3>Published by</h3>
    <p><a href="<@s.url value='/organization/${owningOrganization.key}'/>"
          title="${owningOrganization.title!"Unknown"}">${owningOrganization.title!"Unknown"}</a></p>
  <#elseif networkOfOrigin??>
    <h3>Originates from</h3>
    <p><a href="<@s.url value='/network/${networkOfOrigin.key}'/>"
          title="${networkOfOrigin.title!"Unknown"}">${networkOfOrigin.title!"Unknown"}</a></p>
  </#if>

  <!-- Only show hosting organization if it's different from owning / publishing org -->
  <#if hostingOrganization??>
    <h3>Hosted by</h3>
    <p><a href="<@s.url value='/organization/${hostingOrganization.key}'/>"
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

  <#if dataset.homepage?has_content || links?has_content>
    <h3>Links</h3>
    <ul>
      <#if dataset.homepage?has_content>
      <li><a href="<@s.url value='${dataset.homepage}'/>" title="Dataset homepage">Dataset homepage</a></li>
      </#if>
      <#list links as p>
        <#if p.url?has_content>
          <li>
            <a href="<@s.url value='${p.url}'/>" title="<@s.text name='enum.endpointtype.${p.type}'/>"><@s.text name="enum.endpointtype.${p.type}"/></a>
          </li>
        </#if>
      </#list>

    </ul>
  </#if>

  <#-- DATA DESCRIPTIONS -->
  <#if dataset.dataDescriptions?has_content || dataLinks?has_content>
    <h3>External Data</h3>
    <ul>
    <#list dataLinks as p>
      <#if p.url?has_content>
        <li>
          <a href="${p.url}" title="<@s.text name='enum.endpointtype.${p.type}'/>"><@s.text name="enum.endpointtype.${p.type}"/></a>
        </li>
      </#if>
    </#list>
    <#list dataset.dataDescriptions as dd>
      <li>
        <a href="${dd.url}">${dd.name!dd.url}</a>
        <#if dd.format?has_content || dd.charset?has_content>
          <div class="note">${dd.format!} ${dd.formatVersion!}<#if dd.format?has_content && dd.charset?has_content>&middot;</#if> ${dd.charset!}</div>
        </#if>
      </li>
    </#list>
    </ul>
  </#if>

  <h3>Metadata Documents</h3>
  <ul>
    <li class="download"><a href="${cfg.wsReg}dataset/${dataset.key}/eml">GBIF EML</a></li>
    <li class="download"><a href="${cfg.wsReg}dataset/${dataset.key}/document">Original Source</a></li>
    <#list metaLinks as p>
      <#if p.url?has_content>
        <li>
          <a href="${p.url}" title="<@s.text name='enum.endpointtype.${p.type}'/>"><@s.text name="enum.endpointtype.${p.type}"/></a>
          <#if p.type=="EML">
            <@common.popup message="This is a link to the original metadata document. The metadata may be different from the version that is displayed if it has been updated since the time the dataset was last indexed." title="Warning"/>
          </#if>
        </li>
      </#if>
    </#list>
  </ul>

</div>

</@common.article>


<#-- TAXONOMIC COVERAGE -->
<#if metrics?? || (dataset.taxonomicCoverages?size>0)>
 <@common.article id="taxonomic_coverage" title="Taxonomic Coverage">
 <div class="left">
    <#list dataset.taxonomicCoverages as cov>
      <#if cov.description?has_content>
        <p>${cov.description}</p>
        <p>
        <#list cov.coverages as tax>
          <#if tax.scientificName?has_content || tax.commonName?has_content >
            <#-- Keep the following as 1 line otherwise whitespace appears after each name. For some reason the right trim Freemarker directive does not work with the if else conditions -->
            <a href="<@s.url value='/species/search?q=${tax.scientificName!tax.commonName}'/>"><#if tax.scientificName?has_content>${tax.scientificName}<#if tax.commonName?has_content>(${tax.commonName})</#if><#else>${tax.commonName}</#if><a/><#if tax_has_next>, </#if>
          </#if>
        </#list>
        </p>
        <br/>
      </#if>
    </#list>
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
</#if>

<#if dataset.type?has_content && dataset.type == "CHECKLIST">
<@common.article id="taxonomy" title="Browse Classification" class="taxonomies">
<div class="fullwidth">
  <div id="taxonomicBrowser">
    <div class="breadcrumb">
      <ul>
        <li spid="-1" cid="${id}"><a href="#">All</a></li>
      </ul>
    </div>
    <div class="loadingTaxa"><img src="../img/taxbrowser-loader.gif"></div>
    <div class="inner">
      <div class="sp">
        <ul>
        </ul>
      </div>
    </div>
  </div>
</div>
</@common.article>
</#if>


<#if dataset.geographicCoverages?has_content>
<article class="map">
  <header></header>

  <div id="zoom_in" class="zoom_in"></div>
  <div id="zoom_out" class="zoom_out"></div>

  <div id="map" type="DATASET" key="${dataset.key}"></div>
  
  <script>
    // create an array of the bounding boxes from the geographic coverages
    // we ignore anything that is global as that tells us very little
    bboxes = [
    <#list dataset.geographicCoverages as geo>
       <#if geo.boundingBox?has_content && (!geo.boundingBox.isGlobalCoverage())>
         [${geo.boundingBox.minLatitude},${geo.boundingBox.maxLatitude},${geo.boundingBox.minLongitude},${geo.boundingBox.maxLongitude}],
       </#if>
    </#list>
    ];
  </script>
  
  <div class="content">
      <div class="header">
        <div class="right"><h2>Geographic Coverages</h2></div>
      </div>
	  <div class="right">
      <div class="inner">
        <#list dataset.geographicCoverages as geo>
          <p>${geo.description!}</p>
        </#list>
      </div>
	  </div>
  </div>
  <footer></footer>
</article>
</#if>


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
          <li> <@common.contact con=per /> </li>
          <#if per_has_next && per_index==3>
            <li> <a class="more_link" href="<@s.url value='/dataset/${dataset.key}/contacts'/>">see all</a> </li>
            <#break />
          </#if>
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
        <#if ap_has_next && ap_index==3>
          <li> <a class="more_link" href="<@s.url value='/dataset/${dataset.key}/contacts'/>">see all</a> </li>
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
    <ul class="notes">
      <#list sd.methodSteps as step>
       <li>
        <#if step.title?has_content> ${step.title} <#else> #${step_index+1} </#if>
        <#if step.description?has_content>
          <span class="note">${step.description}</span>
        </#if>
        <#if step.instrumentation?has_content>
          <span class="note">Instrumentation: ${step.instrumentation}</span>
        </#if>
       </li>
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
              <li>${unit.lower} - ${unit.upper} ${unit.typeVerbatim?lower_case}</li>
            <#elseif unit.typeVerbatim?has_content && unit.count!=0>
              <li>${unit.count} <#if unit.deviation?has_content> ± ${unit.deviation}</#if> ${unit.typeVerbatim?lower_case}</li>
            </#if>
          </#list>
        </ul>
      </#if>
    </#list>
  </#if>
</div>
</@common.article>
</#if>

<#-- CITATIONS -->
<#if dataset.bibliographicCitations?has_content >
<@common.article id="references" title="References">
<div class="fullwidth">
  <#if (dataset.bibliographicCitations?size>0)>
    <#list dataset.bibliographicCitations as ref>
      <p>
        <@common.citation ref/>
      </p>
    </#list>
  </#if>
</div>
</@common.article>
</#if>

<#-- LEGAL -->
<@common.article id="legal" title="Dataset usage & legal issues" class="mono_line">
<div class="fullwidth">
  <#if dataset.intellectualRights?has_content>
    <h3>Usage rights</h3>
    <p>${dataset.intellectualRights}</p>
  </#if>

  <h3>How to cite</h3>
  <p>
    <#if dataset.citation??>
      <@common.citation dataset.citation />
    <#else>
      missing, see <a href="http://dev.gbif.org/issues/browse/REG-229">REG-229</a>
    </#if>
  </p>

</div>
</@common.article>

<#if (constituents.results)?has_content>
<@common.article id="datasets" title="Constituent Datasets">
  <div class="left">
      <ul class="notes">
        <#list constituents.results as d>
          <li>
            <a href="<@s.url value='/dataset/${d.key}'/>">${d.title!"???"}</a>
            <span class="note">A ${d.subtype!} <@s.text name="enum.datasettype.${d.type!}"/>
              <#if d.pubDate??>${d.pubDate?date?string.medium}</#if></span>
          </li>
        </#list>
        <#if !constituents.isEndOfRecords()>
          <li>
            <a class="more_link" href="<@s.url value='/dataset/${member.key}/constituents'/>">see all</a>
          </li>
        </#if>
      </ul>
  </div>
</@common.article>
</#if>

</body>
</html>
