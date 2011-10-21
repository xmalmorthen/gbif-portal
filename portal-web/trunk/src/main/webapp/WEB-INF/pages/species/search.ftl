<html>
<head>
  <title>Species Search Results for ${q!}</title>
  <meta name="menu" content="species"/>
</head>
<body class="search">
  <content tag="infoband">
    <h2>Search species</h2>

    <form action="<@s.url value='/species/search'/>">
      <input type="text" name="q"/>
    </form>
  </content>

  <article class="results light_pane">
    <header></header>
    <div class="content">

      <div class="header">
        <div class="left">
          <h2>${(usages.size())!} results for "${q!}"</h2>
          <a href="#" class="sort" title="Sort by relevance">Sort by relevance <span class="more"></span></a>
        </div>
        <div class="right"><h3>Refine your search</h3></div>
      </div>

      <div class="left">

      <#list usages as u>
        <div class="result">
          <h2><a href="<@s.url value='/species/${u.key?c}'/>" title="${u.scientificName}"><strong>${u.scientificName}</strong> ${u.rank!}
          </a></h2>

          <div class="footer">
            <ul class="taxonomy">
              <li>${u.kingdom!"-"}</li>
              <li>${u.phylum!"-"}</li>
              <li>${u.clazz!"-"}</li>
              <li>${u.order!"-"}</li>
              <li>${u.family!"-"}</li>
              <li class="last">${u.genus!}</li>
            </ul>
          </div>
        </div>
      </#list>

        <div class="footer">
          <a href="#" class="candy_white_button previous"><span>Previous page</span></a>
          <a href="#" class="candy_white_button next"><span>Next page</span></a>

          <div class="pagination">viewing page 2 of 31</div>
        </div>
      </div>
      <div class="right">

        <div class="refine">
          <h4>Parent taxa</h4>
          <a href="#" title="Any taxa">Any</a>
        </div>
        <div class="refine">
          <h4>Taxonomic rank</h4>
          <a href="#" title="Any">Any<span class="more"></span></a>
        </div>

        <div class="refine">
          <h4>Checklist</h4>
          <#list checkListsFacetCounts as count>
            <a href="#" title="${count.name}">${count.name}-(${count.count}) <span class="more"></span></a>
          </#list>
        </div>

        <div class="refine">
          <h4>Status</h4>
          <a href="#" title="Any">Any<span class="more"></span></a>
        </div>

        <div class="refine">
          <h4>Extinction status</h4>
          <a href="#" title="Any">Any<span class="more"></span></a>
        </div>

        <div class="refine">
          <h4>Habitat</h4>
          <a href="#" title="Any">Any<span class="more"></span></a>
        </div>

        <a href="#" title="Add another criterion" class="add_criteria">Add another criterion <span class="more"></span></a>

        <div class="download">
          <div class="dropdown">
            <a href="#" class="title" title="Download list"><span>Download list</span></a>
            <ul>
              <li><a href="#a"><span>Download list</span></a></li>
              <li><a href="#b"><span>Download metadata</span></a></li>
              <li class="last"><a href="#b"><span>Download metadata</span></a></li>
            </ul>
          </div>
        </div>

      </div>
    </div>
    <footer></footer>
  </article>
</body>
</html>
