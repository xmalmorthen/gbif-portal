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
            <h4>Method Step ${step_index+1}</h4>
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

          <#if col.curatorialUnits?has_content>
            <h3>Curational units</h3>

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

  </div>
  <footer></footer>
</article>
</#if>

