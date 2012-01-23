<#--
 Generates the taxonomic browser
-->

<div id="taxonomy">
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
        <#if children?? && (children?size > 0)>
          <#list children as usage>
            <li species="${usage.numSpecies?c}" children="${usage.numChildren?c}">
              <span spid="${usage.key?c}" spname="${usage.canonicalOrScientificName!"???"}">${usage.canonicalOrScientificName!"???"}
                <span class="rank"><@s.text name="enum.rank.${usage.rank!'unknown'}" /></span>
              </span>
              <a href="<@s.url value='/species/${usage.key?c}'/>">see details</a>
            </li>
          </#list>
        </#if>
      </ul>
    </div>
  </div>
  <div class="loadingTaxa"><span></span></div>
</div>
  