<#import "/WEB-INF/macros/pagination.ftl" as paging>
<#import "/WEB-INF/macros/common.ftl" as common>
<html xmlns="http://www.w3.org/1999/html" xmlns="http://www.w3.org/1999/html">
<head>
  <title>Your Downloads</title>
  <style type="text/css">
      .result table th {
          font-variant: small-caps;
          padding-right: 10px;
      }
      .result table tr {
          padding-top: 5px;
      }
  </style>
</head>

<body class="search">

<#assign tab="downloads"/>
<#include "/WEB-INF/pages/user/inc/infoband.ftl">

  <@common.article title="Your Downloads" class="results">
    <div class="fullwidth">
      <#list page.results as d>
        <div class="result">
          <h2><strong>${d.key}</strong></h2>

          <div class="footer">
              <dl>
                  <dt>Filter</dt>
                  <dd>
                      <#assign filterMap=action.getHumanFilter(d.predicate)!""/>
                      <#if filterMap?has_content>
                        <#assign queryParams=action.getQueryParams(d.predicate)/>
                        <a href="<@s.url value='/occurrence/search?${queryParams}'/>">
                          <table class="table">
                            <#list filterMap?keys as param>
                              <tr>
                                  <th><@s.text name="search.facet.${param}" /></th>
                                  <td><#list filterMap.get(param) as val><span>${val}</span><#if val_has_next>, </#if></#list></td>
                              </tr>
                            </#list>
                          </table>
                        </a>
                      <#else>
                        <table class="table">
                          <tr>
                              <th>Unreadable Filter</th>
                              <td>${d.predicate}</td>
                          </tr>
                        </table>
                      </#if>
                  </dd>

                  <dt>Status</dt>
                  <dd>
                    <#if d.available>
                        Ready for <a href="${cfg.wsOccDownload}occurrence/download/${d.key}.zip">download</a> since ${d.completed?datetime?string.short_medium}
                    <#else>
                        Still running. Do you want to <a href="<@s.url value='/user/cancel?key=${d.key}'/>">cancel</a> the query?
                    </#if>
                  </dd>

                  <dt>Created</dt>
                  <dd>${d.created?datetime?string.full}</dd>
              </dl>
          </div>

        </div>
      </#list>

      <div class="footer">
        <@paging.pagination page=page url=currentUrl/>
      </div>
    </div>
  </@common.article>

</body>
</html>
