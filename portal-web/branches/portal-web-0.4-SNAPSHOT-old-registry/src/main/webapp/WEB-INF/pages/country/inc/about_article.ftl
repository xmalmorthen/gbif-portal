<#import "/WEB-INF/macros/common.ftl" as common>

<@common.article id="about" class="map" titleRight="Data about ${country.title}">
    <div class="map" id="mapAbout"></div>

    <div class="right placeholder_temp">
      <ul>
          <li>
              <a href="<@s.url value='/dataset/search?country=${id}&type=OCCURRENCE'/>">60 occurrence datasets</a>
              with <a href="<@s.url value='/occurrence/search?country=${id}'/>">${numAbout} records</a>.
          </li>
          <li>
              <a href="<@s.url value='/dataset/search?country=${id}&type=CHECKLIST'/>">4 checklists</a>
              with 38,922 records.
          </li>
          <li>
              <a href="<@s.url value='/dataset/search?country=${id}&type=METADATA'/>">34 external datasets</a>
              relevant to ${country.title}.
          </li>
          <li><a href="#">42 institutions</a> contribute data about ${country.title}.</li>
          <li><a href="#">26 countries</a> contribute data about ${country.title}.</li>
      </ul>
    </div>
</@common.article>