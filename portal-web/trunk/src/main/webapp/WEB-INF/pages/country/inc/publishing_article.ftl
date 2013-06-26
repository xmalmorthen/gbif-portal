<#import "/WEB-INF/macros/common.ftl" as common>

<@common.article id="publishing" class="map" titleRight="Data from ${country.title}">
    <div class="map" id="mapBy"></div>

    <div class="right">
      <ul>
          <li>
            <#if by.occurrenceDatasets gt 0>
              <a href="<@s.url value='/dataset/search?publishingCountry=${isocode}&type=OCCURRENCE'/>">${by.occurrenceDatasets} occurrence datasets</a>
              with <a href="<@s.url value='/occurrence/search?publishingCountry=${isocode}'/>">${by.occurrenceRecords} records</a>.
            <#else>
              No occurrence datasets.
            </#if>
          </li>

          <li>
            <#if by.checklistDatasets gt 0>
              <a href="<@s.url value='/dataset/search?publishingCountry=${isocode}&type=CHECKLIST'/>">${by.checklistDatasets} checklists</a>
              with ${by.checklistRecords} records.
            <#else>
              No checklist datasets.
            </#if>
          </li>

          <li>
            <#if by.externalDatasets gt 0>
              <a href="<@s.url value='/dataset/search?publishingCountry=${isocode}&type=METADATA'/>">${by.externalDatasets} metadata documents</a>.
            <#else>
              No external metadata documents.
            </#if>
          </li>

          <li>
            ${country.title} publishes data covering
            <#if by.countries gt 0>
                <a href="<@s.url value='/country/${isocode}/publishing#countries'/>">${by.countries} countries</a>.
            <#else>
              no countries.
            </#if>
          </li>
      </ul>
    </div>
</@common.article>
