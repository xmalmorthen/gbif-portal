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

      <#if node.contacts?has_content>
        <h3>Contacts</h3>
        <@common.contactList node.contacts />
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
      </#if>
    </div>
</@common.article>