<#if ts.citation?has_content>
  <p class="note semi_bottom">${ts.citation}</p>
<#else>
  <#if ts.locality?has_content>
    <p class="note semi_bottom">${ts.locality}</p>
  </#if>
  <p class="light_note">
    <#assign props2 = {'Designation type:':'${ts.typeDesignationType!""}',
    'Designated by:':'${ts.typeDesignatedBy!""}',
    'Label:':'${ts.verbatimLabel!""}',
    'Collection date:':'${ts.verbatimEventDate!""}',
    'Collector:':'${ts.recordedBy!""}',
    'Latitude:':'${ts.verbatimLatitude!""}',
    'Longitude:':'${ts.verbatimLongitude!""}',
    'Institution code:':'${ts.institutionCode!""}',
    'Collection code:':'${ts.collectionCode!""}',
    'Catalog number:':'${ts.catalogNumber!""}',
    'Occurrence ID:':'${ts.occurrenceId!""}'}>
    <#list props2?keys as k>
      <#if props2[k]?has_content>
      ${k} ${props2[k]} <#if k_has_next> | </#if>
      </#if>
    </#list>
  </p>
</#if>