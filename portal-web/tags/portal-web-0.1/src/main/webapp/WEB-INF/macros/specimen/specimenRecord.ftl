<#--
	Construct a Type Specimen record. Parameter determines if it is shown as a search result or on species detail page.
-->
<#macro record ts showAsSearchResult=false>
  <#if showAsSearchResult>
  <div class="result">
    <h2>
      <strong>
        <#include "/WEB-INF/macros/specimen/specimenRecordTop.ftl">
      </strong>
      <span class="note"></span>
    </h2>

    <div class="footer">
      <#include "/WEB-INF/macros/specimen/specimenRecordBottom.ftl">
    </div>
  </div>
    <#else>
    <div>
      <p class="no_bottom">
        <#include "/WEB-INF/macros/specimen/specimenRecordTop.ftl">
    <#include "/WEB-INF/macros/specimen/specimenRecordBottom.ftl">
      </p>
    </div>
  </#if>
</#macro>