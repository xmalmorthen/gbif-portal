<article>
  <header></header>
  <div class="content">

    <div class="header">
      <div class="left"><h2>Taxonomic Coverage</h2></div>
    </div>


    <div class="left">
<#if (dataset.taxonomicCoverages?size>0)>
  <#-- descriptions -->
  <#list dataset.taxonomicCoverages as cov>
    <#if cov.description?has_content>
      <p>${cov.description}</p>
    </#if>
  </#list>
  <#-- keywords -->
  <#assign more=false/>
  <ul class="three_cols">
  <#list dataset.taxonomicCoverages as cov>
    <#if more>
      <#break />
    </#if>
    <#if cov.coverages?has_content>
      <#list cov.coverages as innerCov>
        <#if (innerCov.scientificName?has_content || innerCov.commonName?has_content)>
          <li>
            <a href="<@s.url value='/species/search?q=${innerCov.scientificName!innerCov.commonName}'/>">
              <#if innerCov.scientificName?has_content>
                ${innerCov.scientificName} <#if innerCov.commonName?has_content>(${innerCov.commonName})</#if>
              <#else>
                ${innerCov.commonName}
              </#if>
            <a/>
          </li>
        </#if>
        <#if innerCov_index==8>
          <#assign more=true/>
          <#break />
        </#if>
      </#list>
      <#if more>
        <p><span>The complete list has ${cov.coverages?size} elements.</span></p>
      </#if>
    </#if>
  </#list>
  <p><a href="#" class="download" title="Download all the elments">&nbsp;Download them all</a>.</p>
  </ul>

</#if>

  </div>




    <div class="right">
      <h3>Statistics</h3>
      <ul>
        <li>Species <span class="number">${(checklist.numSpecies)!"?"}</span></li>
        <li>Genera <span class="number">${(checklist.numGenera)!"?"}</span></li>
        <li>Families <span class="number">${(checklist.numFamilies)!"?"}</span></li>
        <!--
          <li>Plants <span class="number">33.111</span></li>
          <li>Animals <span class="number">0</span></li>
          <li>Fungi <span class="number">20.052</span></li>
          <li>Bacteria <span class="number">12</span></li>
          <li>Other <span class="number placeholder_temp">115</span></li>
        -->
      </ul>
      <#if checklist??>
        <h3>Associated Data</h3>
        <ul>
          <li>Common names <span class="number">${checklist.numVernacularNames}</span></li>
          <li>Descriptions <span class="number">${checklist.numDescriptions}</span></li>
          <li>Distributions <span class="number">${checklist.numDistributions}</span></li>
          <li>Images <span class="number">${checklist.numImages}</span></li>
          <li>References <span class="number">${checklist.numReferences}</span></li>
          <li>Species Profiles <span class="number">${checklist.numSpeciesProfiles}</span></li>
          <li>TypeSpecimen <span class="number">${checklist.numTypes}</span></li>
        </ul>
      </#if>
    </div>
  </div>
  <footer></footer>
</article>