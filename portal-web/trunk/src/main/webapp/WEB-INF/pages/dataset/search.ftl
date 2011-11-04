<#import "/WEB-INF/macros/pagination.ftl" as macro>
<html>
<head>
  <title>Dataset Search Results - GBIF</title>
  <meta name="menu" content="dataset"/>
</head>

<body class="search">

  <content tag="infoband">
    <h2>Search datasets</h2>

    <form>
      <input type="text" name="q"/>
    </form>
  </content>

  <article class="results light_pane">
    <header></header>
    <div class="content">

      <div class="header">
        <div class="left">
          <h2>${datasets?size} results for "${q!}"</h2>
          <a href="#" class="sort" title="Sort by relevance">Sort by relevance <span class="more"></span></a>
        </div>
        <div class="right"><h3>Refine your search</h3></div>
      </div>


      <div class="left">

	


        <!-- real data -->
        <#list datasets as dataset>
        <div class="result">
          <h2><a href="<@s.url value='/dataset/${dataset.key}'/>" title="${dataset.name!}"><strong>${dataset.name!}</strong></a>
          </h2>

          <p class="placeholder_temp">A checklist published by XXX at 1950.</a>
          </p>

          <div class="footer"><p>${dataset.numUsages} name usages | Checklist type: ${dataset.type}</p></div>
        </div>
        </#list>


        <!-- dynamic -->
      <#--
      <#list datasets as d>
        <div class="result">
          <h2><a href="/dataset/${d.key!}" title="${d.name!"No Title"}"><strong>${d.name!"No Title"}</strong></a></h2>
          <p>A ??? dataset published by <a href="/members/${d.organisationKey!}">Organisation ${d.organisationKey!}</a></p>
          <div class="footer"><p>??? occurrences | covering ???</p></div>
        </div>
      </#list>
      -->

        <div class="footer">
        <@macro.pagination page=page url=currentUrl/>
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
          <h4>TAXA</h4>
          <a href="#" title="All species">All species <span class="more"></span></a>
        </div>

        <div class="refine">
          <h4>GEOSPATIAL COVERAGE</h4>
          <a href="#">World</a>
        </div>

        <a href="#" title="Add another criterion" class="add_criteria">Add another criterion <span
                class="more"></span></a>
      </div>
    </div>
    <footer></footer>
  </article>

</body>
</html>
