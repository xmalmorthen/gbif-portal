<#list identifiers as identifier>
  <#if identifier.type?has_content><strong>${identifier.type}</strong>:</#if><#if identifier.identifier?has_content>${identifier.identifier}</#if>
  <a href="#"><img src="<@s.url value='/img/minus.png'/>" class="deleteIdentifier" name="${identifier_index}" id="${identifier_index}"></a>
</#list>  