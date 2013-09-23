<#import "/WEB-INF/macros/common.ftl" as common>
<#import "/WEB-INF/macros/feeds.ftl" as feeds>
<html>
<head>
  <title>Publications relevant to ${country.title}</title>

  <#include "/WEB-INF/inc/feed_templates.ftl">

  <script type="text/javascript">
      $(function() {
        <@feeds.mendeleyFeedJs isoCode="${isocode}" target="#pubcontent" />
      });
  </script>
</head>
<body>

<#assign tab="publications"/>
<#include "/WEB-INF/pages/country/inc/infoband.ftl">


<@common.article id="publications" title="GBIF Public Library articles tagged with ${country.title}" titleRight=rtitle class="results">
    <div id="pubcontent" class="fullwidth">
        <p>There are currently no publications in <a href="http://www.mendeley.com/groups/1068301/gbif-public-library/">Mendeley</a> tagged with ${country.title}.</p>
    </div>
</@common.article>


</body>
</html>
