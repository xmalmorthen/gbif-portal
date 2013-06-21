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
    <h3>A <@s.text name="enum.participantstatus.${node.participationStatus!}"/> from <@s.text name="enum.region.${node.gbifRegion!}"/></h3>
  </#if>

</content>

<content tag="tabs">
  <#if tabhl!false>
    <#assign hl="highlighted" />
  </#if>
  <ul class="${hl!}">
    <li<#if (tab!"")=="summary"> class='selected ${hl!}'</#if>>
      <a href="<@s.url value='/country/${isocode}'/>" title="Summary"><span>Summary</span></a>
    </li>
    <li<#if (tab!"")=="about"> class='selected ${hl!}'</#if>>
      <a href="<@s.url value='/country/${isocode}/about'/>" title="About"><span>Data About</span></a>
    </li>
    <li<#if (tab!"")=="publishing"> class='selected ${hl!}'</#if>>
      <a href="<@s.url value='/country/${isocode}/publishing'/>" title="Publishing"><span>Data Publishing</span></a>
    </li>
    <li<#if (tab!"")=="participation"> class='selected ${hl!}'</#if>>
      <a href="<@s.url value='/country/${isocode}/participation'/>" title="Participation"><span>Participation</span></a>
    </li>
    <li<#if (tab!"")=="news"> class='selected ${hl!}'</#if>>
      <a href="<@s.url value='/country/${isocode}/news'/>" title="News"><span>News</span></a>
    </li>
    <li<#if (tab!"")=="use"> class='selected ${hl!}'</#if>>
      <a href="#" title="Data Use"><span>Data Use</span></a>
    </li>
  </ul>
</content>
