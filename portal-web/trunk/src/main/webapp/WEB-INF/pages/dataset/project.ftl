<#import "/WEB-INF/macros/dataset/contact.ftl" as contact>
<#if dataset.project?has_content || dataset.contacts?has_content>
<article>
  <header></header>
  <div class="content">

    <#if dataset.project?has_content>

      <h2>${dataset.project.title!"Project"}</h2>

      <div class="left">

        <#if dataset.project.studyAreaDescription?has_content>
          <h3>Study area description</h3>

          <p>${dataset.project.studyAreaDescription}</p>
        </#if>

        <#if dataset.project.designDescription?has_content>
          <h3>Design description</h3>

          <p>${dataset.project.designDescription}</p>
        </#if>

        <#if dataset.project.funding?has_content>
          <h3>Funding</h3>

          <p>${dataset.project.funding}</p>
        </#if>

        <#if dataset.project.contacts?has_content>
          <h3>Project Personnel</h3>
          <ul class="team">
            <#list dataset.project.contacts as per>
              <li>
                <@contact.record con=per />
              </li>
            </#list>
          </ul>
        </#if>
      </div>
    <#else>
      <h2>Project</h2>
    <div class="left">
    </div>
    </#if>

    <div class="right">

    <#if dataset.contacts?has_content>
    <h3>Associated parties</h3>
    <ul class="parties">
    <#list dataset.contacts as ap>
      <li>
        <@contact.record con=ap />
      </li>
      <#-- only show 9 references at max. If we have 10 (index=9) we know there are more to show -->
      <#if ap_index==2>
        <p><a class="more_link, placeholder_temp" href="">see all</a></p>
        <#break />
      </#if>
    </#list>
    </ul>
    </#if>
    </div>

  </div>
  <footer></footer>
</article>
</#if>
