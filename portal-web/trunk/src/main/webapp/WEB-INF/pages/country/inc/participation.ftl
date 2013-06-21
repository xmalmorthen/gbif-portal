<#import "/WEB-INF/macros/common.ftl" as common>

<@common.article id="participation" title="GBIF Participant Information" titleRight="Node Address">
    <div class="left">
      <h3>Member Status</h3>
  <#if node??>
      <p><@s.text name="enum.participantstatus.${node.participationStatus!}"/></p>

      <#if node.participantSince??>
        <h3>GBIF Participant Since</h3>
        <p>${node.participantSince}</p>
      </#if>

      <h3>GBIF Region</h3>
      <p><@s.text name="enum.region.${node.gbifRegion!}"/></p>

      <#if node.headOfDelegation??>
        <h3>Head of Delegation</h3>
        <@common.contact node.headOfDelegation />
      </#if>

      <#if node.nodeManagers?has_content>
        <h3>Node Manager<#if node.nodeManagers gt 1>s</#if></h3>
        <@common.contactList node.nodeManagers />
      </#if>

      <#if (showDescription!false) && node.description?has_content>
        <h3>Description</h3>
        <p>${node.description}</p>
      </#if>

  <#else>
      <p>None</p>
  </#if>
    </div>

    <div class="right">
      <div class="logo_holder">
        <#if node?? && node.logoURL?has_content>
            <img src="${node.logoURL}"/>
        </#if>
      </div>

      <#if node??>
        <h3>Address</h3>
        <p>${node.organizationName!}</p>
        <@common.address address=node />

        <#if node.homepage?has_content>
          <h3>Website</h3>
          <p><a href="${node.homepage}">${node.homepage}</a></p>
        </#if>
      </#if>
    </div>
</@common.article>