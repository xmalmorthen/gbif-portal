<#list tags as tag>
  <#if tag.namespace?has_content>${tag.namespace}:</#if><#if tag.predicate?has_content>${tag.predicate}=</#if><#if tag.value?has_content>${tag.value}</#if>
  <a href="#"><img src="<@s.url value='/img/minus.png'/>" class="deleteTag" name="${tag_index}" id="${tag_index}"></a>
</#list>  