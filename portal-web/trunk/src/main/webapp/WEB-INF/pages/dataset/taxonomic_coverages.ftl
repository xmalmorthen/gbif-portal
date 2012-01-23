<article>
  <header></header>
  <div class="content">

    <div class="header">
      <div class="left"><h2>Taxonomic Coverage</h2></div>
    </div>

  <#if (dataset.taxonomicCoverages?size>0)>

    <div class="left">

      <#list dataset.taxonomicCoverages as cov>
        <#if cov.description?has_content>
          <h3>Description</h3>

          <p>${cov.description}</p>
        </#if>

        <#assign more=false/>
        <#if cov.coverages?has_content>

          <ul class="three_cols">
            <li>Scientific Name</li>
            <#list cov.coverages as innerCov>
              <li>
                <a href="<@s.url value='/species/search?q=${innerCov.scientificName!""}'/>">${innerCov.scientificName!""}
                  <a/></li>
              <#if innerCov_index==8>
                <#assign more=true/>
                <#break />
              </#if>
            </#list>
          </ul>
          <ul class="three_cols">
            <li>Common Name</li>
            <#list cov.coverages as innerCov>
              <li><a href="<@s.url value='/species/search?q=${innerCov.commonName!""}'/>">${innerCov.commonName!"N/A"}
                <a/></li>
              <#if innerCov_index==8>
                <#break />
              </#if>
            </#list>
          </ul>
          <!-- Rank isn't being populated, but when it does it should be shown, and link out to the nub -->
          <ul class="three_cols">
            <li>Rank</li>
            <#list cov.coverages as innerCov>
              <li class="placeholder_temp"><a href="<@s.url value='/species/42/name_usage'/>">N/A<a/></li>
              <#if innerCov_index==8>
                <#break />
              </#if>
            </#list>
          </ul>

          <#if more>
            <p><span>The complete list has ${cov.coverages?size} elements.</span><a href="#" class="download"
                                                                                    title="Download all the elments">
              &nbsp;Download them all</a>.</p>
          </#if>
        </#if>

      </#list>

    </div>

  </#if>

    <div class="right">
      <h3>Coverage</h3>

      <p class="placeholder_temp">Animalia</p>

      <h3>Second level data elements</h3>
      <ul>
        <li class="number placeholder_temp">References <span>123</span></li>
        <li class="number placeholder_temp">Common names <span>456</span></li>
        <li class="number placeholder_temp">Specimens <span>152</span></li>
      </ul>
    </div>
  </div>
  <footer></footer>
</article>