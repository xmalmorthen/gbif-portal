<html>
<head>
  <title>Species Search</title>
</head>

<body class="dataset">

  <article class="dataset">
    <header></header>
    <div class="content">
      <h1>
          Search ${colSpecies} species
      </h1>
      <p>of the <a href="<@s.url value='/dataset/${nubDatasetKey}'/>">GBIF Backbone Taxonomy</a>
          <br/>${nubMetrics.countSynonyms} synonyms and
          <br/> ${nubSpecies-colSpecies} species under review</p>

      <form action="<@s.url value='/species/search'/>" method="GET">
        <span class="input_text">
         <input id="q" type="text" value="" name="q" placeholder="Scientific or common name, descriptions..."/>
        </span>
        <button id="submitSearch" type="submit" class="search_button"><span>Search</span></button>
        <input id="checklist" name="dataset_key" type="hidden" value="${nubDatasetKey}"/>
      </form>
      <div class="example">
</div>
      <ul class="species">
        <li><a href="<@s.url value='/species/search?q=&dataset_key=${nubDatasetKey}&highertaxon_key=359'/>" title="Mammals">Mammals</a></li>
        <li><a href="<@s.url value='/species/search?q=&dataset_key=${nubDatasetKey}&highertaxon_key=212'/>" title="Birds">Birds</a></li>
        <li><a href="<@s.url value='/species/search?q=&dataset_key=${nubDatasetKey}&highertaxon_key=216'/>" title="Insects">Insects</a></li>
        <li><a href="<@s.url value='/species/search?q=&dataset_key=${nubDatasetKey}&highertaxon_key=358'/>" title="Reptiles">Reptiles</a></li>
        <#--
         see http://en.wikipedia.org/wiki/Fish#Taxonomy
         MISSING FROM THESE FISH FILTERS ARE THE FOLLOWING, WHICH ARE NOT IN COL:
          - Placodermi
        -->
        <li><a href="<@s.url value='/species/search?q=&dataset_key=${nubDatasetKey}&highertaxon_key=119&highertaxon_key=120&highertaxon_key=121&highertaxon_key=204&highertaxon_key=238&highertaxon_key=239&highertaxon_key=4853178&highertaxon_key=3238258&highertaxon_key=4836892&highertaxon_key=4815623'/>" title="Fishes">Fishes</a></li>
        <li><a href="<@s.url value='/species/search?q=&dataset_key=${nubDatasetKey}&highertaxon_key=797'/>" title="Butterflies">Butterflies</a></li>
        <li><a href="<@s.url value='/species/search?q=&dataset_key=${nubDatasetKey}&highertaxon_key=5'/>" title="Lizards">Fungi</a></li>
        <li><a href="<@s.url value='/species/search?q=&dataset_key=${nubDatasetKey}&highertaxon_key=49'/>" title="Lizards">Flowering Plants</a></li>
      </ul>
      <div class="results">
        <ul>
          <li><a href="<@s.url value='/species/search?dataset_key=${nubDatasetKey}&rank=species'/>" title="">${nubSpecies!0}</a>total species</li>
          <li><a href="<@s.url value='/species/search?dataset_key=${nubDatasetKey}&rank=infraspecific_name&rank=subspecies&rank=infrasubspecific_name&rank=variety&rank=subvariety&rank=form&rank=subform&rank=cultivar_group&rank=cultivar'/>" title="">${nubInfraSpecies!0}</a>total infraspecific</li>
          <li class="last"><a href="<@s.url value='/species/search?q=golden+eagle&dataset_key=${nubDatasetKey}'/>">${nubCommonNames!0}</a>common names in ${nubLanguages!"?"} languages</li>
        </ul>
      </div>
    </div>
    <footer></footer>
  </article>

</body>
</html>
