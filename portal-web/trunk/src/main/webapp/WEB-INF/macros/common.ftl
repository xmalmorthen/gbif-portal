<#--
	Limits a string to a maximun length and adds an ellipsis if longer.
-->
<#function limit x max=100>
  <#assign x=(x!"")?trim/>
  <#if ((x)?length <= max)>
    <#return x>
    <#else>
      <#return x?substring(0, max)+"…" />
  </#if>
</#function>

<#macro usageSource component showChecklistSource=false showChecklistSourceOnly=false>
  <#if showChecklistSourceOnly>
    <#assign source=""/>
    <#else>
      <#assign source=(component.source!"")?trim/>
  </#if>
  <#if showChecklistSource>
    <#assign source><a href='<@s.url value='/species/${component.usageKey?c}'/>'>${(datasets.get(component.datasetKey).title)!"???"}</a><br/>${source}</#assign>
  </#if>
  <#if source?has_content || component.remarks?has_content>
  <a class="sourcePopup" message="${source!}" remarks="${component.remarks!}"></a>
  </#if>
</#macro>

<#macro usageSources components popoverTitle="Sources" showSource=true showChecklistSource=true>
  <#assign source="" />
  <#list components as comp>
    <#assign source>${source!}
    <p>
      <#if showSource>${comp.source!""}<br/></#if>
      <#if showChecklistSource>
        <a href='<@s.url value='/species/${comp.usageKey?c}'/>'>${(datasets.get(comp.datasetKey).title)!"???"}</a>
      </#if>
    </p><br/>
    </#assign>
  </#list>
<a class="sourcePopup" title="${popoverTitle}" message="${source!}"></a>
</#macro>

<#macro popup message remarks="" title="Source">
  <#if message?has_content>
  <a class="sourcePopup" title="${title}" message="${message}" remarks="${remarks!}"></a>
  </#if>
</#macro>

<#macro popover linkTitle popoverTitle>
<a class="popover" title="${popoverTitle}" message="<#nested>">${linkTitle}</a>
</#macro>

<#--
	Construct a Contact. Parameter is the actual contact object.
-->
<#macro contact con>
<strong><h4>${con.firstName!} ${con.lastName!}</h4></strong>
  <#if con.organizationName?has_content>
  <h4 class="position">${con.organizationName!}</h4>
  </#if>
<#-- TODO: change enum as this displays something like "POINT_OF_CONTACT" -->
  <#if con.type?has_content>
    <#if con.type.interpreted?has_content>
    <h4 class="position"><@s.text name="enum.contacttype.${con.type.interpreted}"/></h4>
      <#elseif con.type.verbatim?has_content>
      <h4 class="position verbatim_temp">${con.type.verbatim?string!}</h4>
    </#if>
  </#if>

  <#if con.position?has_content>
  <h4 class="position">${con.position!}</h4>
  </#if>

<address>
  <!-- remember Contact.Country is an Enum, and we want to display the title (ie. Great Britain, not the code GB) -->
  <#assign props = ["${con.address!}","${con.city!}", "${con.province!}", "${con.postalCode!}", "${con.country!title!}" ]>
  <#list props as k>
    <#if k?has_content>
    ${k}<#if k_has_next>, </#if>
    </#if>
  </#list>

  <#if con.email?has_content>
    <a href="mailto:#" title="email">${con.email!}</a>
  </#if>
  <#if con.phone?has_content>
  ${con.phone!}
  </#if>
</address>
</#macro>

<#--
	Construct a Endpoint. Parameter is the actual endpoint object.
-->
<#macro endpoint ep>
<p>
  <b><h4>${ep.type}</h4></b>
  <#if ep.url?has_content>
  ${ep.url!}
  </#if>
</p>
</#macro>

<#--
	Construct a Identifier. Parameter is the actual identifier object.
-->
<#macro identifier i>
<p>
  <b><h4>${i.type}</h4></b>
  <#if i.identifier?has_content>
  ${i.identifier!}
  </#if>
</p>
</#macro>

<#macro citation c>
  ${c.text!}
  <#if c.identifier?has_content><a href="${c.identifier}">${c.identifier}</a></#if>
</#macro>

<#macro enumParagraph enum>
  <#if enum.interpreted?has_content>
  <p>${enum.interpreted?string}</p>
    <#else>
    <p class="verbatim_temp">${enum.verbatim?string!}</p>
  </#if>
</#macro>

<#macro article id="" title="" titleRight="" class="">
<article<#if id?has_content> id="${id}"</#if> class="${class!}">
  <header></header>
  <#if id?has_content>
    <a name="${id}"></a>
  </#if>
  <div class="content">
    <div class="header">
      <#if title?has_content>
        <div class="left">
          <h2>${title}</h2>
        </div>
      </#if>
      <#if titleRight?has_content>
        <div class="right">
          <h2>${titleRight}</h2>
        </div>
      </#if>
    </div>
    <#nested>
  </div>
  <footer></footer>
</article>
</#macro>

<#macro notice title>
<article class="notice">
  <header></header>
  <div class="content">
    <h3>${title!}</h3>
    <#nested>
    <img id="notice_icon" src="<@s.url value='/img/icons/notice_icon.png'/>"/>
  </div>
  <footer></footer>
</article>
</#macro>

<#macro cityAndCountry member>
${member.city!}<#if member.city?has_content && member.country?has_content>, </#if>${member.country!}
</#macro>

