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
        <p>Voting Country Participant</p>

        <h3>GBIF Participant Since</h3>
        <p>2001</p>

        <h3>GBIF Region</h3>
        <p>Europe</p>

        <h3>Contacts</h3>
        <div class="col">
            <div class="contact">
               <div class="contactType">Head of Delegation</div>
               <div class="contactName">Simon Tillier</div>
               <div>Professor</div>
             <address>
              4101 rue Sherbrooke est,
                Montreal,
                Quebec,
                H1X2B2,
                Canada
                <a href="mailto:#" title="email">luc.brouillet@umontreal.ca</a>
             </address>
            </div>
          <div class="contact">
              <div class="contactType">Node Manager</div>
             <div class="contactName">
              Luc Brouillet
             </div>
             <div>
              Professor
             </div>
           <address>
            <!-- remember Contact.Country is an Enum, and we want to display the title (ie. Great Britain, not the code GB) -->
              4101 rue Sherbrooke est,
              Montreal,
              Quebec,
              H1X2B2,
              Canada

              <a href="mailto:#" title="email">luc.brouillet@umontreal.ca</a>
           </address>
          </div>
        </div>

        <div class="col">
            <div class="contact">
                <div class="contactType">Node Manager</div>
               <div class="contactName">
                Luc Brouillet
               </div>
               <div>
                Professor


               </div>
             <address>
              <!-- remember Contact.Country is an Enum, and we want to display the title (ie. Great Britain, not the code GB) -->
                4101 rue Sherbrooke est,
                Montreal,
                Quebec,
                H1X2B2,
                Canada

                <a href="mailto:#" title="email">luc.brouillet@umontreal.ca</a>
             </address>
            </div>
          <div class="contact">
             <div class="contactType">Node Manager</div>
             <div class="contactName">
              Peter Desmet
             </div>
             <div>
              Biodiversity Informatics Manager
               at
              Université de Montréal Biodiversity Centre
             </div>
           <address>
            <!-- remember Contact.Country is an Enum, and we want to display the title (ie. Great Britain, not the code GB) -->
              4101 rue Sherbrooke est,
              Montreal,
              Quebec,
              H1X2B2,
              Canada

              <a href="mailto:#" title="email">peter.desmet@umontreal.ca</a>
           </address>
          </div>
        </div>
    </div>

    <div class="right">
      <div class="logo_holder">
        <#if node?? && node.logoURL?has_content>
            <img src="${node.logoURL}"/>
        <#else>
          <!-- show country flag -->
          <img src="http://www.geonames.org/flags/x/${id?lower_case}.gif"/>
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
    </div>

  <#if feed??>
    <div class="right">
        <div id="news"></div>
    </div>
  </#if>
</@common.article>


</body>
</html>
