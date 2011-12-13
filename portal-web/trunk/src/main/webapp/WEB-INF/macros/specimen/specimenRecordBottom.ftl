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
    <#assign props2 = {'Type designation type:':'${ts.typeDesignationType!""}',
    'Type designated by:':'${ts.typeDesignatedBy!""}',
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