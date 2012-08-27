<#--
 THIS INCLUDE GENERATES THE INFOBAND AND TABS FOR AN OCCURRENCE PAGE
 to select a tab to be highlighted please assign on of the following to the freemarker variable "tab":

 For the usual page
 <#assign tab="info"/>
 <#assign tab="activity"/>
 <#assign tab="stats"/>
 
 And for the verbatim ones
 <#assign tab="info-verbatim"/>
 <#assign tab="activity-verbatim"/>
 <#assign tab="stats-verbatim"/>
-->

<content tag="infoband">
  <h1>${nub.canonicalOrScientificName!} · ${id?c}</h1>

  <h3><@s.text name="enum.basisofrecord.${occ.basisOfRecord!'UNKNOWN'}"/> of
    <#if occ.nubKey??>
      <a href="<@s.url value='/species/${occ.nubKey?c}'/>">${occ.scientificName}</a>
    <#else>
      a name which cant be interpreted.
      Please see the <a href="<@s.url value='/occurrence/${id?c}/verbatim'/>">verbatim version</a> for source details
    </#if>
    from <a href="<@s.url value='/dataset/${dataset.key!}'/>">${dataset.title!"???"}</a> dataset.
  </h3>
</content>

<content tag="tabs">
  <ul class="highlighted">
    <li<#if (tab!"")=="info"> class='selected'<#elseif (tab!"")=="info-verbatim"> class='selected highlighted'</#if>>
      <a href="<@s.url value='/occurrence/${id?c}'/>" title="Information"><span>Information</span></a>
    </li>
    <li<#if (tab!"")=="activity"> class='selected'<#elseif (tab!"")=="activity-verbatim"> class='selected highlighted'</#if>>
      <a href="#" title="Activity"><span>Activity <sup>(2)</sup></span></a>
    </li>
    <li<#if (tab!"")=="stats"> class='selected'<#elseif (tab!"")=="stats-verbatim"> class='selected highlighted'</#if>>
      <a href="#" title="Stats"><span>Stats <sup>(2)</sup></span></a>
    </li>
  </ul>
</content>
