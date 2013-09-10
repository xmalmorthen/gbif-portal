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

  <#assign title>
  ${page.count!} results <#if q?has_content>for &quot;${q}&quot;</#if>
  </#assign>
  <@common.article class="results" title=title>
    <div class="fullwidth">
    <#assign max_show_length = 68>
    <#list page.results as pub>
        <div class="result">
          <#if pub.logoUrl?has_content>
            <div class="logo_holder">
              <img src="<@s.url value='${pub.logoUrl}'/>"/>
            </div>
          </#if>

          <h2>
            <a href="<@s.url value='/publisher/${pub.key}'/>" title="${pub.title!}">${pub.title!}</a>
          </h2>

          <p>A data publisher
            <#if pub.city?? || pub.country??>from <@common.cityAndCountry pub/></#if>
            <#if (pub.numOwnedDatasets > 0)>with ${pub.numOwnedDatasets} published datasets</#if>
          </p>

          <div class="footer">
              <p>Endorsed by <a href="<@s.url value='/node/${pub.endorsingNodeKey}'/>">${(nodeIndex.get(pub.endorsingNodeKey).title)!""}</a></p>
          </div>
        </div>
    </#list>

      <div class="footer">
        <@macro.pagination page=page url=currentUrlWithoutPage />
      </div>
    </div>

  </@common.article>

</body>
</html>