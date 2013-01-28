<#import "/WEB-INF/macros/common.ftl" as common>
<#--
 THIS INCLUDE GENERATES THE INFOBAND AND TABS FOR A USER PAGE
 to select a tab to be highlighted please assign on of the following to the freemarker variable "tab":

 <#assign tab="account"/>
 <#assign tab="downloads"/>
 <#assign tab="lists"/>

 To show yellow tabs instead of default grey ones please assign:
  <#assign tabhl=true />
-->

<content tag="infoband">
  <h1>${currentUser.fullName!currentUser.name}</h1>
</content>

<content tag="tabs">
  <#if tabhl!false>
    <#assign hl="highlighted" />
  </#if>
  <ul class="${hl!}">
    <li<#if (tab!"")=="account"> class='selected ${hl!}'</#if>>
      <a href="<@s.url value='/user/'/>" title="Account"><span>Account</span></a>
    </li>
    <li<#if (tab!"")=="downloads"> class='selected ${hl!}'</#if>>
      <a href="<@s.url value='/user/downloads'/>" title="Downloads"><span>Downloads</span></a>
    </li>
    <li<#if (tab!"")=="lists"> class='selected ${hl!}'</#if>>
      <a href="<@s.url value='/user/lists'/>" title="Name Lists"><span>Name Lists</span></a>
    </li>
  </ul>
</content>
