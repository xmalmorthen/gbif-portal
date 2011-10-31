<html>
<head>
  <title>Species Search Results for ${q!}</title>
  <meta name="menu" content="species"/>
  <link rel="stylesheet" href="<@s.url value='/css/jquery.multiselect.css'/>"/>
</head>
<#import "../macros/pagination.ftl" as macro>
<body class="search">
  <content tag="infoband">
    <h2>Search species</h2>
    <form action="<@s.url value='/species/search'/>">
      <input type="text" name="q"/>
    </form>
  </content>

  <form action="<@s.url value='/species/search'/>">
  <article class="results light_pane">
    <input type="hidden" name="q" value="${q!}"/>
    <header></header>
    <div class="content">
      <div class="header">
        <div class="left">
          <h2>${count!} results for "${q!}"</h2>
          <a href="#" class="sort" title="Sort by relevance">Sort by relevance <span class="more"></span></a>
        </div>
        <div class="right"><h3>Refine your search</h3></div>
      </div>

      <div class="left">

      <#list searchResponse.results as u>
        <div class="result">
          <h2><a href="<@s.url value='/species/${u.key?c}'/>" title="${u.scientificName}"><strong>${u.scientificName}</strong> ${u.rank!}
          </a></h2>
          <p>according to ${u.checklistKey!"???"}</p>
          <div class="footer">
            <ul class="taxonomy">
            <#assign classification=u.higherClassificationMap />
            <#list classification?keys as usageKey>
              <li <#if !usageKey_has_next>class="last"</#if>><a href="<@s.url value='/species/${usageKey}'/>">${classification.get(usageKey)}</a></li>
            </#list>
            </ul>
          </div>
        </div>
      </#list>

        <div class="footer">
          <@macro.pagination offset=searchResponse.offset limit=searchResponse.limit totalResults=searchResponse.count url=currentUrl/>
        </div>
      </div>
      <div class="right">

        <div class="refine">
          <h4>Higher taxon</h4>
          <a href="#" title="Any taxon">Any</a>
        </div>
        <div class="refine">
          <h4>Taxonomic rank</h4>
          <div class="facet">
          <#if facetCounts['RANK']?has_content>
            <select id="RANK_FACET" name="facets['RANK']" style="width:190px;" multiple>
              <#list facetCounts['RANK'] as count>
                <option value="${count.name}">${count.name}-(${count.count})</option>
              </#list>
            </select>
          </#if>
          </div>
        </div>

        <div class="refine">
          <h4>Checklist</h4>

          <div class="facet">
          <#if facetCounts['CHECKLIST']?has_content>
            <select id="CHECKLIST_FACET" name="facets['CHECKLIST']" style="width:190px;" multiple>
              <#list facetCounts['CHECKLIST'] as count>
                <option value="${count.name}">${count.name}-(${count.count})</option>
              </#list>
            </select>
          </#if>
          </div>
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

        <div class="refine">
          <button>Search</button>
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
  </form>
  <content tag="extra_scripts">
    <script type="text/javascript" src="<@s.url value='/js/vendor/jquery.multiselect.min.js'/>">
    </script>
    <script type="text/javascript" src="<@s.url value='/js/facets.js'/>">
    </script>
  </content>
</body>
</html>
