<#-- 
Pagination macro for rendering NEXT & PREVIOUS buttons, whenever applicable 
 - offset: mandatory, current offset
 - limit: mandatory, maximum number of records to display per page
 - totalResults: optional, total number of records. If this parameter is not set,
                 then the NEXT button will always be displayed and the 
                 "viewing page X of Y (total)" message will not be displayed.
 - baseUrl: mandatory, current url
 
 Please feel free to improve the code in any way.
-->
<#macro pagination offset limit url totalResults=-1>
  <#assign stripUrl = getStripUrl(url) >
  <#assign nextUrl = getFullUrl(stripUrl, (offset+limit), limit) >
  <#assign previousUrl = getFullUrl(stripUrl, (offset-limit), limit) >
  <#if (limit > 0) && (offset > 0) >
    <a href="${previousUrl}" class="candy_white_button previous"><span>Previous page</span></a>
  </#if>
  <#if (totalResults>-1)>
    <#if (offset+limit<totalResults)>
      <a href="${nextUrl}" class="candy_white_button next"><span>Next page</span></a>
    </#if>
    <#assign totalPages = totalResults / limit>
    <#assign currentPage = getCurrentPage(offset, limit) >
    <div class="pagination">viewing page ${currentPage} of ${totalPages?ceiling}</div>
  <#else>
    <a href="${nextUrl}" class="candy_white_button next"><span>Next page</span></a>
  </#if>
</#macro>
<#function getCurrentPage offset limit start=1 current=1>
    <#if (offset<start)>
  		<#return current>
	<#else>
		${getCurrentPage(offset,limit,(start+limit), current+1)}
	</#if>
</#function>
<#function getStripUrl baseUrl>
	<#assign stripUrl = "">
	<#list baseUrl?split("&") as queryParam>
	    <#if !queryParam?contains("limit") && !queryParam?contains("offset")>
			<#assign stripUrl = stripUrl+"&"+queryParam>
		</#if>
	</#list>  
	<#if stripUrl?starts_with("&")>
		<#return stripUrl?substring(1)>
	<#else>
		<#return stripUrl>
	</#if>
</#function>
<#function getFullUrl stripUrl offset limit>
	<#assign fullUrl = "">
		<#if stripUrl?contains("?")>
			<#assign fullUrl = stripUrl+"&offset="+offset+"&limit="+limit>
		<#else>
			<#assign fullUrl = stripUrl+"?offset="+offset+"&limit="+limit>
		</#if>
	<#return fullUrl>	
</#function>