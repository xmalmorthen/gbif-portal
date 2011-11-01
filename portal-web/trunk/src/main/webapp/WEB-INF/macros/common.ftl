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