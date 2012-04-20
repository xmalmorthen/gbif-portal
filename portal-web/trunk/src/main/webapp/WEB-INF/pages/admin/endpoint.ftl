          <div id="newone">
          <@s.form action="organization/add/endpoint/step" id="contactForm">
            <div class="field">
              <p>TYPE</p>
              <@s.select name="endpoint.type" value="'${(endpoint.type!).interpreted!}'" list="endpointTypes" 
               listKey="key" listValue="value" headerKey="" headerValue="Choose a type"/>
               <@s.fielderror fieldName="contact.type"/>
            </div>   
            <div class="field">
              <p>URL</p>
              <@s.textfield name="endpoint.url" value="${(endpoint!).url!}" size="20" maxlength="50" />
              <@s.fielderror fieldName="endpoint.url"/>
            </div>                
            <div class="field">
              <p>CODE</p>
              <@s.textfield name="endpoint.code" value="${(endpoint!).code!}" size="20" maxlength="50" />
              <@s.fielderror fieldName="endpoint.code"/>
            </div>                                 
            <div class="field">
              <p>DESCRIPTION</p>
              <@s.textfield name="endpoint.description" value="${(endpoint!).description!}" size="20" maxlength="50" />
              <@s.fielderror fieldName="endpoint.description"/>
            </div>                                     
              <@s.submit title="Add" class="candy_white_button next" value="Add contact"><span>Save Changes</span></@s.submit>  
               </@s.form>               
          </div>