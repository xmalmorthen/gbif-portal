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

<#macro usageSources components popoverTitle="Sources" showSource=true showChecklistSource=true>
  <#assign source="" />
  <#list components as comp>
    <#assign source>${source!}
      <p>
      <#if showSource>${comp.source!""}<br/></#if>
      <#if showChecklistSource>
        <a href='<@s.url value='/species/${comp.usageKey?c}'/>'>${checklists.get(comp.checklistKey).name}</a>
      </#if>
      </p><br/>
    </#assign>
  </#list>
  <a class="sourcePopup" title="${popoverTitle}" message="${source!}"></a>
</#macro>

<#macro popup message remarks="" title="Source">
  <#if message?has_content>
    <a class="sourcePopup" title="${title}" message="${message}" remarks="${remarks!}"></a>
  </#if>
</#macro>

<#macro popover linkTitle popoverTitle>
  <a class="popover" title="${popoverTitle}" message="<#nested>">${linkTitle}</a>
</#macro>