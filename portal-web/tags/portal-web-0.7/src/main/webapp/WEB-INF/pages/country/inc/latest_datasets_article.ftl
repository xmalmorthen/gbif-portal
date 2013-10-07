<#import "/WEB-INF/macros/common.ftl" as common>

<#if feed??>
  <#assign titleRight = "News" />
<#else>
  <#assign titleRight = "" />
</#if>
<@common.article id="datasets" title="Latest datasets published" titleRight=titleRight>
    <div class="<#if feed??>left<#else>fullwidth</#if>">
      <#if datasets?has_content>
        <ul class="notes">
          <#list datasets as cw>
            <#if cw_index==6>
                <li class="more"><a href="<@s.url value='/dataset/search?publishingCountry=${country.name()}'/>">${by.occurrenceDatasets + by.checklistDatasets - 6} more</a></li>
                <#break />
            </#if>
              <li>
                <a title="${cw.obj.title}" href="<@s.url value='/dataset/${cw.obj.key}'/>">${common.limit(cw.obj.title, 100)}</a>
                <span class="note">${cw.obj.modified?date}. ${cw.count} records <#if cw.geoCount gt 0>(${cw.geoCount} georeferenced)</#if>
                  <#if cw.obj.owningOrganizationKey??>
                    published by <a href="<@s.url value='/publisher/${cw.obj.owningOrganizationKey}'/>" title="${action.getOrganization(cw.obj.owningOrganizationKey).title}">${action.getOrganization(cw.obj.owningOrganizationKey).title}</a>
                  <#else>
                    indexed.
                  </#if>
                </span>
              </li>
          </#list>
        </ul>
      <#else>
        <p>None published.</p>
      </#if>
    </div>

  <#if feed??>
    <div class="right">
        <div id="news"></div>
    </div>
  </#if>
</@common.article>
