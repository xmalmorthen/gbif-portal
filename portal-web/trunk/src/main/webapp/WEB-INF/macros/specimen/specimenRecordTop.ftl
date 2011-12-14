<#-- the scientific name must be present, or nothing gets shown -->
<#if ts.typeStatus?has_content>
${ts.typeStatus?capitalize}
  <#if ts.scientificName?has_content> - ${ts.scientificName}</#if>
</#if>
<@common.usageSource component=ts showChecklistSource=nub />