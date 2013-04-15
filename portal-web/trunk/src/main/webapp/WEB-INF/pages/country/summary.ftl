<#import "/WEB-INF/macros/common.ftl" as common>
<html>
<head>
  <title>Country Summary for ${country.title}</title>
  <link rel="stylesheet" href="<@s.url value='/js/vendor/leaflet/leaflet.css'/>" />
  <!--[if lte IE 8]><link rel="stylesheet" href="<@s.url value='/js/vendor/leaflet/leaflet.ie.css'/>" /><![endif]-->
  <script type="text/javascript" src="<@s.url value='/js/vendor/leaflet/leaflet.js'/>"></script>
  <script type="text/javascript" src="<@s.url value='/js/map.js'/>"></script>
  <script type="text/javascript">
      $(function() {
          $("#mapAbout").densityMap("${id}", "COUNTRY");
          $("#mapBy").densityMap("${id}", "COUNTRY");
      });
  </script>
</head>
<body>

<#assign tab="summary"/>
<#include "/WEB-INF/pages/country/inc/infoband.ftl">


<@common.article id="about" class="map" titleRight="About ${country.title}">
    <div class="map" id="mapAbout"></div>

    <div class="right">
      <p>Data about ${country.title} are contributed by 30 institutions in 26 countries:</p>

      <ul>
          <li>60 occurrence datasets with 15,644,091 records.</li>
          <li>4 checklist datasets with 38,922 records.</li>
      </ul>
    </div>
</@common.article>


<@common.article id="publishing" class="map" titleRight="Published By ${country.title}">
    <div class="map" id="mapBy"></div>

    <div class="right">
      <p>${country.title} publishes data concerning 244 countries, islands and territories:</p>

      <ul>
          <li>30 occurrence datasets with 5,644,091 records.</li>
          <li>3 checklist datasets with 18,733 records.</li>
      </ul>
    </div>
</@common.article>


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
    </div>
</@common.article>


<@common.article id="latest" title="Latest datasets published" titleRight="News">
    <div class="left">
    </div>

    <div class="right">
    </div>
</@common.article>


</body>
</html>
