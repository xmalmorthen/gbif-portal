<#-- 
Macro for rendering pagination on the web app. 
If the page.count exists, it renders a numbered pagination.
If the page.count does not exist (is null), it renders the simple pagination (without numbered pages) 
 - page: a mandatory PagingResponse instance
 - url: mandatory, current url
-->
<#macro pagination page url>
  <#if page.count??>
    <#-- do not show pagination at all if count is less or equal to the total limit -->
    <#if (page.count > page.limit)>
      <@numberedPagination page url 3 3/>
    </#if>
  <#else>
    <@simplepagination page url/>
  </#if>
</#macro>





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
<#macro simplepagination page url>
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
</#macro>





<#-- 
Pagination macro for rendering numbered page links as well as [FIRST PAGE] and [LAST PAGE] links. 
 - page: a mandatory PagingResponse instance
 - url: mandatory, current url
 - maxPagesBefore: optional, number of page links shown before the current page (without taking into account the [FIRST PAGE] link)
 - maxPagesAfter: optional, number of page links shown after the current page (without taking into account the [LAST PAGE] link)
 
 The macro result will look like this (links are not important for documentation purposes, so they have been replaced by a '#'):
 
  <ul class="numbered-pagination">
    <li><a href="#">First</a></li>
    <li><a class="current" href="#">2</a></li>
    <li><a href="#">3</a></li>
    <li><a href="#">4</a></li>
    <li><a href="#">5</a></li>
    <li><a href="#">6</a></li>
    <li><a href="#">Last</a></li>
  </ul>
 
 Please feel free to improve the code in any way.
-->
<#macro numberedPagination page url maxPagesBefore=3 maxPagesAfter=3>

  <#--   
    Variables needed throughout the process.
   -->
  <#-- Total number of pages for the resultset -->
  <#if (page.offset/page.limit!=0) >
    <#assign totalPages = (page.count/page.limit)?ceiling >
  <#else>
    <#assign totalPages = (page.count/page.limit) >
  </#if>  
  
  <#-- Temp variable to keep count of the offset of the next page link to render -->
  <#assign newOffset = page.offset>
  <#-- Temp variable to keep count of the amount of page links that have been already rendered -->
  <#assign pagesRendered = 0>  
  <#-- Temp variable to keep count of the next page link to render -->
  <#assign pageCount = (page.offset/page.limit)?ceiling + 1>
  <#-- Loop variable needed for simulating a do-while loop -->
  <#assign loop = totalPages+5>
  <#-- Variable that indicates the lowest offset after the [FIRST PAGE] link (which has an offset=0)
       This will typically be the offset of the second page link. -->
  <#assign lowestOffset = 0>  
  <#-- HTML snippet that will hold the whole page links that are being built -->
  <#assign html = "">  

  <#-- 
    "html" contains the HTML that will hold the page numbers.
    First, render the current page.
  -->
  <#if pageCount != 1 && pageCount != totalPages >
    <#assign pageUrl = getFullUrl(getStripUrl(url), newOffset, 0)>
    <#assign html = "<li><a class=\"current\" href=\"${pageUrl}\">${pageCount}</a></li>" + html>  
    <#assign pageCount = pageCount-1>
  </#if>
  
  <#-- It is the last page - substract one from the pageCount -->
  <#if pageCount==totalPages>
    <#assign pageCount = pageCount-1>
  </#if>
  
  <#-- 
    Check if there's any pages before the current one. If there are any,
    then append them before the current "html" string. As freemarker does not 
    have a concrete do-while loop, the list directive can be used to make it
    work the same way.
  -->
  <#list 1..loop as x>
    <#if (pageCount < 2 || pagesRendered>=maxPagesBefore)>
      <#break>
    </#if>
      <#assign newOffset = newOffset - page.limit>
      <#if (newOffset<0)>
        <#assign lowestOffset = newOffset + page.limit>
        <#assign newOffset = 0>
      </#if>
      <#assign pageUrl = getFullUrl(getStripUrl(url), newOffset, 0)>
      <#assign html = "<li><a href=\"${pageUrl}\">${pageCount}</a></td>" + html></li>
      <#assign pageCount = pageCount-1>
      <#assign pagesRendered = pagesRendered+1>
  </#list>

    <#-- Reset needed values -->
    <#assign pageCount = (page.offset/page.limit)?ceiling + 1>
    <#assign newOffset = page.offset>
    <#assign pagesRendered = 0>
  
  <#-- 
    Check if there's any pages after the current one. If there are any,
    then append them after the current "html" string. As freemarker does not 
    have a concrete do-while loop, the list directive can be used to make it
    work the same way.
  -->  
  <#list 1..loop as x>
    <#assign pageCount = pageCount+1>       
    <#assign newOffset = newOffset + page.limit>
    <#assign pageUrl = getFullUrl(getStripUrl(url), newOffset, 0)>  
    <#if ( (pageCount >= totalPages) || (newOffset+page.limit)>=page.count ||  pagesRendered>=maxPagesAfter)>
      <#break>
    </#if>
    <#assign html = html + "<li><a href=\"${pageUrl}\">${pageCount}</a></li>">   
    <#assign pagesRendered = pagesRendered+1>
  </#list>  

  <#-- Reset value -->
  <#assign newOffset = page.offset>

  <#-- Calculate the offset of the [LAST PAGE] link -->
  <#list 1..loop as x>
    <#assign newOffset = newOffset + page.limit>
    <#if ((newOffset+page.limit)>=page.count)>
      <#break>
    </#if>
  </#list>
 
  <#-- Strip the current URL of any instances of the "offset" parameter and insert the new "offset" value -->  
  <#assign pageUrl = getFullUrl(getStripUrl(url), newOffset, 0)>
  <#if (page.offset >= (page.count - page.limit))>
    <#assign html = html + "<li><a class=\"current\"  href=\"${pageUrl}\">Last</a></li>">
  <#else>
    <#assign html = html + "<li><a href=\"${pageUrl}\">Last</a></li>">
  </#if>
  
  <#assign pageUrl = getFullUrl(getStripUrl(url), 0, 0)>    
  <#if page.offset == 0>
    <#assign html = "<li><a class=\"current\" href=\"${pageUrl}\">First</a></li>" + html> 
  <#else>
    <#assign html = "<li><a href=\"${pageUrl}\">First</a></li>" + html> 
  </#if>
  
  <#assign html = "<ul class=\"numbered-pagination\">" + html + "</ul>"> 
  
  <#-- output the final result, escaping all ampersands to be compliant with the HTML specification -->
  ${html?replace("&", "&amp;")}

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
	<#assign baseUrl = "">
	<#assign queryString = "">
	<#if url?contains("?")>
	   <#assign urlSplit = url?split("?")>
	   <#assign baseUrl = urlSplit[0] + "?">
       <#assign queryString = urlSplit[1]>
	<#else>
	   <#assign baseUrl = url>
	</#if>
	<#list queryString?split("&") as queryParam>
	  <#if !queryParam?contains("limit") && !queryParam?contains("offset")>
		  <#assign stripUrl = stripUrl+"&"+queryParam>
		</#if>
	</#list>  
	<#if stripUrl?starts_with("&")>
		<#return baseUrl + stripUrl?substring(1)>
	<#else>
		<#return baseUrl + stripUrl>
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
			<#assign fullUrl = stripUrl+"&offset="+offset?c>
		<#else>
			<#assign fullUrl = stripUrl+"?offset="+offset?c>
		</#if>
	<#return fullUrl>	
</#function>