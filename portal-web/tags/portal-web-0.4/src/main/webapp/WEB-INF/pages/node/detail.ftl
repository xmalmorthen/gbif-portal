<#import "/WEB-INF/macros/common.ftl" as common>
<html>
<head>
  <title>Node detail</title>
  <script type="text/javascript" src="<@s.url value='/js/vendor/feedek/FeedEk.js'/>"></script>
  <script type="text/javascript">
      $(function() {
          $("#mapAbout").densityMap("${id}", "COUNTRY");
          $("#mapBy").densityMap("${id}", "PUBLISHING_COUNTRY");

          <#if feed??>
            $('#news').FeedEk({
                FeedUrl: '${feed}',
                MaxCount: 5,
                ShowDesc: false,
                ShowPubDate: false,
                DescCharacterLimit: 30
            });
          </#if>
      });
  </script>
</head>
<body class="species">

<#assign tab="info"/>
<#include "/WEB-INF/pages/member/inc/infoband.ftl">

<#include "/WEB-INF/pages/country/inc/participation.ftl">

<#include "/WEB-INF/pages/country/inc/endorsing_article.ftl">


<#if feed??>
   <#assign titleRight = "News" />
 <#else>
   <#assign titleRight = "" />
 </#if>
<@common.article id="latest" title="Latest datasets published" titleRight=titleRight>
    <div class="left">
      <#if datasets?has_content>
        <ul class="notes">
          <#list datasets as cw>
            <li>
              <a title="${cw.obj.title}" href="<@s.url value='/dataset/${cw.obj.key}'/>">${common.limit(cw.obj.title, 100)}</a>
              <span class="note">${cw.count} records<#if cw.geoCount gt 0>, ${cw.geoCount} georeferenced</#if></span>
            </li>
          </#list>
        </ul>
      <#else>
        <p>None published.</p>
      </#if>
    </div>

  <#if feed??>
    <div class="right">
        <div id="news"></div>
    </div>
  </#if>
</@common.article>

</body>
</html>
