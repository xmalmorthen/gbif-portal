<#import "/WEB-INF/macros/common.ftl" as common>

<@common.article id="publishing" class="map" titleRight="Publishers and datasets from ${country.title}">
    <div class="map" id="mapBy"></div>

    <div class="right placeholder_temp">
      <ul>
          <li><a href="<@s.url value='/dataset/search?hostCountry=${id}&type=OCCURRENCE'/>">30 occurrence datasets</a>
              with <a href="<@s.url value='/occurrence/search?hostCountry=${id}'/>">${numBy} records</a>.
          </li>
          <li>
              <a href="<@s.url value='/dataset/search?hostCountry=${id}&type=CHECKLIST'/>">3 checklists</a>
              with 18,733 records.
          </li>
          <li>
              <a href="<@s.url value='/dataset/search?hostCountry=${id}&type=METADATA'/>">34 metadata documents</a>.
          </li>
          <li><a href="#">42 institutions</a> in ${country.title} publish data.</li>
      </ul>
    </div>
</@common.article>
