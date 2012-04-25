            <#include "network_entity.ftl">           
            <#include "member.ftl">                          
	        
            <table>
            <div id="tempContacts">...</div>
            </table>
             
            <div class="field">
              <p>GBIF Endorsing Node</p>
              <!-- TODO: all nodes still need to be loaded up. Service class can't return full list of nodes.  -->
              <!-- Action class can page through results and consolidate a list of all nodes.  -->
              <@s.select name="member.endorsingNodeKey" value="'${(member!).endorsingNodeKey!}'" list="nodes" 
               listKey="key" listValue="title" headerKey="" headerValue="Choose a node"/>
               <@s.fielderror fieldName="member.endorsingNodeKey"/>
            </div>          