<#import "/WEB-INF/macros/common.ftl" as common>

<#macro introArticle>
  <@common.article id="overview" title="Introduction" titleRight="Quick links">
  <#nested />
  </@common.article>
</#macro>



<#macro apiTable>
<table class='table table-bordered table-striped table-params'>
    <thead>
    <tr>
        <th width="28%" class='total'>Resource URL</th>
        <th width="15%">Response</th>
        <th width="30%">Description</th>
        <th width="6%">Paging</th>
        <th width="15%">Parameters</th>
    </tr>
    </thead>

    <tbody>
    <#nested />
    </tbody>
</table>
</#macro>

<#macro apiTable_registry>
<table class='table table-bordered table-striped table-params'>
    <thead>
    <tr>
        <th width="20%" class='total'>Resource URL</th>
        <th width="8%" class='total'>Method</th>
        <th width="15%">Response</th>
        <th width="26%">Description</th>
        <th width="4%">Auth</th>
        <th width="6%">Paging</th>
        <th width="15%">Parameters</th>
    </tr>
    </thead>

    <tbody>
      <#nested />
    </tbody>
</table>
</#macro>


<#macro trow url resp httpMethod="" respLink="#" paging=false params=[]>
<tr>
    <td>${url} <small>${httpMethod?upper_case}</small></td>
    <td><a href="http://api.gbif.org/${respLink}" target="_blank">${resp}</a></td>
    <td><#nested/></td>
    <td>${paging?string}</td>
    <td><#list params as p><a href='#p${p}'>${p}</a><#if p_has_next>, </#if></#list></td>
</tr>
</#macro>

<#macro trow_registry url resp httpMethod="" respLink="#" paging=false params=[] authRequired=false>
<tr>
    <td>${url}</td>
    <td>${httpMethod?upper_case}</td>
    <td><#if httpMethod?upper_case == "GET"><a href="http://api.gbif.org${respLink}" target="_blank">${resp}</a></#if></td>
    <td><#nested/></td>
    <td>${authRequired?string}</td>
    <td>${paging?string}</td>
    <td><#list params as p><a href='#p${p}'>${p}</a><#if p_has_next>, </#if></#list></td>
</tr>
</#macro>


<#macro paramArticle params>
<@common.article id="parameters" title="Query parameters explained">
  <div class="left">
      <dl>
          <#list params?keys as k>
            <a name="p_${k}"></a>
            <dt>${k}</dt>
            <dd>${params[k]}</dd>
          </#list>
      </dl>
  </div>
</@common.article>
</#macro>