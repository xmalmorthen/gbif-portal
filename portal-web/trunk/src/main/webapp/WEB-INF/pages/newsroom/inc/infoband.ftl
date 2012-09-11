<#import "/WEB-INF/macros/common.ftl" as common>
<#--
 THIS INCLUDE GENERATES THE INFOBAND AND TABS FOR A SPECIES PAGE
 to select a tab to be highlighted please assign on of the following to the freemarker variable "tab":

 <#assign tab="home"/>
 <#assign tab="news"/>
 <#assign tab="uses"/>
-->
<content tag="infoband">
  <h1>GBIF Newsroom</h1>
  <h3>Latest news about GBIF's activities, use of data, events and oppertunities</h3>

  <#if (tab!"")=="home">
    <div class="box">
      <div class="content">
        <ul>
          <li><h4>GBits, the GBIF newsletter</h4></li>
        </ul>
        <a href="#" title="Download PDF" class="download candy_blue_button"><span>Download PDF</span></a>
      </div>
    </div>
  </#if>
</content>

<content tag="tabs">
  <ul>
    <li<#if (tab!"")=="home"> class='selected'</#if>>
      <a href="<@s.url value='/newsroom/'/>" title="Summary"><span>Summary</span></a>
    </li>
    <li<#if (tab!"")=="news"> class='selected'</#if>>
      <a href="<@s.url value='/newsroom/news'/>" title="News"><span>News</span></a>
    </li>
    <li<#if (tab!"")=="uses"> class='selected'</#if>>
      <a href="<@s.url value='/newsroom/uses'/>" title="Uses of data"><span>Uses of data</span></a>
    </li>
    <li>
      <a href="#" title="Oppertunities"><span>Oppertunities</span></a>
    </li>
    <li>
      <a href="#" title="Events"><span>Events</span></a>
    </li>
  </ul>
</content>
