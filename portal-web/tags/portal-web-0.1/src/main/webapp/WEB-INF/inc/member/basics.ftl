<#import "/WEB-INF/macros/common.ftl" as common>
  <script type="text/javascript" src="<@s.url value='/js/vendor/jquery-1.7.1.min.js'/>"></script>
  <script type="text/javascript" src="<@s.url value='/js/custom/contact_form.js'/>"></script>  
  <h3>Description</h3>
  <p>${member.description!"&nbsp;"}</p>

  <h3>Address</h3>
  <p>
  <#assign parts = ["${member.address!}","${member.zip!}","${member.city!}","${member.country!}" ]>
  <#list parts as k>
    <#if k?has_content>
    ${k}<#if k_has_next>, </#if>
    </#if>
  </#list>
   &nbsp;
  </p>
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