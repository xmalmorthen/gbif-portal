<html>
  <head>
    <title>Dataset - GBIF</title>
    <meta name="gmap" content="true"/>

    <content tag="extra_scripts">
      <script type="text/javascript" src="<@s.url value='/js/vendor/jquery-ui-1.8.17.min.js'/>"></script>
      <script type="text/javascript" src="<@s.url value='/js/dataset_autocomplete.js'/>"></script>
      <script>
        $("#q").datasetAutosuggest(cfg.wsRegSuggest,4,"#content");
      </script>
    </content>
  </head>
  <body class="dataset">

    <article class="dataset">
    <header></header>
    <div class="content">
      <h1>Search through ${numDatasets} datasets</h1>

      <form action="<@s.url value='/dataset/search'/>" method="GET">
        <span class="input_text">
          <input type="text" value="" name="q" id="q" placeholder="Search species, places, data publishers..." class="focus"/>
        </span>
        <button type="submit" class="search_button"><span>Search</span></button>
      </form>
      <div class="results">
        <ul>
          <li><a href="<@s.url value='/dataset/search?q=&type=OCCURRENCE'/>">${numOccurrenceDatasets}</a>occurrences dataset</li>
          <li><a href="<@s.url value='/dataset/search?q=&type=CHECKLIST'/>">${numChecklistDatasets}</a>checklists</li>
          <li class="last"><a href="<@s.url value='/dataset/search?q=&registered=false'/>">${numMetadataDatasets}</a>external datasets</li>
        </ul>
      </div>
    </div>
    <footer></footer>
    </article>

  </body>
</html>
