            <div class="field">
              <p>ADDRESS</p>
                <@s.textfield name="member.address" value="${(member!).address!}" size="20" maxlength="10" />
                <@s.fielderror fieldName="member.address"/>
            </div>
            
            <div class="field">
              <p>CITY</p>
                <@s.textfield name="member.city" value="${(member!).city!}" size="20" maxlength="10" />
                <@s.fielderror fieldName="member.city"/>
            </div>         
            
            <div class="field">
              <p>ZIP</p>
                <@s.textfield name="member.zip" value="${(member!).zip!}" size="20" maxlength="10" />    
                <@s.fielderror fieldName="member.zip"/>            
            </div>       
             
            <div class="field">
              <p>PHONE</p>
                <@s.textfield name="member.phone" value="${(member!).phone!}" size="20" maxlength="10" />  
                <@s.fielderror fieldName="member.phone"/>                 
            </div>    

            <div class="field">
              <p>E-MAIL</p>
                <@s.textfield name="member.email" value="${(member!).email!}" size="20" maxlength="10" />  
                <@s.fielderror fieldName="member.email"/>                 
            </div> 
                                      
            <div class="field">
              <p>COUNTRY</p>
              <@s.select name="member.country" value="'${((member!).country!).iso2LetterCode!}'" list="officialCountries" 
               listKey="iso2LetterCode" listValue="title" headerKey="" headerValue="Choose a country"/>
               <@s.fielderror fieldName="member.country"/>
            </div> 
            
            <div class="field">
              <p>LATITUDE</p>
                <@s.textfield name="member.latitude" value="${(member!).latitude!}" size="20" maxlength="10" />
                <@s.fielderror fieldName="member.latitude"/>
            </div> 
            
            <div class="field">
              <p>LONGITUDE</p>
                <@s.textfield name="member.longitude" value="${(member!).longitude!}" size="20" maxlength="10" />
                <@s.fielderror fieldName="member.longitude"/>
            </div>    
            
            <div class="field">
              <p>CONTACTS
                <ul class="team">
                  <#list contacts! as c>
                  <li>
                    <img src="<@s.url value='/img/minus.png'/>">
                      <@common.contact con=c />
                  </li>
                </#list>
              </ul>
            </div>                                        