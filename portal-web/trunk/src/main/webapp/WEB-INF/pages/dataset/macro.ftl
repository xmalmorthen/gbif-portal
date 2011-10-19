<#function currentPage offset limit start=1 current=1>
    <#if (offset<start)>
  		<#return current>
	<#else>
		${currentPage(offset,limit,(start+limit), current+1)}
	</#if>
</#function>
<#macro pagination offset limit baseUrl totalResults=-1>
  <#if (limit > 0)>
    <a href="#" class="candy_white_button previous"><span>Previous page</span></a>
  </#if>
  <#if (totalResults>-1)>
    <#if (offset+limit<totalResults)>
      <a href="#" class="candy_white_button next"><span>Next page</span></a>
      <#assign totalPages = totalResults / limit>
      <#assign currentPage = currentPage(offset, limit) >
      <div class="pagination">viewing page ${currentPage} of ${totalPages?ceiling}</div>
    </#if>
  <#else>
    <a href="#" class="candy_white_button next"><span>Next page</span></a>
  </#if>
</#macro>