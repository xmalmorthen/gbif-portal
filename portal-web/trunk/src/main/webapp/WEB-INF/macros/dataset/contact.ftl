<#--
	Construct a Contact. Parameter is the actual contact object.
-->
<#macro record con>
  <strong><h4>${con.firstName!} ${con.lastName!}</h4></strong>
  <#if con.organizationName?has_content>
  <h4 class="position">${con.organizationName!}</h4>
  </#if>
  <#-- TODO: change enum as this displays something like "POINT_OF_CONTACT" -->
  <#if con.type?has_content>
    <#if con.type.interpreted?has_content>
      <h4 class="position">${con.type.interpreted.getName()}</h4>
    <#else>
      <h4 class="position">${con.type.verbatim?string!}</h4>
    </#if>
  </#if>

  <#if con.position?has_content>
  <h4 class="position">${con.position!}</h4>
  </#if>

  <address>
    <#assign props = ["${con.address!}","${con.city!}", "${con.province!}", "${con.postalCode!}", "${con.country!}" ]>
    <#list props as k>
      <#if k?has_content>
      ${k}<#if k_has_next>, </#if>
      </#if>
    </#list>

    <#if con.email?has_content>
      <a href="mailto:#" title="email">${con.email!}</a>
    </#if>
    <#if con.phone?has_content>
    ${con.phone!}
    </#if>
  </address>
</#macro>