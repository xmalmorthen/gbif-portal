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
    <style type="text/css">
        <#-- to be moved into LESS -->
        article.nohead .content > div {
          border-top-width: 0px !important;
          padding-top: 0px !important;
        }


        div.publication {
          padding-top: 5px ;
          border-bottom: 1px solid #F1F1F1;
          padding-bottom: 0px ;
          margin-bottom: 25px ;
        }
        .publication h2 {
          font-size: 21px !important;
          margin-bottom: 10px !important;
        }
        .publication .journal {
          padding-left: 40px ;
          text-indent: -20px ;
          margin-bottom: 10px ;
        }
        .publication p {
          margin-bottom: 10px !important;
        }
        .publication span.author{
          margin-right: 5px ;
        }
        .publication span.author:after{
          content: ",";
        }
        .publication span.author:last-of-type:after{
          content: "";
        }
        .publication p.journal span.volume:before{
          content: ", ";
        }
        .publication p.journal span.issue:before{
          content: " (";
        }
        .publication p.journal span.issue:after{
          content: ")";
        }
        .publication p.journal span.pages:before{
          content: ", ";
        }
        .publication p.journal span.pages:after{
          content: ".";
        }
        ul.keywords li{
          display: inline;
          list-style-type: none;
          padding-right: 1px;
          text-transform: lowercase;
          font-size: 0.8em;
          color: #999;
        }
        ul.keywords li:after{
          content: ",";
        }
    </style>
</head>
<body>

<#assign tab="publications"/>
<#include "/WEB-INF/pages/country/inc/infoband.ftl">


<@common.article id="publications" title="Uses of GBIF in scientific research">
    <div class="fullwidth">
      <p>
        Peer-reviewed research citing GBIF as a data source, with at least one author from ${country.title}.<br/>
        Extracted from the <a href="http://www.mendeley.com/groups/1068301/gbif-public-library/">Mendeley GBIF Public Library</a>.
      </p>
    </div>
</@common.article>

<@common.article class="nohead">
    <div id="pubcontent" class="fullwidth">
        <p>There are currently no publications tagged with ${country.title}.</p>
    </div>
</@common.article>


</body>
</html>
