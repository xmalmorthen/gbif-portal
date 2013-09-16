<#import "/WEB-INF/macros/common.ftl" as common>
<html>
<head>
  <title>Country Summary for ${country.title}</title>
  <link rel="stylesheet" href="<@s.url value='/js/vendor/leaflet/leaflet.css'/>" />
  <!--[if lte IE 8]><link rel="stylesheet" href="<@s.url value='/js/vendor/leaflet/leaflet.ie.css'/>" /><![endif]-->
  <script type="text/javascript" src="<@s.url value='/js/vendor/leaflet/leaflet.js'/>"></script>
  <script type="text/javascript" src="<@s.url value='/js/map.js'/>"></script>
<#include "/WEB-INF/pages/country/inc/feed_templates.ftl">

  <script type="text/javascript">
      $(function() {
          $("#mapAbout").densityMap("${isocode}", "COUNTRY");
          $("#mapBy").densityMap("${isocode}", "PUBLISHING_COUNTRY");

          <#if feed??>
            <@common.googleFeedJs url="${feed}" target="#news" />
          </#if>
      });
  </script>
</head>
<body>

<#assign tab="summary"/>
<#include "/WEB-INF/pages/country/inc/infoband.ftl">


<#include "/WEB-INF/pages/country/inc/about_article.ftl">

<#include "/WEB-INF/pages/country/inc/publishing_article.ftl">

<#include "/WEB-INF/pages/country/inc/participation.ftl">

<#include "/WEB-INF/pages/country/inc/latest_datasets_article.ftl">


</body>
</html>
