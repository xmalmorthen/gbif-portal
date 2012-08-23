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

  <h3>
  <#assign classification=usage.higherClassificationMap />
  <#list classification?keys as key>
    <a href="#">${classification.get(key)}</a><#if key_has_next>, </#if>
  </#list>
  </h3>

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
      <a href="<@s.url value='/occurrence/search?nubKey=${usage.key?c}'/>" title="View Occurrences" class="download candy_blue_button"><span>View occurrences</span></a>
    </div>
  </div>
</#if>

</content>

<content tag="tabs">
  <ul>
    <li<#if (tab!"")=="info"> class='selected'</#if>>
      <a href="<@s.url value='/species/${id?c}'/>" title="Information"><span>Information</span></a>
    </li>
    <li<#if (tab!"")=="activity"> class='selected'</#if>>
      <a href="#" title="Activity"><span>Activity <sup>(2)</sup></span></a>
    </li>
    <li<#if (tab!"")=="stats"> class='selected'</#if>>
      <a href="#" title="Stats"><span>Stats <sup>(2)</sup></span></a>
    </li>
  </ul>
</content>
