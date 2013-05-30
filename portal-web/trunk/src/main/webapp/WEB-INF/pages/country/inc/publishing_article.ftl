<#import "/WEB-INF/macros/common.ftl" as common>

<@common.article id="publishing" class="map" titleRight="Data from ${country.title}">
    <div class="map" id="mapBy"></div>

    <div class="right">
      <ul>
          <li><a href="<@s.url value='/dataset/search?hostCountry=${id}&type=OCCURRENCE'/>">${by.occurrenceDatasets} occurrence datasets</a>
              with <a href="<@s.url value='/occurrence/search?hostCountry=${id}'/>">${by.occurrenceRecords} records</a>.
          </li>
          <li>
              <a href="<@s.url value='/dataset/search?hostCountry=${id}&type=CHECKLIST'/>">${by.checklistDatasets} checklists</a>
              with ${by.checklistRecords} records.
          </li>
          <li>
              <a href="<@s.url value='/dataset/search?hostCountry=${id}&type=METADATA'/>">${by.externalDatasets} metadata documents</a>.
          </li>
          <li>${country.title} publishes data covering <a href="<@s.url value='/country/${id}/by#countries'/>">${by.countries} countries</a>.</li>
      </ul>
    </div>
</@common.article>
