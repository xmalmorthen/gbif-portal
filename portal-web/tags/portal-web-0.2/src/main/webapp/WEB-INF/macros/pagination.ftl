<#import "/WEB-INF/macros/common.ftl" as common>
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
      <@numberedPagination page url/>
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
 - maxPages: optional, number of page links to show at max without counting first & last, defaults to 5

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
 -->
<#macro numberedPagination page url maxLink=5 >
  <#-- Total number of pages for the resultset -->
  <#assign totalPages = (page.count/page.limit)?ceiling />
  <#-- current url with paging params removed -->
  <#assign currUrl = getStripUrl(url) />
  <#-- the current page number, first page = 1 -->
  <#assign currPage = (page.offset/page.limit)?round + 1 />
  <#-- the first numbered page to show. If only 1 page exists its a special case caught below -->
  <#assign minPage = common.max(currPage - (maxLink/2)?floor, 2) />
  <#-- the last numbered page to show -->
  <#assign maxPage = common.max(minPage, common.min(minPage + maxLink - 1, totalPages - 1))/>

  <ul class="numbered-pagination">
  <@pageLink title="First" url=getFullUrl(currUrl, 0, page.limit) current=(currPage=1) />
  <#if totalPages gt 1 >
    <#if totalPages gt 2 >
      <#list minPage .. maxPage as p>
        <@pageLink title=p url=getFullUrl(currUrl, page.limit*(p-1), page.limit) current=(currPage=p) />
      </#list>
      <#if totalPages gt maxPage + 1>
        <li>...</li>
      </#if>
    </#if>
    <@pageLink title="Last" url=getFullUrl(currUrl, page.limit*(totalPages-1), page.limit) current=(currPage=totalPages) />
  </#if>
  </ul>
</#macro>

<#macro pageLink title url current=false>
<li><a <#if current>class="current"</#if> href="${url}">${title?string}</a></li>
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