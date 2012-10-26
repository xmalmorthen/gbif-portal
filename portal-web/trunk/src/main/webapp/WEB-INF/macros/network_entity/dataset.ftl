<#--
	Construct a Dataset record.
-->
<#macro record dataset>
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
        <p class="note semi_bottom">${dataset.description}</p>
      </#if>
    </div>
  </div>
</#macro>