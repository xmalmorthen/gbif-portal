<#import "/WEB-INF/macros/common.ftl" as common>
<#import "/WEB-INF/macros/records.ftl" as records>
<#import "/WEB-INF/macros/occ_metrics.ftl" as metrics>
<html>
<head>
  <title>Data About ${country.title}</title>
    <link rel="stylesheet" href="<@s.url value='/css/bootstrap-tables.css'/>" type="text/css" media="all"/>
    <link rel="stylesheet" href="<@s.url value='/js/vendor/leaflet/leaflet.css'/>" />
    <!--[if lte IE 8]><link rel="stylesheet" href="<@s.url value='/js/vendor/leaflet/leaflet.ie.css'/>" /><![endif]-->
    <script type="text/javascript" src="<@s.url value='/js/vendor/leaflet/leaflet.js'/>"></script>
    <script type="text/javascript" src="<@s.url value='/js/map.js'/>"></script>
    <script type="text/javascript" src="<@s.url value='/js/occ_metrics.js'/>"></script>
    <script type="text/javascript">
        $(function() {
            $("#mapAbout").densityMap("${id}", "COUNTRY");
        });
    </script>
</head>
<body>

<#assign tab="about"/>
<#include "/WEB-INF/pages/country/inc/infoband.ftl">

<#include "/WEB-INF/pages/country/inc/about_article.ftl">

<@common.article id="datasets" title="Datasets about ${country.title}">
  <div class="fullwidth">
    <#list datasets as d>
      <@records.dataset dataset=d/>
    </#list>
  </div>
</@common.article>

<@common.article id="countries" title="Countries, territories or islands publishing occurrences about ${country.title}">
  <div class="fullwidth">
    <#list datasets as d>
      <@records.dataset dataset=d/>
    </#list>
  </div>
</@common.article>

<@common.article id="metrics" title="Occurrences located in ${country.title}">
    <div class="fullwidth">
      <p>
      <@metrics.metricsTable baseAddress="country=${country}"/>
		</p>
      <p>
        <em>Note</em>: The numbers in brackets represent records that are georeferenced (i.e. with coordinates).
      </p>
    </div>
</@common.article>


<@common.article id="trends" title="Trends in publishing about ${country.title}">
</@common.article>

</body>
</html>
