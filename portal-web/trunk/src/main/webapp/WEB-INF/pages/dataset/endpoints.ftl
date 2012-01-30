<#if dataset.endpoints?has_content>
<article>
  <header></header>
  <div class="content">
    <h2>Endpoints</h2>

    <div class="left">
        <ul>
          <#assign max_url_length = 50>
          <#list dataset.endpoints as point>
            <#if point.type?has_content && point.url?has_content>
              <li><b>${point.type}</b>
                <#if point.type=="EML">
                  <@common.popup message="This is a link to the original metadata document. The metadata may be different from the version that is displayed if it has been updated since the time the dataset was last indexed." title="Warning"/>
                </#if>
                <#if point.isPreferred()>
                  (Preferred)
                </#if>
                  <a href="<@s.url value='${point.url}'/>" title="${point.type}">${common.limit(point.url!"",max_url_length)}</a>
              </li>
            </#if>
          </#list>
        </ul>
    </div>

    <div class="right">
      &nbsp;
    </div>

  </div>
  <footer></footer>
</article>
</#if>

