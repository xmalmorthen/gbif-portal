<#import "/WEB-INF/macros/common.ftl" as common>
<html>
<head>
  <title>${dataset.title} - Dataset detail</title>
  <content tag="extra_scripts">
    <script type="text/javascript" src="<@s.url value='/js/vendor/OpenLayers.js'/>"></script>
    <script type="text/javascript" src="<@s.url value='/js/openlayers_addons.js'/>"></script>
    <script type="text/javascript" src="<@s.url value='/js/Infowindow.js'/>"></script>
    <script type="text/javascript" src="<@s.url value='/js/types_map.js'/>"></script>
  </content>
  <meta name="menu" content="datasets" onunload="GUnload()"/>
</head>
<body onload="initBB()" class="typesmap">

<#assign tab="info"/>
<#include "/WEB-INF/pages/dataset/infoband.ftl">

  <article>
    <header></header>
    <div class="content">

    <#include "/WEB-INF/pages/dataset/summary.ftl">

    <#include "/WEB-INF/pages/dataset/right_sidebar.ftl">

    </div>
    <footer></footer>
  </article>

<#include "/WEB-INF/pages/dataset/endpoints.ftl">

<#include "/WEB-INF/pages/dataset/taxonomic_coverages.ftl">

<#if dataset.type?has_content && dataset.type == "CHECKLIST">
  <article class="taxonomies">
    <header></header>
    <div class="content">
      <h2>Browse Classification</h2>

      <div class="left">
    <#include "/WEB-INF/pages/species/taxbrowser.ftl">
      </div>

      <div class="right">

      </div>

    </div>
    <footer></footer>
  </article>
</#if>

<#if dataset.type?has_content && dataset.type == "OCCURRENCE">
  <#include "/WEB-INF/pages/dataset/occurrences_map.ftl">
</#if>

<#include "/WEB-INF/pages/dataset/geo_coverages.ftl">

<#include "/WEB-INF/pages/dataset/project.ftl">

<#include "/WEB-INF/pages/dataset/methods.ftl">

<#include "/WEB-INF/pages/dataset/data_description.ftl">

<#include "/WEB-INF/pages/dataset/citations.ftl">

<#include "/WEB-INF/pages/dataset/legal.ftl">

</body>
</html>

