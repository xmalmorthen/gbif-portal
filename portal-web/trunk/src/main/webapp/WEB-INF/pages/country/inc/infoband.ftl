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
    <h3>A GBIF Node since ${node.since}</h3>
  </#if>

  <div class="box">
    <div class="content">
      <ul>
        <li class="last"><h4>${numAbout}</h4>Occurrences In ${country.title}</li>
      </ul>
      <a href="<@s.url value='/occurrence/search?country=${id}'/>" title="View Occurrences" class="candy_blue_button"><span>View occurrences</span></a>
    </div>
  </div>
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
