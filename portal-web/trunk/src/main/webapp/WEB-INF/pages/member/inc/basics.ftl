<#import "/WEB-INF/macros/common.ftl" as common>

  <h3>Full Title</h3>
  <p>${member.title}</p>

<#if member.description?has_content>
  <h3>Description</h3>
  <p>${member.description}</p>
</#if>

<#if member.metadataLanguage?has_content>
<h3>Language of Metadata</h3>
<p>${member.metadataLanguage}</p>
</#if>

<#if member.email?has_content>
<h3>Email</h3>
<p>${member.email}</p>
</#if>

<#if member.phone?has_content>
<h3>Phone</h3>
<p>${member.phone}</p>
</#if>

<#assign all = member.address!"" + member.zip!"" + member.city!"" + member.country!"" >
<#if all?has_content>
  <h3>Address</h3>
  <p>
  <#list [member.address!, member.zip!, member.city!, member.country!] as k>
    <#if k?has_content>
    ${k}<#if k_has_next>, </#if>
    </#if>
  </#list>
  </p>
</#if>

<#if (member.contacts?size>0) >
  <#-- <h3>Contacts</h3> -->
  <@common.contactList contacts=member.contacts/>
</#if>