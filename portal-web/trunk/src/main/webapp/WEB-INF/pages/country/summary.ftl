<#import "/WEB-INF/macros/common.ftl" as common>
<html>
<head>
  <title>Country Summary for ${country.title}</title>
  <link rel="stylesheet" href="<@s.url value='/js/vendor/leaflet/leaflet.css'/>" />
  <!--[if lte IE 8]><link rel="stylesheet" href="<@s.url value='/js/vendor/leaflet/leaflet.ie.css'/>" /><![endif]-->
  <script type="text/javascript" src="<@s.url value='/js/vendor/leaflet/leaflet.js'/>"></script>
  <script type="text/javascript" src="<@s.url value='/js/map.js'/>"></script>
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
<body>

<#assign tab="summary"/>
<#include "/WEB-INF/pages/country/inc/infoband.ftl">


<#include "/WEB-INF/pages/country/inc/about_article.ftl">

<#include "/WEB-INF/pages/country/inc/publishing_article.ftl">


<@common.article id="participation" title="${country.title} as a GBIF Participant" titleRight="Node Address">
    <div class="left">
      <h3>Member Status</h3>
  <#if node??>
      <p><@s.text name="enum.participantstatus.${node.participationStatus!}"/></p>

      <#if node.participantSince??>
        <h3>GBIF Participant Since</h3>
        <p>${node.participantSince}</p>
      </#if>

      <h3>GBIF Region</h3>
      <p><@s.text name="enum.region.${node.gbifRegion!}"/></p>

      <#if node.contacts?has_content>
        <h3>Contacts</h3>
        <@common.contactList node.contacts />
      </#if>
  <#else>
      <p>None</p>
  </#if>
    </div>

    <div class="right">
      <div class="logo_holder">
        <#if node?? && node.logoURL?has_content>
            <img src="${node.logoURL}"/>
        </#if>
      </div>

      <#if node??>
        <h3>Address</h3>
        <p>${node.organizationName!}</p>
        <@common.address address=node />
      </#if>
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
            <#if cw_index==6>
                <li class="more"><a href="<@s.url value='/dataset/search?hostCountry=${id}'/>">${by.occurrenceDatasets + by.checklistDatasets - 6} more</a></li>
                <#break />
            </#if>
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
