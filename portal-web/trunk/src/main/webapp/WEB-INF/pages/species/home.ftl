<html>
<head>
  <title>Species Search</title>

  <content tag="extra_scripts">
    <script type="text/javascript" src="<@s.url value='/js/vendor/jquery-ui-1.8.17.min.js'/>"></script>
    <script type="text/javascript" src="<@s.url value='/js/species_autocomplete.js'/>"></script>
    <script>
      $("#q").speciesAutosuggest(cfg.wsClbSuggest,4,null,"#content","canonicalName","checklistTitle");
  </script>
</content>
</head>

<body class="dataset">

  <article class="dataset">
    <header></header>
    <div class="content">
      <h1>Search through ${nubMetrics.countIndexed} records</h1>
      <p>of the <a href="<@s.url value='/dataset/${nubDatasetKey}'/>">GBIF Backbone Taxonomy</a></p>

      <form action="<@s.url value='/species/search'/>" method="GET">
        <span class="input_text">
         <input id="q" type="text" value="" name="q"/>
        </span>
        <button id="submitSearch" type="submit" class="search_button"><span>Search</span></button>
        <input id="checklist" name="checklist" type="hidden" value="nub"/>
      </form>
      <div class="example">
</div>
      <ul class="species">
        <li><a href="<@s.url value='/species/search?q=&checklist=nub&highertaxon=359'/>" title="Mammals">Mammals</a></li>
        <li><a href="<@s.url value='/species/search?q=&checklist=nub&highertaxon=212'/>" title="Birds">Birds</a></li>
        <li><a href="<@s.url value='/species/search?q=&checklist=nub&highertaxon=216'/>" title="Insects">Insects</a></li>
        <li><a href="<@s.url value='/species/search?q=&checklist=nub&highertaxon=358'/>" title="Reptiles">Reptiles</a></li>
        <#--
         see http://en.wikipedia.org/wiki/Fish#Taxonomy
         MISSING FROM THESE FISH FILTERS ARE THE FOLLOWING, WHICH ARE NOT IN COL:
          - Placodermi

        -->
        <li><a href="<@s.url value='/species/search?q=&checklist=nub&highertaxon=119&highertaxon=120&highertaxon=121&highertaxon=204&highertaxon=238&highertaxon=239&highertaxon=4853178&highertaxon=3238258&highertaxon=4836892&highertaxon=4815623'/>" title="Fishes">Fishes</a></li>
        <li><a href="<@s.url value='/species/search?q=&checklist=nub&highertaxon=797'/>" title="Butterflies">Butterflies</a></li>
        <li><a href="<@s.url value='/species/search?q=&checklist=nub&highertaxon=5'/>" title="Lizards">Fungi</a></li>
        <li><a href="<@s.url value='/species/search?q=&checklist=nub&highertaxon=49'/>" title="Lizards">Flowering Plants</a></li>
      </ul>
      <div class="results">
        <ul>
          <li><a href="<@s.url value='/species/search?checklist=nub&rank=species'/>" title="">${numSpecies!0}</a>total species</li>
          <li><a href="<@s.url value='/species/search?checklist=nub&rank=infraspecific_name&rank=subspecies&rank=infrasubspecific_name&rank=variety&rank=subvariety&rank=form&rank=subform&rank=cultivar_group&rank=cultivar'/>" title="">${numInfraSpecies!0}</a>total infraspecific</li>
          <li class="last"><a href="<@s.url value='/species/search?checklist=nub'/>">${numCommonNames!0}</a>common names in ${numLanguages!0} languages</li>
        </ul>
      </div>
    </div>
    <footer></footer>
  </article>

  <p class="advice">Looking for something more specific? Use our <a href="#" title="advance filtering">advanced
    filtering</a> or the <a href="#" title="taxonomic browser">taxonomic browser</a>.
  </p>

</body>
</html>
