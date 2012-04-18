<#if ( dataset.citation?has_content && (dataset.citation.identifier?has_content || dataset.citation.text?has_content)) || (dataset.bibliographicCitations?size>0) >
<article id="references">
  <header></header>
  <div class="content">
    <h2><a name="citations">Citations</a></h2>

    <div class="left">
      <#if dataset.citation.identifier?has_content || dataset.citation.text?has_content>
        <h3>Citation</h3>

        <p>
          <#if dataset.citation.identifier?has_content && dataset.citation.text?has_content>
            <a href="${dataset.citation.identifier}">${dataset.citation.text}</a>
          <#elseif dataset.citation.identifier?has_content>
            <a href="${dataset.citation.identifier}">${dataset.citation.identifier}</a>
          <#elseif dataset.citation.text?has_content>
          ${dataset.citation.text}
          </#if>
        </p>

      </#if>

      <#if (dataset.bibliographicCitations?size>0)>
        <h3>Bibliographic Citations</h3>
        <#list dataset.bibliographicCitations as ref>
          <p>
            <#if ref.identifier?has_content><a href="${ref.identifier}">${ref.text}</a><#else>${ref.text}</#if>
          </p>
        <#-- only show 9 references at max. If we have 10 (index=9) we know there are more to show -->
          <#if ref_index==7>
            <p><a class="more_link, placeholder_temp" href="">see all</a></p>
            <#break />
          </#if>
        </#list>
      </#if>
    </div>

  </div>
  <footer></footer>
</article>
</#if>