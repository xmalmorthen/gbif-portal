<#import "/WEB-INF/macros/common.ftl" as common>
<html>
<head>
  <title>Country News for ${country.title}</title>

  <#include "/WEB-INF/pages/country/inc/feed_templates.ftl">

  <script type="text/javascript">
      $(function() {
        <#if drupalTagId?has_content>
          <@common.drupalFeedJs tagId="${drupalTagId}" target="#gbifnews" />
        </#if>
        <#if feed??>
          <@common.googleFeedJs url="${feed}" target="#nodenews" />
        </#if>
      });
  </script>
  <#--
  copied from newsroom to avoid putting the class newsroom on body which has a lot of unwanted side effects
  TODO: would be good to cleanup our styles and share some across sections based on article classes only, excluding any
        body class rules
    <style type="text/css">
        article.news li {
            list-style: none;
            padding: 20px 0;
            border-bottom: 1px solid #D8DCE1;
            margin-bottom: 0px;
        }
        article.news .date{
          margin: 0 0 7px 0;
          color: #999999;
          font-size: 13px;
          font-family: "DINOT-Regular",sans-serif;
        }
        article.news .title {
            display: block;
            margin: 0 0 5px 0;
            font-weight: bold;
            font-size: 19px;
        }
        article.news p {
            margin: 0 0 5px 0;
        }
        img.rss {
          max-width: 25px;
          position: relative;
          top: 5px;
        }
    </style>
  -->
</head>
<body>

<#assign tab="news"/>
<#include "/WEB-INF/pages/country/inc/infoband.ftl">


<#if drupalTagId?has_content>
  <#assign ltitle>News items tagged ${country.title} <a href="${cfg.drupal}/taxonomy/term/${drupalTagId}/feed"><img class="rss" src="<@s.url value='/img/icons/rss-feed.gif'/>" /></a></#assign>
<#else>
  <#assign ltitle="News items tagged ${country.title}"/>
</#if>

<#if feed??>
  <#assign rtitle>News from node <a href="${feed}"><img class="rss" src="<@s.url value='/img/icons/rss-feed.gif'/>" /></a></#assign>
<#else>
  <#assign rtitle="News from node"/>
</#if>

<@common.article id="news" title=ltitle titleRight=rtitle class="news">
    <div id="gbifnews" class="left">
        <p>There are currently no news items tagged ${country.title}.</p>
    </div>

    <div class="right" id="nodenews">
      <#if feed??>
          <p>No news available in feed.</p>
      <#else>
          <p>No node news feed registered.</p>
      </#if>
    </div>
</@common.article>


</body>
</html>
