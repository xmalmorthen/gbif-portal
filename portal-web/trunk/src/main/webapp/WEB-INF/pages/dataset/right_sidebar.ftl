<div class="right">
  <#if dataset.logoUrl?has_content>
    <div class="logo_holder">
      <img src="<@s.url value='${dataset.logoUrl}'/>"/>
    </div>
  </#if>

  <h3>Checklist type</h3>
  <#if dataset.type?has_content>
    <p>${dataset.type}</p>
  <#else>
    <p>UNKNOWN</p>
  </#if>

  <h3>Provided by</h3>

  <p><a href="<@s.url value='/member/${dataset.owningOrganizationKey}'/>" title="${dataset.owningOrganization.title!"Unknown"}">${dataset.owningOrganization.title!"Unknown"}</a></p>

  <#if dataset.hostingOrganization?has_content>
    <h3>Hosted by</h3>

    <p><a href="<@s.url value='/member/${dataset.hostingOrganizationKey}'/>" title="${dataset.hostingOrganization.title!"Unknown"}">${dataset.owningOrganization.title!"Unknown"}</a></p>
  </#if>

  <h3>Endorsed by</h3>

  <p class="placeholder_temp"><a href="<@s.url value='/member/123'/>" title="GBIF Germany Participant Node">GBIF Germany Participant Node</a></p>

  <#if (dataset.identifiers?size>0)>
    <h3>Alternative Identifiers</h3>
    <p><#list dataset.identifiers as idt>
      <a class="more_link" href="<@s.url value='${idt.identifier}'/>">${idt.type!"link"}</a><#if idt_has_next>, </#if>
      </#list>
    </p>
  </#if>

  <h3>External Links</h3>
  <ul>
  <#if dataset.homepage?has_content>
    <li><a href="<@s.url value='${dataset.homepage}'/>" title="Dataset homepage">Dataset homepage</a></li>
  </#if>
    <li><a class="placeholder_temp" href="#" title="Author's blog">Author's blog</a></li>
    <li><a class="placeholder_temp" href="#" title="Methodology">A discussion board over the methodology</a></li>
  </ul>

  <h3>Metadata</h3>
  <ul>
    <li class="download">EML file <a class="placeholder_temp" href="#"><abbr>[ENG]</abbr></a> &middot; <a
            href="#"><abbr>[SPA]</abbr></a> &middot; <a href="#"><abbr>[GER]</abbr></a></li>
    <li class="download">ISO 1939 file <a class="placeholder_temp" href="#"><abbr>[ENG]</abbr></a> &middot; <a href="#"><abbr>[SPA]</abbr></a> &middot;
      <a href="#"><abbr>[GER]</abbr></a></li>
  </ul>
</div>