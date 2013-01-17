<html>
  <head>
    <title>Dataset - GBIF</title>
    <content tag="extra_scripts">
      <script type="text/javascript" src="<@s.url value='/js/vendor/jquery-ui-1.8.17.min.js'/>"></script>
      <script type="text/javascript" src="<@s.url value='/js/dataset_autocomplete.js'/>"></script>
      <script>
        $("#q").datasetAutosuggest(cfg.wsRegSuggest, 6,"#content");
      </script>
    </content>
  </head>
  <body class="dataset">

    <article class="dataset">
    <header></header>
    <div class="content">
      <h1>Search ${numDatasets} datasets</h1>

      <form action="<@s.url value='/dataset/search'/>" method="GET">
        <span class="input_text">
          <input type="text" value="" name="q" id="q" placeholder="Search title, description, publisher..." class="focus"/>
        </span>
        <button type="submit" class="search_button"><span>Search</span></button>
      </form>
      <div class="results">
        <ul>
          <li><a href="<@s.url value='/dataset/search?type=OCCURRENCE'/>">${numOccurrenceDatasets}</a>occurrences datasets</li>
          <li><a href="<@s.url value='/dataset/search?type=CHECKLIST'/>">${numChecklistDatasets}</a>checklists</li>
          <li class="last"><a href="<@s.url value='/dataset/search?type=METADATA'/>">${numMetadataDatasets}</a>external datasets</li>
        </ul>
      </div>
    </div>
    <footer></footer>
    </article>

  </body>
</html>
