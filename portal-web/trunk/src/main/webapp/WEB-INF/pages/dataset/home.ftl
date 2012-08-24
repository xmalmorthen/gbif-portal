<html>
  <head>
    <title>Dataset - GBIF</title>
    <meta name="gmap" content="true"/>

  </head>
  <body class="dataset">

    <article class="dataset">
    <header></header>
    <div class="content">
      <h1>Search through 21.392 datasets</h1>

      <form action="<@s.url value='/dataset/search'/>" method="GET">
        <span class="input_text">
          <input type="text" name="q" placeholder="Search species, places, data publishers..." class="focus"/>
        </span>
        <button type="submit" class="search_button"><span>Search</span></button>
      </form>
      <div class="results">
        <ul>
          <li><a href="<@s.url value='/dataset/search?q=&type=OCCURRENCE'/>">18.392</a>occurrences dataset</li>
          <li><a href="<@s.url value='/dataset/search?q=&type=CHECKLIST'/>">2.841</a>checklists</li>
          <li class="last"><a href="<@s.url value='/dataset/search?q=&registered=false'/>">1.251</a>external datasets</li>
        </ul>
      </div>
    </div>
    <footer></footer>
    </article>

  </body>
</html>
