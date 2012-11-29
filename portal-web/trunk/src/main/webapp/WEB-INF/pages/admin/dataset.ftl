            <#include "network_entity.ftl">           
            
            <div class="field">
              <p>Owning Organization</p>
              <!-- TODO: all organizations still need to be loaded up. Service class can't return full list of organizations.  -->
              <!-- Action class can page through results and consolidate a list of all organizations.  -->
              <@s.select name="member.owningOrganizationKey" value="'${(member!).owningOrganizationKey!}'" list="organizations" 
               listKey="key" listValue="title" headerKey="" headerValue="Choose an organization"/>
               <@s.fielderror fieldName="member.owningOrganizationKey"/>
            </div>       
            <p/>
            <div class="field">
              <p>Hosting Organization</p>
              <!-- TODO: all organizations still need to be loaded up. Service class can't return full list of organizations.  -->
              <!-- Action class can page through results and consolidate a list of all organizations.  -->
              <@s.select name="member.hostingOrganizationKey" value="'${(hostingOrganization!).key!}'" list="organizations" 
               listKey="key" listValue="title" headerKey="" headerValue="Choose an organization"/>
               <@s.fielderror fieldName="member.hostingOrganizationKey"/>
            </div>       
			<p/>

            <#include "components.ftl">