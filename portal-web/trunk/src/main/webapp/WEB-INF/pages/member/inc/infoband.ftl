<#--
 THIS INCLUDE GENERATES THE INFOBAND AND TABS FOR A MEMBER PAGE
 to select a tab to be highlighted please assign on of the following to the freemarker variable "tab":

 <#assign tab="info"/>
 <#assign tab="activity"/>
 <#assign tab="datasets"/>
 <#assign tab="stats"/>
-->
<content tag="infoband">
  <ul class="breadcrumb">
    <li>${memberType}</li>
  </ul>

  <h1>${member.title!"???"}</h1>

  <#if member.homepage??>
    <h3 class="separator">More info at: <a href="${member.homepage}" target="_blank" title="Homepage">${member.homepage}</a></h3>
  </#if>

  <ul class="tags">
    <#list member.tags as t>
      <li<#if !t_has_next> class="last"</#if>><a href="#" title="${t.toKeyword()}">${t.toKeyword()}</a></li>
    </#list>
  </ul>
</content>

<content tag="tabs">
  <ul>
    <li<#if (tab!"")=="info"> class='selected highlighted'</#if>>
      <a href="<@s.url value='/${memberType?lower_case}/${id}'/>" title="Information"><span>Information</span></a>
    </li>
    <li<#if (tab!"")=="activity"> class='selected highlighted'</#if>>
      <a href="#" title="Activity"><span>Activity <sup>(2)</sup></span></a>
    </li>
    <li<#if (tab!"")=="datasets"> class='selected highlighted'</#if>>
      <a href="#" title="Datasets"><span>Datasets <sup>(12)</sup></span></a>
    </li>
    <li<#if (tab!"")=="stats"> class='selected highlighted'</#if>>
      <a href="#" title="Stats"><span>Stats <sup>(2)</sup></span></a>
    </li>
  </ul>
</content>