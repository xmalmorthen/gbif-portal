<#--
 THIS INCLUDE GENERATES THE INFOBAND AND TABS FOR A MEMBER PAGE
 to select a tab to be highlighted please assign on of the following to the freemarker variable "tab":

 <#assign tab="info"/>
 <#assign tab="activity"/>
 <#assign tab="datasets"/>
 <#assign tab="stats"/>
-->
<content tag="infoband">

  <h1>${common.limit(member.title!"???", 50)}</h1>

  <#if keywords?has_content>
    <h3>
  <#else>
    <h3>
  </#if>
    ${memberType?capitalize}<#if member.homepage?has_content>. More info at:
    <a href="${member.homepage}" target="_blank" title="Homepage">${member.homepage}</a>
  </#if>
  </h3>

  <#if keywords?has_content>
    <ul class="tags">
      <#list keywords as k>
          <li>
              <a href="#" title="${k}">${k}</a>
          </li>
      </#list>
    </ul>
  </#if>
</content>

<content tag="tabs">
  <ul>
    <li<#if (tab!"")=="info"> class='selected'</#if>>
      <a href="<@s.url value='/${memberType?lower_case}/${id}'/>" title="Information"><span>Information</span></a>
    </li>
    <li<#if (tab!"")=="activity"> class='selected highlighted'</#if>>
      <a href="#" title="Activity"><span>Activity</span></a>
    </li>
    <li<#if (tab!"")=="stats"> class='selected highlighted'</#if>>
      <a href="#" title="Stats"><span>Stats</span></a>
    </li>
  </ul>
</content>
