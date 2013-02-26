<#import "/WEB-INF/macros/common.ftl" as common>
<#--
 THIS INCLUDE GENERATES THE INFOBAND AND TABS FOR A DATASET PAGE
 to select a tab to be highlighted please assign on of the following to the freemarker variable "tab":

 <#assign tab="info"/>
 <#assign tab="constituents"/>
 <#assign tab="activity"/>
 <#assign tab="discussion"/>

 To show yellow tabs instead of default grey ones please assign:
  <#assign tabhl=true />

-->
<content tag="infoband">

  <h1>${common.limit(dataset.title, 36)}</h1>
<#assign keywords=dataset.keywords />
<#if keywords?has_content>
  <h3 class="separator">
<#else>
<h3>
</#if>
    <@s.text name="enum.datasettype.${dataset.type!'UNKNOWN'}"/>
    <#if owningOrganization??>
      published by <a href="<@s.url value='/organization/${owningOrganization.key}'/>">${owningOrganization.title!"Unknown"}</a>
    </#if>
  </h3>

<#-- The length of characters is maintained, so that it doesn't overflow. Where it is long, the page flag is set to render the full keywords under the details  -->
<#assign keywords=dataset.keywords />
<#assign keywordTextLength=0 />
<#assign keywordsTruncatedInTitle=false />
<#if keywords?has_content>
<ul class="tags">
  <#list keywords as k>
    <#if keywordTextLength + k?length &gt; 330>
      <li><a href="#keywords">more…</a></li>
      <#assign keywordsTruncatedInTitle=true />
      <#break>
    </#if>
    <li>
      <a href="<@s.url value='/dataset/search?q=${k}'/>">${k}</a>
    </li>
    <#assign keywordTextLength=keywordTextLength + k?length />
  </#list>
</ul>
</#if>

<#if dataset.type! == "OCCURRENCE">
<div class="box">
  <div class="content">
    <ul>
      <li class="single"><h4>${numOccurrences!0}</h4>Occurrences</li>
    </ul>
    <a href="<@s.url value='/occurrence/search?datasetKey=${id!}'/>" title="View occurrences" class="candy_blue_button"><span>View occurrences</span></a>
  </div>
</div>
</#if>
<#if dataset.type! == "CHECKLIST">
  <div class="box">
    <div class="content">
      <ul>
        <li><h4>${(metrics.getCountByRank(speciesRank))!"?"}</h4>Species</li>
        <li class="last"><h4>${(metrics.countIndexed)!"?"}</h4>Taxa</li>
      </ul>
      <a href="<@s.url value='/species/search?dataset_key=${id!}'/>" title="View species" class="candy_blue_button"><span>View species</span></a>
    </div>
  </div>
</#if>

</content>


<content tag="tabs">
  <#if tabhl!false>
    <#assign hl="highlighted" />
  </#if>
  <ul class="${hl!}">
    <li<#if (tab!)=="info"> class='selected ${hl!}'</#if>>
      <a href="<@s.url value='/dataset/${id!}'/>" title="Information"><span>Information</span></a>
    </li>
    <#if dataset.hasConstituents()>
      <li<#if (tab!)=="constituents"> class='selected ${hl!}'</#if>>
        <a href="#" title="Constituents"><span>Constituents</span></a>
      </li>
    </#if>
    <#if dataset.type! != "METADATA">
    <li<#if (tab!)=="stats"> class='selected ${hl!}'</#if>>
      <a href="<@s.url value='/dataset/${id!}/stats'/>" title="Stats"><span>Stats</span></a>
    </li>
    </#if>
    <li<#if (tab!)=="activity"> class='selected ${hl!}'</#if>>
      <a href="#" title="Activity"><span>Activity</span></a>
    </li>
    <li<#if (tab!)=="discussion"> class='selected ${hl!}'</#if>>
      <a href="#" title="Discussion"><span>Discussion</span></a>
    </li>
  </ul>
</content>
