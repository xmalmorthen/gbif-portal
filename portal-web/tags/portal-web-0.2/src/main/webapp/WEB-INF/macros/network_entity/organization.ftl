<#--
	Construct an Organization record.
-->
<#macro record organization>
  <div class="result">
    <h2>
      <strong>
      
      <#-- organization name and hyperlinked to its corresponding page -->
      <#if organization.title?has_content>
        <a href="<@s.url value='/organization/${organization.key}'/>">${organization.title}</a> 
      </#if>
      
      </strong>
      <#-- If anything needs to be placed next to the organization title, put it here -->
      <span class="note">${organization.numDatasets} published datasets.</span>
    </h2>

    <div class="footer">
      <#if organization.description?has_content>
        <p class="note semi_bottom">${organization.description}</p>
      </#if>
    </div>
  </div>
</#macro>