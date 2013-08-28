<#import "/WEB-INF/macros/common.ftl" as common>
<#import "/WEB-INF/macros/pagination.ftl" as macro>
<html>
<head>
  <title>Publisher search</title>
  <content tag="extra_scripts"></content>
</head>
<body class="search">
  <content tag="infoband">
    <h2>Search GBIF data publishers</h2>

    <form action="<@s.url value='/publisher/search'/>" method="GET" id="formSearch" >
      <input id="q" type="text" name="q" value="${q!}" autocomplete="off" placeholder="Search publisher title, country, by contact email etc..."/></br>
      <br/>
      <#-- Remove this when implemented -->
      <span style="color:#FFF">
        <em>Note:</em> Results show most recently modified publishers first.  Future versions will be alphabetically sorted
      </span>
    </form>
  </content>



  <#-- borrowing the styling from the occurrence search results here, since no facets exist -->
  <article class="ocurrence_results">
    <header></header>
    <div class="content" id="content">
      <table class="results">
        <tr class="header">
          <td class="summary" colspan="3">
            <h2>${page.count!} results <#if q?has_content>for &quot;${q}&quot;</#if></h2>
          </td>
        </tr>
        <tr class="results-header">
          <td><h4>Publisher title</h4></td>
          <td><h4>Endorsing node</h4></td>
          <td><h4>Location</h4></td>
        </tr>
        <#list page.results as p>
          <tr class="result">
            <td><a href="<@s.url value='/publisher/${p.key}'/>">${p.title!""}</a></td>
            <td><a href="<@s.url value='/node/${p.endorsingNodeKey}'/>">${(nodeIndex.get(p.endorsingNodeKey).title)!""}</a></td>
            <td>${(p.country.title)!""}</td>
          </tr>
        </#list>
      </table>
      <div class="footer">
        <@macro.pagination page=page url=currentUrlWithoutPage maxOffset=100000/>
      </div>
    </div>
  </article>
  <div class="infowindow" id="waitDialog">
    <div class="light_box">
      <div class="content">
        <h3>Processing request</h3>

        <div>Wait while your request is processed...
          <img src="<@s.url value='/img/ajax-loader.gif'/>" alt=""/>
        </div>
      </div>
    </div>
  </div>
</body>
</html>