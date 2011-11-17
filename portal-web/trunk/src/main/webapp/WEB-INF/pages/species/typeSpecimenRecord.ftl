<div>
<p class="no_bottom">
<#-- the scientific name must be present, or nothing gets shown -->
<#if ts.typeStatus?has_content>
${ts.typeStatus?capitalize}
  <#if ts.scientificName?has_content>
    - ${ts.scientificName}
    <#else>
    ${usage.scientificName}
  </#if>
</#if>
<@common.usageSource component=ts showChecklistSource=nub />
<#if ts.citation?has_content>
  <p class="note semi_bottom">${ts.citation}</p>
  <#if ts.locality?has_content>
    <p class="note semi_bottom">${ts.locality}</p>
  </#if>
<#else>
  <#if ts.locality?has_content>
    <p class="note semi_bottom">${ts.locality}</p>
  </#if>
    <p class="light_note">
      <#assign props2 = {'Type designated by:':'${ts.typeDesignatedBy!""}',
      'Label:':'${ts.verbatimLabel!""}',
      'Event date:':'${ts.verbatimEventDate!""}',
      'Taxon rank:':'${ts.taxonRank!""}',
      'Collector:':'${ts.recordedBy!""}',
      'Latitude:':'${ts.verbatimLatitude!""}',
      'Longitude:':'${ts.verbatimLongitude!""}',
      'Institution code:':'${ts.institutionCode!""}',
      'Collection code:':'${ts.collectionCode!""}',
      'Catalog number:':'${ts.catalogNumber!""}',
      'Occurrence ID:':'${ts.occurrenceId!""}'}>
      <#assign ks=props2?keys>
      <#list ks as k>
        <#if props2[k]?has_content>
          ${k} ${props2[k]} <#if k_has_next> | </#if>
        </#if>
      </#list>
    </p>
</#if>
  </p>
</div>