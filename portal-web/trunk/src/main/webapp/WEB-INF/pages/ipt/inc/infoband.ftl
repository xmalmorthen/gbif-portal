<content tag="infoband">
    <h1>GBIF IPT</h1>
   	<h3>GBIF Integrated Publishing Toolkit, Version 2</h3>
</content>

<content tag="tabs">
  <ul>
    <li<#if (tab!"")==""> class='selected'</#if>><a href="<@s.url value='/ipt'/>" ><span>About</span></a></li>
    <li<#if (tab!"")=="stats"> class='selected'</#if>><a href="<@s.url value='/ipt/stats'/>" ><span>Stats</span></a></li>
    <li<#if (tab!"")=="releases"> class='selected'</#if>><a href="<@s.url value='/ipt/releases'/>" ><span>Releases</span></a></li>
  </ul>
</content>
