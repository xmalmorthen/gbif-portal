<#import "/WEB-INF/macros/pagination.ftl" as macro>
<html>
<head>
  <title>Dataset Search Results - GBIF</title>
  <meta name="menu" content="dataset"/>
</head>

<body class="search">

  <content tag="infoband">
    <h2>Search datasets</h2>

    <form action="<@s.url value='/dataset/search'/>" method="GET">
      <input type="text" name="q"/>
    </form>
  </content>

  <article class="results light_pane">
    <header></header>
    <div class="content">

      <div class="header">
        <div class="left">
          <h2>${searchResponse.count!searchResponse.results?size} results for "${q!}"</h2>
          <a href="#" class="sort" title="Sort by relevance">Sort by relevance <span class="more"></span></a>
        </div>
        <div class="right"><h3>Refine your search</h3></div>
      </div>


      <div class="left">
      <#list searchResponse.results as dataset>
        <div class="result">
          <h2><a href="<@s.url value='/dataset/${dataset.key!}'/>"
                 title="${dataset.title!}"><strong>${dataset.title!}</strong></a>
          </h2>

          <p>A <span class="placeholder_temp">checklist</span> published by
            <a href="<@s.url value='/member/${dataset.owningOrganizationKey!}'/>"
               title="${dataset.owningOrganizationTitle!}">
              <strong>${dataset.owningOrganizationTitle!"Unknown"}</strong></a> at <span
                    class="placeholder_temp">???.</span>
          </p>

          <div class="placeholder_temp footer"><p>201.456 occurrences | covering Europe, Asia, Africa and Oceania</p>
          </div>
        </div>
      </#list>

        <div class="footer">
        <@macro.pagination page=searchResponse url=currentUrl/>
        </div>
      </div>


      <div class="right">

        <div class="refine">
          <h4>DATA PUBLISHER</h4>
          <a href="#">Any data publisher</a>
        </div>

        <div class="refine">
          <h4>DATE OF PUBLICATION</h4>
          <a href="#">Any date</a>
        </div>

        <div class="refine">
          <h4>DATASET TYPE</h4>
          <a href="#" title="Any">Any <span class="more"></span></a>
        </div>

        <div class="refine">
          <h4>TAXA</h4>
          <a href="#" title="All species">All species</a>
        </div>

        <div class="refine">
          <h4>GEOSPATIAL COVERAGE</h4>
          <a href="#">All</a>
        </div>

        <div class="refine">
          <h4>SERVICE TYPE</h4>
          <a href="#" title="Any">Any <span class="more"></span></a>
        </div>
      </div>
    </div>
    <footer></footer>
  </article>

</body>
</html>
