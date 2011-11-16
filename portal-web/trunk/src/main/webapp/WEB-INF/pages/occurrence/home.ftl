<html>
<head>
  <title>Occurrences - GBIF</title>
  <meta name="menu" content="occurrences"/>
</head>
<body class="dataset">

  <article class="dataset">
    <header></header>
    <div class="content">
      <h1>Search through +312M occurrences</h1>

      <form action="<@s.url value='/occurrence/search'/>" method="post">
        <span class="input_text">
          <input type="text" name="q" placeholder="Search species, places, data publishers..."/>
        </span>
        <button type="submit" class="search_button"><span>Search</span></button>
      </form>
      <div class="results">
        <ul>
          <li><a href="<@s.url value='/occurrence/search?q=fake'/>" title="">+276M</a>total ocurrences</li>
          <li><a href="<@s.url value='/occurrence/search?q=fake'/>" title="">+98M</a>geolocated</li>
          <li class="last"><a href="<@s.url value='/occurrence/search?q=fake'/>" title="">121,251</a>in last month</li>
        </ul>
      </div>
    </div>
    <footer></footer>
  </article>

</body>
</html>
