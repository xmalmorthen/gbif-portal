<#import "/WEB-INF/macros/common.ftl" as common>

<@common.article id="about" class="map" titleRight="Data about ${country.title}">
    <div class="map" id="mapAbout"></div>

    <div class="right">
      <ul>
          <li>
              <a href="<@s.url value='/dataset/search?country=${id}&type=OCCURRENCE'/>">${about.occurrenceDatasets} occurrence datasets</a>
              with <a href="<@s.url value='/occurrence/search?country=${id}'/>">${about.occurrenceRecords} records</a>.
          </li>
          <li class="placeholder_temp">
              <a href="<@s.url value='/dataset/search?country=${id}&type=CHECKLIST'/>">${about.checklistDatasets} checklists</a>
              with ${about.checklistRecords} records.
          </li>
          <li class="placeholder_temp">
              <a href="<@s.url value='/dataset/search?country=${id}&type=METADATA'/>">${about.externalDatasets} external datasets</a>
              relevant to ${country.title}.
          </li>
          <li><a href="<@s.url value='/country/${id}/about#countries'/>">${about.countries} countries</a> contribute data about ${country.title}.</li>
      </ul>
    </div>
</@common.article>