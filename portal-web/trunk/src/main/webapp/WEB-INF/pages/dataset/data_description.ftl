<#if dataset.dataDescriptions?has_content>
<article>
  <header></header>
  <div class="content">
    <h2><a name="data descriptions">Related Data</a></h2>

    <div class="left">

      <#list dataset.dataDescriptions as dd>

        <#if dd.name?has_content>
          <h3>${dd.name}</h3>
        <#else>
          <h3>Data object</h3>
        </#if>

        <#if dd.charset?has_content>
          <h4>Character Set</h4>

          <p>${dd.charset}</p>
        </#if>

        <#if dd.format?has_content>
          <h4>Data Format</h4>

          <p>${dd.format}</p>
        </#if>

        <#if dd.formatVersion?has_content>
          <h4>Data Format Version</h4>

          <p>${dd.formatVersion}</p>
        </#if>

        <#if dd.url?has_content>
          <h4>Download URL</h4>

          <p><a href="${dd.url}">${dd.url}</a></p>
        </#if>

      </#list>
    </div>

  </div>
  <footer></footer>
</article>
</#if>