<#import "/WEB-INF/macros/common.ftl" as common>

<@common.article id="publishers" title="Endorsed Publishers">
  <div class="fullwidth">
      <ul class="notes">
        <#list publisherPage.results as pub>
          <li>
            <a href="<@s.url value='/publisher/${pub.key}'/>">${pub.title!"???"}</a>
            <span class="note">A data publisher
              <#if pub.city?? || pub.country??>from <@common.cityAndCountry pub/></#if>
              <#if (pub.numOwnedDatasets > 0)>with ${pub.numOwnedDatasets} published datasets</#if>
             </span>
          </li>
        </#list>
        <#if !publisherPage.endOfRecords>
          <li class="more">
            <#if country??>
              <a href="<@s.url value='/country/${isocode}/publishers'/>">more</a>
            <#else>
              <a href="<@s.url value='/node/${member.key}/publishers'/>">more</a>
            </#if>
          </li>
        </#if>
      </ul>
  </div>
</@common.article>