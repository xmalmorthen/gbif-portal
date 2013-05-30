<#import "/WEB-INF/macros/common.ftl" as common>
<#--
 THIS INCLUDE GENERATES THE INFOBAND AND TABS FOR A COUNTRY PAGE
 to select a tab to be highlighted please assign on of the following to the freemarker variable "tab":

 <#assign tab="summary"/>
 <#assign tab="about"/>
 <#assign tab="publishing"/>
 <#assign tab="participation"/>
 <#assign tab="news"/>
 <#assign tab="use"/>

 To show yellow tabs instead of default grey ones please assign:
  <#assign tabhl=true />
-->

<content tag="infoband">
  <h1>${country.title}</h1>

  <#if node??>
    <h3>A GBIF Node<#if node.since??> since ${node.since}</#if></h3>
  </#if>

  <#--
  <div class="box">
    <div class="content">
      <img src="http://www.geonames.org/flags/x/${id?lower_case}.gif"/>
    </div>
  </div>
  -->
</content>

<content tag="tabs">
  <#if tabhl!false>
    <#assign hl="highlighted" />
  </#if>
  <ul class="${hl!}">
    <li<#if (tab!"")=="summary"> class='selected ${hl!}'</#if>>
      <a href="<@s.url value='/country/${id}'/>" title="Summary"><span>Summary</span></a>
    </li>
    <li<#if (tab!"")=="about"> class='selected ${hl!}'</#if>>
      <a href="<@s.url value='/country/${id}/about'/>" title="About"><span>Data About</span></a>
    </li>
    <li<#if (tab!"")=="publishing"> class='selected ${hl!}'</#if>>
      <a href="<@s.url value='/country/${id}/publishing'/>" title="Publishing"><span>Data Publishing</span></a>
    </li>
    <li<#if (tab!"")=="participation"> class='selected ${hl!}'</#if>>
      <a href="<@s.url value='/country/${id}/participation'/>" title="Participation"><span>Participation</span></a>
    </li>
    <li<#if (tab!"")=="news"> class='selected ${hl!}'</#if>>
      <a href="<@s.url value='/country/${id}/news'/>" title="News"><span>News</span></a>
    </li>
    <li<#if (tab!"")=="use"> class='selected ${hl!}'</#if>>
      <a href="#" title="Data Use"><span>Data Use</span></a>
    </li>
  </ul>
</content>
