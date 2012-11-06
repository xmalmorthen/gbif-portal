<#import "/WEB-INF/macros/common.ftl" as common>
<#if admin>
  <script type="text/javascript" src="<@s.url value='/js/custom/contact_form.js'/>"></script>
</#if>

  <h3>Full Title</h3>
  <p>${member.title}</p>

<#if member.description?has_content>
  <h3>Description</h3>
  <p>${member.description}</p>
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

<div id="dialog-contact" title="Edit contact"></div>
<div id="entityContacts">
  <#if member.contacts?has_content>
    <h3>Contacts</h3>
    <ul class="team">
     <#list member.contacts as c>
      <li>
        <#if admin>
          <button class="editContact" componentIndex="${c_index}" agentKey="${id}">EDIT</button>
          <img src="<@s.url value='/img/minus.png'/>">          
        </#if>
        <@common.contact con=c />
      </li>
     </#list>
    </ul>
  </#if>
</div>