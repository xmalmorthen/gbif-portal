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
    <#assign source=""/>
  <#else>
    <#assign source=(component.source!"")?trim/>
  </#if>
  <#if showChecklistSource>
    <#assign source><a href='<@s.url value='/species/${component.usageKey?c}'/>'>${checklists.get(component.checklistKey).name}</a><br/>${source}</#assign>
  </#if>
  <#if source?has_content || component.remarks?has_content>
    <a class="sourcePopup" message="${source!}" remarks="${component.remarks!}"></a>
  </#if>

</#macro>

<#macro popup title="Source" remarks="">
  <a class="sourcePopup" title="${title}" message="<#nested>" remarks="${remarks!}"></a>
</#macro>