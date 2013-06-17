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
<#assign memberType="node"/>
<#include "/WEB-INF/pages/member/inc/infoband.ftl">

<#include "/WEB-INF/pages/country/inc/participation.ftl">

<@common.article id="organizations" title="Endorsed Organizations">
  <div class="fullwidth">
      <ul class="notes">
        <#list page.results as org>
          <li>
            <a href="<@s.url value='/organization/${org.key}'/>">${org.title!"???"}</a>
            <span class="note">An organization
              <#if org.city?? || org.country??>from <@common.cityAndCountry org/></#if>
              <#if (org.numOwnedDatasets > 0)>with ${org.numOwnedDatasets} published datasets</#if>
             </span>
          </li>
        </#list>
        <#if !page.endOfRecords>
          <li class="more">
            <a href="<@s.url value='/node/${member.key}/organizations'/>">more</a>
          </li>
        </#if>
      </ul>
  </div>
</@common.article>

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
