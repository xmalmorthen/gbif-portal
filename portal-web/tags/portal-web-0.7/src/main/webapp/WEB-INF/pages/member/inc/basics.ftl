<#import "/WEB-INF/macros/common.ftl" as common>

<div class="left">
    <h3>Full title</h3>
    <p>${member.title}</p>

  <#if member.description?has_content>
    <h3>Description</h3>
    <p>${member.description}</p>
  </#if>

  <#if member.metadataLanguage?has_content>
  <h3>Language of metadata</h3>
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

  <#if (member.contacts?has_content) >
    <@common.contactList contacts=member.contacts columns=3 showAllButton=true/>
  </#if>
</div>

<div class="right">
  <#if member.logoUrl?has_content>
    <div class="logo_holder">
      <img src="<@s.url value='${member.logoUrl}'/>"/>
    </div>
  </#if>

  <h3>Address</h3>
  <@common.address address=member />

  <#if member.homepage?has_content>
    <h3>Website</h3>
    <p><a href="${member.homepage}" target="_blank">${member.homepage}</a></p>
  </#if>

  ${extraRight!}

</div>
