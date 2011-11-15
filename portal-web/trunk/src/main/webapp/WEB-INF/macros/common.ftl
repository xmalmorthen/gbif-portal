<#--
	Limits a string to a maximun length and adds an ellipsis if longer.
-->
<#function limit x max=100>
  <#assign x=(x!"")?trim/>
  <#if ((x)?length <= max)>
  	<#return x>
	<#else>
    <#return x?substring(0, max)+"…" />
	</#if>
</#function>

<#macro usageSource component showChecklistSource=false showChecklistSourceOnly=false>
  <#if showChecklistSourceOnly>
    <#assign src=""/>
  <#else>
    <#assign src=(component.source!"")?trim/>
  </#if>
  <#if showChecklistSource>
    <#assign src><a href='<@s.url value='/species/${component.usageKey?c}'/>'>${checklists.get(component.checklistKey).name}</a><br/>${src}</#assign>
  </#if>
  <#if src?has_content || component.remarks?has_content>
    <a class="sourcePopup" id="source${component.key?c}" source="${src!}" remarks="${component.remarks!}"></a>
  </#if>

</#macro>

<#macro popup source remarks="" title="Source">
  <#if source?has_content || d.remarks>
    <a class="sourcePopup" title=${title!"Source"} source="${source}" remarks="${remarks!}"></a>
  </#if>
</#macro>