<#import "/WEB-INF/macros/common.ftl" as common>
<#if contacts?has_content>              
  <h3>Contacts</h3>
  <ul class="team">
    <!-- This div's id name cant be changed as it is referenced by JS functionality (contact_form.js)  -->
    <div id="contactSuccess"/>
    <#list contacts! as c>
      <li>
        <#if admin>
          <#if id?has_content> <!-- if {id} has content, means the user is able to edit directly an existing contact -->
            <button class="editContact" componentIndex="${c_index}" agentKey="${id}">EDIT</button>
          </#if>
        </#if>      
        <img src="<@s.url value='/img/minus.png'/>">
        <@common.contact con=c />
      </li>
    </#list>
  </ul>
</#if>