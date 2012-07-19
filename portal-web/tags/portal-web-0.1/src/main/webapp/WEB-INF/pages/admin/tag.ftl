          <div id="newone">
          <@s.form action="organization/add/endpoint/step" id="tagForm">
            <div class="field">          
              <p>NAMESPACE</p>
              <@s.textfield name="tag.namespace" value="${(tag!).namespace!}" size="20" maxlength="50" />
              <@s.fielderror fieldName="tag.namespace"/>
            </div>                
            <div class="field">
              <p>PREDICATE</p>
              <@s.textfield name="tag.predicate" value="${(tag!).predicate!}" size="20" maxlength="50" />
              <@s.fielderror fieldName="tag.predicate"/>
            </div>                                 
            <div class="field">
              <p>VALUE</p>
              <@s.textfield name="tag.value" value="${(tag!).value!}" size="20" maxlength="50" />
              <@s.fielderror fieldName="tag.value"/>
            </div>                                     
               </@s.form>               
          </div>