			<div class="field">
              <p>TITLE</p>
                <@s.textfield name="organization.title" value="${(organization!).title!}" size="20" maxlength="10" />
                <@s.fielderror fieldName="organization.title"/>
            </div>

            <div class="field">
              <p>DESCRIPTION</p>
              <@s.textarea name="organization.description" value="${(organization!).description!}" rows="2" cols="20" />
              <@s.fielderror fieldName="organization.description"/>
            </div>

            <div class="field">
              <p>ADDRESS</p>
                <@s.textfield name="organization.address" value="${(organization!).address!}" size="20" maxlength="10" />
                <@s.fielderror fieldName="organization.address"/>
            </div>
            
            <div class="field">
              <p>CITY</p>
                <@s.textfield name="organization.city" value="${(organization!).city!}" size="20" maxlength="10" />
                <@s.fielderror fieldName="organization.city"/>
            </div>         
            
            <div class="field">
              <p>ZIP</p>
                <@s.textfield name="organization.zip" value="${(organization!).zip!}" size="20" maxlength="10" />    
                <@s.fielderror fieldName="organization.zip"/>            
            </div>       
             
            <div class="field">
              <p>PHONE</p>
                <@s.textfield name="organization.phone" value="${(organization!).phone!}" size="20" maxlength="10" />  
                <@s.fielderror fieldName="organization.phone"/>                 
            </div>    

            <div class="field">
              <p>E-MAIL</p>
                <@s.textfield name="organization.email" value="${(organization!).email!}" size="20" maxlength="10" />  
                <@s.fielderror fieldName="organization.email"/>                 
            </div> 
                                      
            <div class="field">
              <p>COUNTRY</p>
              <@s.select name="organization.country" value="'${((organization!).country!).iso2LetterCode!}'" list="officialCountries" 
               listKey="iso2LetterCode" listValue="title" headerKey="" headerValue="Choose a country"/>
               <@s.fielderror fieldName="organization.country"/>
            </div>        
            
            <div class="field">
              <p>HOMEPAGE</p>
                <@s.textfield name="organization.homepage" value="${(organization!).homepage!}" size="20" maxlength="60" />
                <@s.fielderror fieldName="organization.homepage"/>
            </div>                
            
            <div class="field">
              <p>LOGO URL</p>
                <@s.textfield name="organization.logoURL" value="${(organization!).logoURL!}" size="20" maxlength="60" />
                <@s.fielderror fieldName="organization.logoURL"/>
            </div>