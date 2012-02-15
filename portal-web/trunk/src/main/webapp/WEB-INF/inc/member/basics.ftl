<#import "/WEB-INF/macros/common.ftl" as common>
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

  <h3>Contacts</h3>
  <ul class="team">
   <#list member.contacts as c>
    <li>
      <@common.contact con=c />
    </li>
   </#list>
  </ul>