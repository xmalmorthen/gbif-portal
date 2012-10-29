<#import "/WEB-INF/macros/common.ftl" as common>
<#--
This include requires 2 arrays to be set:
 facets: list of facet names just as the SearchParameter enums provide
 seeAllFacets: list of optional facets to always show completely, never via a popup
-->
<#list facets as facetName>
  <#assign facet = action.getSearchParam(facetName)>
  <#assign minCnt = "< " + (facetMinimumCount.get(facet)!0) />
  <#assign displayedFacets = 0>
  <#assign seeAll = false>

    <#if (facetCounts.get(facet)?has_content && (selectedFacetCounts.get(facet)?has_content || facetCounts.get(facet)?size > 1))>
     <div class="refine">
      <h4><@s.text name="search.facet.${facetName}" /></h4>
      <div class="facet">
        <ul id="facetfilter${facetName}">
        <#if selectedFacetCounts.get(facet)?has_content>
          <#list selectedFacetCounts.get(facet) as count>
            <#assign displayedFacets = displayedFacets + 1>
            <li>
              <a href="#" title="${count.title!"Unknown"}">${common.limit( count.title!"Unknown" ,30)}</a> (${count.count!minCnt})
              <input type="checkbox" value="&${facetName?lower_case}=${count.name!}" checked/>
              <input type="hidden" value="${count.name!}" class="facetKey"/>
            </li>
          </#list>
        </#if>
        <#list facetCounts.get(facet) as count>
          <#if seeAllFacets?seq_contains(facetName) && (displayedFacets > MaxFacets)>
            <#assign seeAll=true>
            <#break>
          </#if>
          <#if !(action.isInFilter(facet,count.name))>
            <#assign displayedFacets = displayedFacets + 1>
            <li>
              <a href="#" title="${count.title!"Unknown"}">${common.limit( count.title!"Unknown" ,30)}</a> (${count.count!minCnt})
              <input type="checkbox" value="&${facetName?lower_case}=${count.name!}"/>              
            </li>
          </#if>
        </#list>
        <#if seeAll>
          <li class="seeAllFacet">
            <a class="seeAllLink" href="#">See all...</a>
            <div class="infowindow dialogPopover" style="z-index:100000">
                <div class="lheader"></div>
                <span class="close"></span>
                <div class="content">
                  <h2>Filter by <@s.text name="search.facet.${facetName}" /></h2>

                 <div class="scrollpane">
                   <ul>
                     <#list facetCounts.get(facet) as count>
                    <li>
                    <input type="checkbox" value="&${facetName?lower_case}=${count.name!}" <#if (action.isInFilter(facet,count.name))>checked</#if>>
                     <a href="#" title="${count.title!"Unknown"}">${count.title!"Unknown"}</a> (${count.count!minCnt})
                    </li>
                    </#list>
                   </ul>
                 </div>

               </div>
               <div class="lfooter"></div>
             </div>
          </li>
        </#if>
        </ul>
      </div>
     </div>
    </#if>
</#list>
