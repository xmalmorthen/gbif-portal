<div class="field" id="entityContacts">
  <#if contacts?has_content>
    CONTACTS<p/>
      <ul class="team">
        <#list contacts! as c>
          <li>
            <img src="<@s.url value='/img/minus.png'/>">
            <@common.contact con=c />
          </li>
        </#list>
      </ul>
  </#if> 
</div>    
<p/>
<div class="field" id="entityEndpoints">
  <#if endpoints?has_content>
    <p>ENDPOINTS</p>
        <#list endpoints! as i>
            <img src="<@s.url value='/img/minus.png'/>">
            <@common.endpoint ep=i />
        </#list>
  </#if>   
</div>
<p/>
<div class="field">
  <p>TAGS <img src="<@s.url value='/img/admin/add.png'/>" name="tagbox" id="tagbox" height="16"></p>
  <div id="currentTags"></div>
  <@s.textfield name="currentTag" size="20" maxlength="50"/>
</div>
<div class="field">
  <p>IDENTIFIER</p>
  <div id="currentIdentifiers"></div>
  <@s.select name="identifierType" list="identifierTypes" 
    listKey="key" listValue="value" headerKey="" headerValue="Choose a type"/>
  <@s.fielderror fieldName="identifierType"/>
  <@s.textfield name="identifierIdentifier" value="${(identifier!).identifier!}" size="20" maxlength="50" />
  <@s.fielderror fieldName="identifierIdentifier"/>
    <img src="<@s.url value='/img/admin/add.png'/>" name="identifierbox" id="identifierbox" height="16">
</div>          