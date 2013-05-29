<#import "/WEB-INF/macros/common.ftl" as common>
<#--
	Checks if a Type Specimen record is valid and returns true or false.
	Records are invalid only if they have a type status of typegenus,typespecies,genus or species
	and no scientific name is given.

	See http://dev.gbif.org/issues/browse/POR-409
-->
<#function isValidType ts>
  <#if ts.typeStatus?has_content && !ts.scientificName?has_content>
    <#list ["typegenus","typespecies","genus","species"] as test>
      <#if ts.typeStatus?replace(" ","")?lower_case = test>
        <#return false />
      </#if>
    </#list>
  </#if>
  <#return true />
</#function>

<#--
	Construct a Type Specimen header with the type status and scientific name if given.
	If a citation string is found this is shown only, otherwise the atomic pieces.
-->
<#macro status ts>
  <#if ts.typeStatus?has_content>
    ${ts.typeStatus?capitalize}
    <#if ts.scientificName?has_content>
      - <a href="<@s.url value='/species/search?q=${ts.scientificName}'/>">${ts.scientificName}</a>
    </#if>
  </#if>
  <@common.usageSource component=ts showChecklistSource=nub />
</#macro>


<#--
	Construct a Type Specimen footer with the sparse supplementory information.
	Type status & scientific name not included here!
	If a citation string is found this is shown only, otherwise the atomic pieces.
-->
<#macro details ts>
  <#if ts.citation?has_content>
    <p class="note semi_bottom">${ts.citation}</p>
  <#else>
    <#if ts.locality?has_content>
      <p class="note semi_bottom">${ts.locality}</p>
    </#if>
    <p class="light_note">
      <#assign props = {'Designation type:':'${ts.typeDesignationType!}',
      'Designated by:':'${ts.typeDesignatedBy!}',
      'Label:':'${ts.verbatimLabel!}',
      'Collection date:':'${ts.verbatimEventDate!}',
      'Collector:':'${ts.recordedBy!}',
      'Latitude:':'${ts.verbatimLatitude!}',
      'Longitude:':'${ts.verbatimLongitude!}',
      'Institution code:':'${ts.institutionCode!}',
      'Collection code:':'${ts.collectionCode!}',
      'Catalog number:':'${ts.catalogNumber!}',
      'Occurrence ID:':'${ts.occurrenceId!}'}>
      <#list props?keys as k>
        <#if props[k]?has_content>
        ${k} ${props[k]} <#if k_has_next> | </#if>
        </#if>
      </#list>
    </p>
  </#if>
</#macro>
