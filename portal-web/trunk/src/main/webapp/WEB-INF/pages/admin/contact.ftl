          <div id="newone">
          <@s.form action="organization/add/contact/step" id="contactForm">
            <div class="field">
              <p>TYPE</p>
              <@s.select name="contact.type" value="'${(contact.type!).interpreted!}'" list="contactTypes" 
               listKey="key" listValue="value" headerKey="" headerValue="Choose a type"/>
               <@s.fielderror fieldName="contact.type"/>
            </div>   
            <div class="field">
              <p>SALUTATION</p>
              <@s.textfield name="contact.salutation" value="${(contact!).salutation!}" size="20" maxlength="50" />
              <@s.fielderror fieldName="contact.salutation"/>
            </div>                                 
            <div class="field">
              <p>FIRST NAME</p>
              <@s.textfield name="contact.firstName" value="${(contact!).firstName!}" size="20" maxlength="50" />
              <@s.fielderror fieldName="contact.firstName"/>
            </div>
            <div class="field">
              <p>LAST NAME</p>
              <@s.textfield name="contact.lastName" value="${(contact!).lastName!}" size="20" maxlength="50" />
              <@s.fielderror fieldName="contact.lastName"/>
            </div>   
            <div class="field">
              <p>POSITION</p>
              <@s.textfield name="contact.position" value="${(contact!).position!}" size="20" maxlength="50" />
              <@s.fielderror fieldName="contact.position"/>
            </div>         
            <div class="field">
              <p>DESCRIPTION</p>
              <@s.textfield name="contact.description" value="${(contact!).description!}" size="20" maxlength="50" />
              <@s.fielderror fieldName="contact.description"/>
            </div>     
            <div class="field">
              <p>ADDRESS</p>
              <@s.textfield name="contact.address" value="${(contact!).address!}" size="20" maxlength="50" />
              <@s.fielderror fieldName="contact.address"/>
            </div>        
            <div class="field">
              <p>CITY</p>
              <@s.textfield name="contact.city" value="${(contact!).city!}" size="20" maxlength="50" />
              <@s.fielderror fieldName="contact.city"/>
            </div>        
            <div class="field">
              <p>PROVINCE</p>
              <@s.textfield name="contact.province" value="${(contact!).province!}" size="20" maxlength="50" />
              <@s.fielderror fieldName="contact.province"/>
            </div>         
            <div class="field">
              <p>POSTAL CODE</p>
              <@s.textfield name="contact.postalCode" value="${(contact!).postalCode!}" size="20" maxlength="50" />
              <@s.fielderror fieldName="contact.postalCode"/>
            </div>                                                    
            <div class="field">
              <p>COUNTRY</p>
              <@s.select name="contact.country" value="'${((contact!).country!).iso2LetterCode!}'" list="officialCountries" 
               listKey="iso2LetterCode" listValue="title" headerKey="" headerValue="Choose a country"/>
               <@s.fielderror fieldName="contact.country"/>
            </div>
            <div class="field">
              <p>EMAIL</p>
              <@s.textfield name="contact.email" value="${(contact!).email!}" size="20" maxlength="50" />
              <@s.fielderror fieldName="contact.email"/>
            </div>         
            <div class="field">
              <p>PHONE</p>
              <@s.textfield name="contact.phone" value="${(contact!).phone!}" size="20" maxlength="50" />
              <@s.fielderror fieldName="contact.phone"/>
            </div>      
            <div class="field">
              <p>ONLINE URL</p>
              <@s.textfield name="contact.onlineUrl" value="${(contact!).onlineUrl!}" size="20" maxlength="50" />
              <@s.fielderror fieldName="contact.onlineUrl"/>
            </div>                                         
               </@s.form>               
          </div>