<#--
 THIS INCLUDE GENERATES THE INFOBAND AND TABS FOR AN OCCURRENCE PAGE
 to select a tab to be highlighted please assign on of the following to the freemarker variable "tab":

 <#assign tab="info"/>
 <#assign tab="activity"/>
 <#assign tab="stats"/>
-->

<content tag="infoband">
  <ul class="breadcrumb">
    <li><a href="#" title="Explore">Explore</a></li>
    <li class="last"><a href="#" title="Occurrences">Occurrences</a></li>
  </ul>

  <h1>${occ.scientificName!} · ${id?c}</h1>

  <h3>An ${occ.basisOfRecord!"occurrence"} of
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
  <ul>
    <li<#if (tab!"")=="info"> class='selected highlighted'</#if>>
      <a href="<@s.url value='/occurrence/${id?c}'/>" title="Information"><span>Information</span></a>
    </li>
    <li<#if (tab!"")=="activity"> class='selected highlighted'</#if>>
      <a href="<@s.url value='/occurrence/${id?c}/activity'/>" title="Activity"><span>Activity <sup>(2)</sup></span></a>
    </li>
    <li<#if (tab!"")=="stats"> class='selected highlighted'</#if>>
      <a href="<@s.url value='/occurrence/${id?c}/stats'/>" title="Stats"><span>Stats <sup>(2)</sup></span></a>
    </li>
  </ul>
</content>
