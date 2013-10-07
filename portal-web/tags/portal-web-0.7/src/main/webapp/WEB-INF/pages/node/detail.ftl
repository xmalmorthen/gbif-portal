<#import "/WEB-INF/macros/common.ftl" as common>
<html>
<head>
  <title>Node detail of ${node.title}</title>
<#include "/WEB-INF/inc/feed_templates.ftl">
  <script type="text/javascript">
    $(function() {
      <#if feed??>
        <@common.googleFeedJs url="${feed}" target="#news" />
      </#if>
    });
  </script>
</head>
<body class="species">

<#assign tab="info"/>
<#include "/WEB-INF/pages/node/inc/infoband.ftl">

<#include "/WEB-INF/pages/country/inc/participation.ftl">

<#if node.contacts?has_content>
<#assign rtitle><span class="showAllContacts small">show all</span></#assign>
<@common.article id="contacts" title="Contacts" titleRight=rtitle>
    <div class="fullwidth">
      <#if node.contacts?has_content>
        <@common.contactList node.contacts />
      </#if>
    </div>
</@common.article>
</#if>

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
