<#--
 Generates the taxonomic browser
-->

<div id="taxonomicBrowser">
  <div class="breadcrumb">
  <#if usage??>
    <li spid="-1" cid="${usage.checklistKey}"><a href="#">All</a></li>
    <#assign classification=usage.higherClassificationMap />
    <#list classification?keys as key>
      <li spid="${key?c}"><a href="#">${classification.get(key)}</a></li>
    </#list>
    <li class="last" spid="${usage.key?c}">${usage.canonicalOrScientificName!"???"}</li>
    <#else>
      <li spid="-1" cid="${id}"><a href="#">All</a></li>
  </#if>
  </div>
  <div class="inner">
    <div class="sp">
      <ul>
      </ul>
    </div>
  </div>
  <div class="loadingTaxa"><span></span></div>
</div>
  