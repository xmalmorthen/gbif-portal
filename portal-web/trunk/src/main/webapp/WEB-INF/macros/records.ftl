<#import "/WEB-INF/macros/common.ftl" as common>

<#--
	Construct a Dataset record.
	WARNING! if showPublisher is true an action method action.getOrganization(UUID) must exist to return the matching org
-->
<#macro dataset dataset maxDescriptionLength=500 showPublisher=false>
  <div class="result">
    <h3>${dataset.subtype!} <@s.text name="enum.datasettype.${dataset.type!}"/></h3>
    <h2>
      <strong>

      <#-- dataset name and hyperlinked to its corresponding page -->
      <#if dataset.title?has_content>
        <a href="<@s.url value='/dataset/${dataset.key}'/>">${dataset.title}</a>
      </#if>

      </strong>
    </h2>

    <#if showPublisher && dataset.owningOrganizationKey??>
      <p>
        <#assign publisher=action.getOrganization(dataset.owningOrganizationKey) />
        Published by <a href="<@s.url value='/publisher/${publisher.key}'/>" title="${publisher.title}">${publisher.title}</a>.
      </p>
    </#if>

    <div class="footer">
      <#if dataset.description?has_content>
        <p class="note semi_bottom">${common.limit(dataset.description, maxDescriptionLength)}</p>
      </#if>
    </div>
  </div>
</#macro>


<#--
	Construct a large data publisher record with a description.
-->
<#macro publisherWithDescription publisher>
  <div class="result">
    <h2>
      <strong>

      <#-- name and hyperlinked to its corresponding page -->
      <#if publisher.title?has_content>
        <a href="<@s.url value='/publisher/${publisher.key}'/>">${publisher.title}</a>
      </#if>

      </strong>
      <#-- If anything needs to be placed next to the title, put it here -->
      <span class="note">${publisher.numOwnedDatasets} published datasets.</span>
    </h2>

    <div class="footer">
      <#if publisher.description?has_content>
        <p class="note semi_bottom">${publisher.description}</p>
      </#if>
    </div>
  </div>
</#macro>

<#--
	Construct a simple data publisher record useful for article blocks.
-->
<#macro publisher publisher>
<li>
  <a href="<@s.url value='/publisher/${publisher.key}'/>">${publisher.title!"???"}</a>
  <span class="note">A data publisher
    <#if publisher.city?? || publisher.country??>from <@common.cityAndCountry publisher/></#if>
    <#if (publisher.numOwnedDatasets > 0)>with ${publisher.numOwnedDatasets} published datasets</#if>
   </span>
</li>
</#macro>


<#--
  requires a few action methods to exist !!!:

 - action.getHumanFilter()
 - action.getQueryParams()
 - action.isDownloadRunning()
-->
<#macro downloadFilter download showCancel=false>
<div class="result">
  <div class="footer">
      <dl>
          <dt>Filter</dt>
          <dd>
              <#assign filterMap=action.getHumanFilter(download.request.predicate)!""/>
              <#assign queryParams=action.getQueryParams(download.request.predicate)!""/>
              <#assign searchLink='/occurrence/search'/>
              <#if queryParams?has_content>
                <#assign searchLink='/occurrence/search?'+ queryParams!""/>                
              </#if>
              <table class="table">
              <#if !download.request.predicate?has_content>
                <tr>
                  <th><a href="${searchLink}'/>">None</a></th>
                  <td></td>
                </tr>
              <#elseif filterMap?has_content>
                <#list filterMap?keys as param>
                  <tr>
                    <th><a href="${searchLink}"><@s.text name="search.facet.${param}" /></a></th>
                    <td><#list filterMap.get(param) as val><span><a href="${searchLink}">${val}</a></span><#if val_has_next><a href="${searchLink}">, </a></#if></#list></td>
                  </tr>
                </#list>
              <#else>
                  <tr>
                    <th><a href="${searchLink}">Raw Filter</a></th>
                    <td><a href="${searchLink}">${download.request.predicate!"None"}</a></td>
                  </tr>
              </#if>
              </table>
          </dd>

          <dt>Status</dt>
          <dd>
            <#if download.available>
              <!-- cfg.wsOccDownload is not public, but needed for authentication. Therefore wsOccDownloadForPublicLink was created which is public -->
              Ready for <a href="${cfg.wsOccDownloadForPublicLink}occurrence/download/request/${download.key}.zip">download</a>
            <#elseif showCancel && action.isDownloadRunning(download.status)>
              Still running. Do you want to <a href="<@s.url value='/user/download/cancel?key=${download.key}'/>">cancel</a> the query?
            <#else>
              <@s.text name="enum.downloadstatus.${download.status}" />
            </#if>
          </dd>

          <dt>Created</dt>
          <dd>${download.created?date?string.medium}</dd>

          <#nested />
      </dl>
  </div>

</div>
</#macro>
