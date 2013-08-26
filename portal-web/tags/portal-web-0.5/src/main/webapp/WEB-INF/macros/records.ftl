<#import "/WEB-INF/macros/common.ftl" as common>

<#--
	Construct a Dataset record.
-->
<#macro dataset dataset maxDescriptionLength=500>
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

    <div class="footer">
      <#if dataset.description?has_content>
        <p class="note semi_bottom">${common.limit(dataset.description, maxDescriptionLength)}</p>
      </#if>
    </div>
  </div>
</#macro>


<#--
	Construct a data publisher record.
-->
<#macro publisher publisher>
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
