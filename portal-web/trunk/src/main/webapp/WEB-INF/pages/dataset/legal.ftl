<article class="mono_line">
  <header></header>
  <div class="content">

    <h2>Dataset usage & legal issues</h2>

    <div class="left">
      <h3>Usage rights</h3>

      <p class="placeholder_temp">This dataset is released under an Open Data licence, so it can be used by anyone who cites it.</p>

      <h3>How to cite it</h3>
      <#assign aDateTime = .now>
      <#assign aDate = aDateTime?date>
      <p>${dataset.title} (accessed through GBIF data portal, <a href="#" title="${dataset.title}">http://data.gbif.org/datasets/${dataset.key}</a>, ${aDate})</p>
    </div>
  </div>
  <footer></footer>
</article>
