<content tag="infoband">
    <h1>GBIF IPT</h1>
   	<h3>GBIF Integrated Publishing Toolkit, Version 2</h3>

    <div class="box">
        <div class="content">
            <ul>
                <li class="single last"><h4>2.0.5</h4>(Latest version)</li>
            </ul>
            <a href="<@s.url value='https://gbif-providertoolkit.googlecode.com/files/ipt-2.0.5-security-update-1.war'/>" title="View occurrences" class="candy_blue_button"><span>Download</span></a>
        </div>
    </div>
</content>

<content tag="tabs">
  <ul>
    <li<#if (tab!"")==""> class='selected'</#if>><a href="<@s.url value='/ipt'/>" ><span>About</span></a></li>
    <li<#if (tab!"")=="stats"> class='selected'</#if>><a href="<@s.url value='/ipt/stats'/>" ><span>Stats</span></a></li>
    <li<#if (tab!"")=="releases"> class='selected'</#if>><a href="<@s.url value='/ipt/releases'/>" ><span>Releases</span></a></li>
  </ul>
</content>
