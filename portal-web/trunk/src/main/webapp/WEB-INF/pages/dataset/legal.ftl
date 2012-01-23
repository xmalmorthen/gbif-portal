<article class="mono_line">
  <header></header>
  <div class="content">

    <h2>Dataset usage & legal issues</h2>

    <div class="left">
    <#if dataset.intellectualRights?has_content>
      <h3>Usage rights</h3>

      <p>${dataset.intellectualRights}</p>
    </#if>

      <h3>How to cite it</h3>
    <#assign aDateTime = .now>
    <#assign aDate = aDateTime?date>
      <p>${dataset.title} (accessed through GBIF data portal, <a href="#" title="${dataset.title}">http://data.gbif.org/datasets/${dataset.key}</a>, ${aDate}
        )</p>
    </div>
  </div>
  <footer></footer>
</article>
