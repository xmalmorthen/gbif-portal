<#import "/WEB-INF/macros/common.ftl" as common>

<#--
	Construct a Dataset record.
	WARNING! if showPublisher is true an action method action.getOrganization(UUID) must exist to return the matching org
-->
<#macro dataset dataset maxDescriptionLength=500 showPublisher=false>
  <div class="result">
    <h2>
      <strong>

      <#-- dataset name and hyperlinked to its corresponding page -->
      <#if dataset.title?has_content>
        <a href="<@s.url value='/dataset/${dataset.key}'/>">${dataset.title}</a>
      </#if>

      </strong>
      <#-- If anything needs to be placed next to the dataset title, put it here -->
      <span class="note">${dataset.subtype!} <@s.text name="enum.datasettype.${dataset.type!}"/></span>
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
