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

<body class="newsroom">

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
                      <#assign queryParams=action.getQueryParams(d.predicate)!""/>
                      <#if queryParams?has_content>
                        <a href="<@s.url value='/occurrence/search?${queryParams}'/>">
                      </#if>
                      <table class="table">
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
                            <td>${d.predicate}</td>
                          </tr>
                      </#if>
                      </table>
                      <#if queryParams?has_content>
                        </a>
                      </#if>
                  </dd>

                  <dt>Status</dt>
                  <dd>
                    <#if d.available>
                        <!-- cfg.wsOccDownload is not public, but needed for authentication. Therefore wsOccDownloadForPublicLink was created which is public -->
                        Ready for <a href="${cfg.wsOccDownloadForPublicLink}occurrence/download/${d.key}.zip">download</a> since ${d.completed?datetime?string.short_medium}
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
