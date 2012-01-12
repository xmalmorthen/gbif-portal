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
    <!-- still need SingleDate & DateRange -->
  </#list>
</#if>

<#if dataset.language?has_content>
  <h3>Language</h3>

  <p>${dataset.language.displayLanguage}</p>
</#if>

</div>