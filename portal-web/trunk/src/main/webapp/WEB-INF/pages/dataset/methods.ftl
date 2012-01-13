<#if dataset.samplingDescription?has_content>
<article>
  <header></header>
  <div class="content">
    <h2>Methodolgy</h2>

    <div class="left">

      <#if dataset.samplingDescription.studyExtent?has_content>
        <h3>Study extent</h3>

        <p>${dataset.samplingDescription.studyExtent!}</p>
      </#if>

      <#if dataset.samplingDescription.studyExtent?has_content>
        <h3>Sampling description</h3>

        <p>${dataset.samplingDescription.sampling!}</p>
      </#if>

      <#if dataset.samplingDescription.studyExtent?has_content>
        <h3>Quality control</h3>

        <p>${dataset.samplingDescription.qualityControl!}</p>
      </#if>

      <#if dataset.samplingDescription.methodSteps?has_content>
        <h3>Method Steps</h3>
        <ul>
          <#list dataset.samplingDescription.methodSteps as step>
            <h4>Method Step ${step_index}</h4>
            <#if step.title?has_content>
              <li>Title: ${step.title!""}</li>
            </#if>
            <#if step.description?has_content>
              <li>Description: ${step.description!""}</li>
            </#if>
            <#if step.instrumentation?has_content>
              <li>Instrumentation: ${step.instrumentation!""}</li>
            </#if>
          </#list>
        </ul>
      </#if>
    </div>

    <div class="right">
      <h3>Collection name</h3>

      <p class="placeholder_temp">Ave specimens (AVES123)</p>

      <h3>Parent identifier</h3>

      <p class="placeholder_temp">AVES</p>

      <h3>Preservation method</h3>

      <p class="placeholder_temp">Glycerin</p>

      <#if dataset.curatorialUnits?has_content>
        <h3>Curational units</h3>

        <ul>
          <#list dataset.curatorialUnits as unit>
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
    </div>

  </div>
  <footer></footer>
</article>
</#if>

