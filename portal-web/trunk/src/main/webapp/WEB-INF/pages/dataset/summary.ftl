<div class="header">
  <div class="left"><h2>Summary</h2></div>
</div>

<div class="left">
<#if dataset.description?has_content>
  <h3>Description</h3>

  <p>${dataset.description}</p>
</#if>
  <!-- purpose doesn't exist yet -->
<#--<#if dataset.purpose?has_content>-->
<#--<h3>Purpose</h3>-->
<#--<p>${dataset.purpose}</p>-->
<#--</#if>-->

  <!-- additionalInformation doesn't exist yet -->
<#--<#if dataset.additionalInformation?has_content>-->
<#--<h3>Additional Information</h3>-->
<#--<p>${dataset.additionalInformation}</p>-->
<#--</#if>-->

<#if dataset.temporalCoverages?has_content>

  <#list dataset.temporalCoverages as cov>
    <#if cov.type=="FORMATION_PERIOD" || cov.type = "LIVING_TIME_PERIOD">
      <h3>Verbatim temporal coverage</h3>
      <p>${cov.period!"Missing"}</p>
    </#if>
  <!-- still need SingleDate & DateRange -->
  </#list>
</#if>

<#if dataset.language?has_content>
  <h3>Language</h3>

  <p>${dataset.language.displayLanguage}</p>
</#if>

</div>