<#import "/WEB-INF/macros/pagination.ftl" as macro>
<html>
<head>
  <title>${dataset.title} - Activity</title>
  
  <link rel="stylesheet" href="<@s.url value='/css/bootstrap-tables.css'/>" type="text/css" media="all"/>  
</head>
<body>
  <#-- Set up the tabs to highlight the info tab, and include a backlink -->
  <#assign tab="activity"/>
  <#include "/WEB-INF/pages/dataset/inc/infoband.ftl">

  <#assign downloadTitle="${action.getResponse().getCount()} download event${(action.getResponse().getCount() == 1)?string('','s')}"/>
  <@common.article id="activity" title="${downloadTitle}">    
      <div class="fullwidth">
        <#if action.getResponse().getCount() gt 0>
          <table class='table table-bordered table-striped'>
            <thead>
            <tr>                            
              <th width="9%">Filter</th>              
              <th width="9%">Date</th>              
              <th width="9%" class='total'># of records</th>
            </tr>    
            </thead>      
            <tbody>
              <#list action.getResponse().getResults()  as downloadUsage>
                <tr>                  
                  <td>
                    <#assign filterMap=action.toHumanReadable(downloadUsage.download.request.predicate)!""/>                                       
                    <table class="table table-bordered table-striped">
                    <#if filterMap?has_content>
                      <#list filterMap?keys as param>
                        <tr>
                          <th><@s.text name="search.facet.${param}" /></th>
                          <td><#list filterMap.get(param) as val><span>${val}</span><#if val_has_next>, </#if></#list></td>
                        </tr>
                      </#list>
                    <#else>
                        <tr>
                          <th>Raw Filter</th>
                          <td>${downloadUsage.download.request.predicate!}</td>
                        </tr>
                    </#if>
                    </table>                    
                  </td>                  
                  <td>
                    ${downloadUsage.download.created?date}
                  </td>                  
                  <td>
                    ${downloadUsage.numberRecords?c}
                  </td>
                </tr>
              </#list>
            </tbody>
          </table>
          <@macro.pagination page=action.getResponse() url=currentUrlWithoutPage/>
        </#if>
      </div>
</@common.article>

</body>
</html>
