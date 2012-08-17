<#--
 THIS INCLUDE GENERATES THE INFOBAND AND TABS FOR A SPECIES PAGE
 to select a tab to be highlighted please assign on of the following to the freemarker variable "tab":

 <#assign tab="info"/>
 <#assign tab="activity"/>
 <#assign tab="stats"/>
-->
<content tag="infoband">
  <ul class="breadcrumb">
    <li class="last">${((usage.rank.interpreted)!(usage.rank.verbatim)!"Unranked")?capitalize}</li>
  </ul>

  <h1>${usage.scientificName}</h1>

  <h3>according to <a href="<@s.url value='/dataset/${usage.datasetKey}'/>">${(dataset.title)!"???"}</a></h3>

  <h3>${usage.higherClassification!}</h3>

<#if usage.nub>
  <div class="box">
    <div class="content">
      <ul>
        <li><h4>${usage.numOccurrences}</h4>Occurrences</li>
        <#if usage.rank.interpreted.isSpeciesOrBelow()>
          <li class="last"><h4>${usage.numDescendants}</h4>Infraspecies</li>
        <#else>
          <li class="last"><h4>${usage.numSpecies}</h4>Species</li>
        </#if>
      </ul>
      <a href="#" title="Download Occurrences" class="download candy_blue_button"><span>Download occurrences</span></a>
    </div>
  </div>
</#if>

</content>

<content tag="tabs">
  <ul>
    <li<#if (tab!"")=="info"> class='selected highlighted'</#if>>
      <a href="<@s.url value='/species/${id?c}'/>" title="Information"><span>Information</span></a>
    </li>
    <li<#if (tab!"")=="activity"> class='selected highlighted'</#if>>
      <a href="<@s.url value='/species/${id?c}/activity'/>" title="Activity"><span>Activity <sup>(2)</sup></span></a>
    </li>
    <li<#if (tab!"")=="stats"> class='selected highlighted'</#if>>
      <a href="<@s.url value='/species/${id?c}/stats'/>" title="Stats"><span>Stats <sup>(2)</sup></span></a>
    </li>
  </ul>
</content>
