<#-- 
Pagination macro for rendering NEXT & PREVIOUS buttons, whenever applicable 
 - offset: mandatory, current offset
 - limit: mandatory, maximum number of records to display per page
 - totalResults: optional, total number of records. If this parameter is not set,
                 then the NEXT button will always be displayed and the 
                 "viewing page X of Y (total)" message will not be displayed.
 - page: a mandatory PagingResponse instance
 - url: mandatory, current url
 
 Please feel free to improve the code in any way.
-->
<#macro pagination page url>
  <#assign offset = page.offset>
  <#assign limit = page.limit>
  <#assign stripUrl = getStripUrl(url) >
  <#if (offset>1) && (offset < limit) >
    <a href="${getFullUrl(stripUrl, 0, limit)}" class="candy_white_button previous"><span>Previous page</span></a>
  <#elseif (limit > 0) && (offset > 0) >
    <a href="${getFullUrl(stripUrl, (offset-limit), limit)}" class="candy_white_button previous"><span>Previous page</span></a>
  </#if>

  <#if !page.isEndOfRecords()>
    <a href="${getFullUrl(stripUrl, (offset+limit), limit)}" class="candy_white_button next"><span>Next page</span></a>
  </#if>
  <div class="pagination">viewing page ${getCurrentPage(offset, limit)}
    <#if ((page.count!0)>0)> of ${(page.count / limit)?ceiling}</#if>
  </div>
<#--
<div class="pagination">limit=${page.limit!}, offset=${page.offset!}, count=${page.count!}, isEndOfRecords()=${page.isEndOfRecords()?string}</div>
-->
</#macro>

<#-- 
	Returns the current page number a user is navigating.
-->
<#function getCurrentPage offset limit start=1 current=1>
    <#if (offset<start)>
  		<#return current>
	<#else>
		${getCurrentPage(offset,limit,(start+limit), current+1)}
	</#if>
</#function>

<#-- 
	Takes an URL and strips off any "limit" or "offset" query parameter (along with its value). 
	Any other query parameters are left untouched.
-->
<#function getStripUrl url>
	<#assign stripUrl = "">
	<#list url?split("&") as queryParam>
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

<#-- 
	Appends the "offset" query parameters to an existing URL assuming the limit is static and defined by the action alone.
	If there existing query parameters, the append is done using an ampersand (&).
	If there are no existing query parameters, the append is done using the (?).
-->
<#function getFullUrl stripUrl offset limit>
	<#assign fullUrl = "">
		<#if stripUrl?contains("?")>
			<#assign fullUrl = stripUrl+"&offset="+offset>
		<#else>
			<#assign fullUrl = stripUrl+"?offset="+offset>
		</#if>
	<#return fullUrl>	
</#function>