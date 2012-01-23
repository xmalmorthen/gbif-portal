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
    </#if>
  </#list>
  </ul>
  <#if more>
    <p><span>The complete list has ${cov.coverages?size} elements.</span><a href="#" class="download" title="Download all the elments">&nbsp;Download them all</a>.</p>
  </#if>
</#if>

  </div>





    <div class="right">
      <h3>Statistics</h3>
      <ul>
        <li>Species <span class="number placeholder_temp">53.212</span></li>
        <li>Genera <span class="number placeholder_temp">2.134</span></li>
        <li>Families <span class="number placeholder_temp">45</span></li>
        <li>Plants <span class="number placeholder_temp">33.111</span></li>
        <li>Animals <span class="number placeholder_temp">0</span></li>
        <li>Fungi <span class="number placeholder_temp">20.052</span></li>
        <li>Bacteria <span class="number placeholder_temp">12</span></li>
        <li>Other <span class="number placeholder_temp">115</span></li>
      </ul>
      <!--
      <h3>Associated Data</h3>
      <ul>
        <li>Common names <span class="number placeholder_temp">5</span></li>
        <li>Descriptions <span class="number placeholder_temp">2</span></li>
        <li>Distributions <span class="number placeholder_temp">456</span></li>
        <li>Images <span class="number placeholder_temp">3</span></li>
        <li>Identifier <span class="number placeholder_temp">2</span></li>
        <li>References <span class="number placeholder_temp">12</span></li>
        <li>Species Profiles <span class="number placeholder_temp">1</span></li>
        <li>TypeSpecimen <span class="number placeholder_temp">15</span></li>
      </ul>
      -->
    </div>
  </div>
  <footer></footer>
</article>