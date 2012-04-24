          <@s.form action="dataset/add/step">
            <#include "network_entity.ftl">           
	        
            <table>
            <div id="tempContacts">...</div>
            </table>
             
            <div class="field">
              <p>Owning Organization</p>
              <!-- TODO: all organizations still need to be loaded up. Service class can't return full list of organizations.  -->
              <!-- Action class can page through results and consolidate a list of all organizations.  -->
              <@s.select name="member.owningOrganizationKey" value="'${(member!).owningOrganizationKey!}'" list="organizations" 
               listKey="key" listValue="title" headerKey="" headerValue="Choose an organization"/>
               <@s.fielderror fieldName="member.owningOrganizationKey"/>
            </div>       
            
            <div class="field">
              <p>Hosting Organization</p>
              <!-- TODO: all organizations still need to be loaded up. Service class can't return full list of organizations.  -->
              <!-- Action class can page through results and consolidate a list of all organizations.  -->
              <@s.select name="member.hostingOrganizationKey" value="'${(member!).hostingOrganizationKey!}'" list="organizations" 
               listKey="key" listValue="title" headerKey="" headerValue="Choose an organization"/>
               <@s.fielderror fieldName="member.hostingOrganizationKey"/>
            </div>        

            <nav><@s.submit title="Add" class="candy_white_button next" value="Add"><span>Save Changes</span></@s.submit></nav>         
          </@s.form>