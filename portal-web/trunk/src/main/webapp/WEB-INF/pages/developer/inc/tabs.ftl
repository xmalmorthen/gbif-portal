<content tag="infoband">
    <h1>Portal API v1</h1>
    <h3><p>Description for Portal API v1.0</p></h3>
</content>

<content tag="tabs">
  <ul>
    <li<#if (tab!"")=="intro"> class='selected'</#if>><a href="<@s.url value='/developer/introduction'/>" ><span>Introduction</span></a></li>
    <li<#if (tab!"")=="common"> class='selected'</#if>><a href="<@s.url value='/developer/common'/>" ><span>Common</span></a></li>
    <li<#if (tab!"")=="registry"> class='selected'</#if>><a href="<@s.url value='/developer/registry'/>" ><span>Registry</span></a></li>
    <li<#if (tab!"")=="species"> class='selected'</#if>><a href="<@s.url value='/developer/species'/>" ><span>Species</span></a></li>
    <li<#if (tab!"")=="occurrence"> class='selected'</#if>><a href="<@s.url value='/developer/occurrence'/>" ><span>Occurrence</span></a></li>
    <li<#if (tab!"")=="maps"> class='selected'</#if>><a href="<@s.url value='/developer/maps'/>" ><span>Maps</span></a></li>
    <li<#if (tab!"")=="news"> class='selected'</#if>><a href="<@s.url value='/developer/news'/>" ><span>News Feeds</span></a></li>
  </ul>
</content>
