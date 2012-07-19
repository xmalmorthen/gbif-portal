          <div id="newone">
          <@s.form action="organization/add/identifier/step" id="identifierForm">
            <div class="field">
              <p>TYPE</p>
              <@s.select name="identifier.type" value="'${(identifier.type!).interpreted!}'" list="identifierTypes" 
               listKey="key" listValue="value" headerKey="" headerValue="Choose a type"/>
               <@s.fielderror fieldName="identifier.type"/>
            </div>   
            <div class="field">
              <p>IDENTIFIER</p>
              <@s.textfield name="identifier.identifier" value="${(identifier!).identifier!}" size="20" maxlength="50" />
              <@s.fielderror fieldName="identifier.identifier"/>
            </div>                                                 
               </@s.form>               
          </div>