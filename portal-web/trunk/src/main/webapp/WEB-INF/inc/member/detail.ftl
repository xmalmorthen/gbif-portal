<#import "/WEB-INF/macros/common.ftl" as common>
<html>
<head>
  <title>Member detail - GBIF</title>
  <meta name="gmap" content="true"/>
  <content tag="extra_scripts">
    <script type="text/javascript" charset="utf-8">
      $(function() {
        $("#dataset-graph1").addGraph(generateRandomValues(50));
        $("#dataset-graph2").addGraph(generateRandomValues(50));
        $("#dataset-graph3").addGraph(generateRandomValues(50));
        $("#dataset-graph4").addGraph(generateRandomValues(50));
      });
    </script>
  </content>

</head>
<body class="species typesmap">

<#assign tab="info"/>
<#include "/WEB-INF/inc/member/infoband.ftl">

<content tag="admin">
  <ul>
    <li><a href="<@s.url value='/admin/${memberType?lower_case}/${id}'/>" title="Edit"><span>Edit</span></a></li>
    <li><a href="<@s.url value='/admin/${memberType?lower_case}/${id}'/>" title="Delete"><span>Delete</span></a></li>
    <li class="last"><a href="<@s.url value='/admin/${memberType?lower_case}/${id}'/>" title="Merge"><span>Merge</span></a></li>
  </ul>
</content>

  <article>
  <header></header>
  <div class="content">

    <div class="header">
      <div class="left"><h2>Member Information</h2></div>
    </div>

    <div class="left">
      <h3>Description</h3>
      <p>${member.description!"&nbsp;"}</p>

      <h3>Address</h3>
      <p>
      <#assign parts = ["${member.address!}","${member.zip!}","${member.city!}","${member.country!}" ]>
      <#list parts as k>
        <#if k?has_content>
        ${k}<#if k_has_next>, </#if>
        </#if>
      </#list>
       &nbsp;
      </p>

      <h3>Contacts</h3>
      <ul class="team">
       <#list member.contacts as c>
        <li>
          <@common.contact con=c />
        </li>
       </#list>
      </ul>


    </div>
    <div class="right">

      <#if member.logoURL?has_content>
        <div class="logo_holder">
          <img src="${member.logoURL}"/>
        </div>
      </#if>

      <h3>Endorsed by</h3>
      <p class="placeholder_temp">GBIF USA</p>

      <h3>Networks</h3>
      <ul class="placeholder_temp">
        <li><a href="<@s.url value='/member/123'/>" title="World Museums">World Museums</a></li>
        <li><a href="<@s.url value='/member/123'/>" title="World Museums">World Museums</a></li>
        <li><a href="<@s.url value='/member/123'/>" title="World Museums">World Museums</a></li>
      </ul>

      <h3>Technical partner</h3>
      <p class="placeholder_temp"><a href="<@s.url value='/member/123'/>" title="Harvard ETSUM">Harvard ETSUM</a></p>

    </div>
  </div>
  <footer></footer>
</article>

<article>
  <header></header>
  <div class="content placeholder_temp">

    <div class="header">
      <div class="left"><h2>Contribution to GBIF</h2></div>
    </div>

    <div class="left">
      <div class="minigraphs">
        <div id="dataset-graph1" class="minigraph">
          <h3><a href="<@s.url value='/dataset/search?owning_org=${id}'/>">45<span>Datasets</span></a></h3>
          <div class="percentage down">21% last year</div>
          <div class="start">1998</div>
          <div class="end">2011</div>
          <div class="lt"></div>
          <div class="rt"></div>
        </div>
        <div id="dataset-graph2" class="minigraph last">
          <h3><a href="<@s.url value='/dataset/search?type=CHECKLIST&owning_org=${id}'/>">25<span>Checklists</span></a></h3>
          <div class="percentage up">21% last year</div>
          <div class="start">1998</div>
          <div class="end">2011</div>
          <div class="lt"></div>
          <div class="rt"></div>
        </div>
      </div>
      <div class="minigraphs last">
        <div id="dataset-graph3" class="minigraph">
          <h3>123,599<span>occurrences</span></h3>

          <div class="percentage down">21% last year</div>
          <div class="start">1998</div>
          <div class="end">2011</div>
          <div class="lt"></div>
          <div class="rt"></div>
        </div>
        <div id="dataset-graph4" class="minigraph last">
          <h3>30,123<span>species</span></h3>

          <div class="percentage up">21% last year</div>
          <div class="start">1998</div>
          <div class="end">2011</div>
          <div class="lt"></div>
          <div class="rt"></div>
        </div>
      </div>
    </div>

    <div class="right">
      <h3>Top countries covered</h3>
      <ul>
        <li><a href="<@s.url value='/country/42'/>" title="Poland">Poland</a></li>
        <li><a href="<@s.url value='/country/42'/>" title="Ecuador">Ecuador</a></li>
        <li><a href="<@s.url value='/country/42'/>" title="Namibia">Namibia</a></li>
      </ul>

      <h3>Available reports</h3>
      <ul>
        <li class="download"><a href="#" title="Museum Standards">Museum Standards</a></li>
        <li class="download"><a href="#" title="Academy of Natural Sciences">Academy of Natural Sciences</a></li>
      </ul>
    </div>

  </div>
  <footer></footer>
</article>

<article class="map">
  <header></header>
  <div id="map"></div>
  <a href="#zoom_in" class="zoom_in"></a>
  <a href="#zoom_out" class="zoom_out"></a>

  <div class="content placeholder_temp">

    <div class="header">
      <div class="right"><h2>1,453 georeferenced occurrences</h2></div>
    </div>

    <div class="right">
      <h3>Visualize</h3>

      <p class="maptype"><a class="selected" href="#" title="points">points</a> | <a href="#" title="grid">grid</a> | <a
              href="#" title="polygons">polygons</a></p>

      <h3>Download</h3>
      <ul>
        <li class="download"><a href="#" title="One Degree cell density">One Degree cell density <abbr
                title="Keyhole Markup Language">(KML)</abbr></a></li>
        <li class="download"><a href="#" title="Placemarks">Placemarks <abbr
                title="Keyhole Markup Language">(KML)</abbr></a></li>
      </ul>
    </div>
  </div>
  <footer></footer>
</article>


</body>
</html>
