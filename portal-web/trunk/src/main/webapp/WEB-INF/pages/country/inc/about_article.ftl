<#import "/WEB-INF/macros/common.ftl" as common>

<@common.article id="about" class="map" titleRight="Data about ${country.title}">
    <div class="map" id="mapAbout"></div>

    <div class="right">
      <ul>
          <li>
            <#if about.occurrenceDatasets gt 0>
              <a href="<@s.url value='/dataset/search?country=${id}&type=OCCURRENCE'/>">${about.occurrenceDatasets} occurrence datasets</a>
              with <a href="<@s.url value='/occurrence/search?country=${id}'/>">${about.occurrenceRecords} records</a>.
            <#else>
              No occurrence datasets
            </#if>
          </li>

          <li>
            <#if about.checklistDatasets gt 0>
              <a href="<@s.url value='/dataset/search?country=${id}&type=CHECKLIST'/>">${about.checklistDatasets} checklists</a>
              with ${about.checklistRecords} records.
            <#else>
              No checklists.
            </#if>
          </li>

          <li>
            <#if about.externalDatasets gt 0>
              <a href="<@s.url value='/dataset/search?country=${id}&type=METADATA'/>">${about.externalDatasets} external datasets</a>
            <#else>
              No external datasets
            </#if>
              relevant to ${country.title}.
          </li>

          <li>
              <#if about.countries gt 0>
                  <a href="<@s.url value='/country/${id}/about#countries'/>">${about.countries} countries</a>
              <#else>
                  No countries
              </#if>
               contribute data about ${country.title}.
          </li>
      </ul>
    </div>
</@common.article>