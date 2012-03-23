<#import "/WEB-INF/macros/common.ftl" as common>
<html>
<head>
  <title>Edit Organization - GBIF</title>
  <meta name="menu" content="datasets"/>
    <script type="text/javascript" src="<@s.url value='/js/vendor/jquery-1.7.1.min.js'/>"></script>
    <script type="text/javascript" src="<@s.url value='/js/custom/modal_form.js'/>"></script>
    <style>
      body { font-size: 62.5%; }
      label, input { display:block; }
      input.text { margin-bottom:12px; width:95%; padding: .4em; }
      fieldset { padding:0; border:0; margin-top:25px; }
      h1 { font-size: 1.2em; margin: .6em 0; }
      div#users-contain { width: 350px; margin: 20px 0;  overflow: auto;}
      div#users-contain table { margin: 1em 0; border-collapse: collapse; width: 100%; }
      div#users-contain table td, div#users-contain table th { border: 1px solid #eee; padding: .6em 10px; text-align: left; }
      .ui-dialog .ui-state-error { padding: .3em; }
      .validateTips { border: 1px solid transparent; padding: 0.3em; }
    </style>        
</head>
<body class="dataset">

  <article id="edit" class="tunnel">
    <header></header>
    <div class="content">
      <ul class="breadcrumb">
        <li><h2>Administration</h2></li>
        <li class="active"><h2>Edit Organization</h2></li>
        <li class="last"><h2>Finish</h2></li>
      </ul>

      <p>Please edit the necessary fields:</p>

      <div class="important">
        <div class="top"></div>
        <div class="inner">
          <form>

			<div class="field">
              <p>TITLE</p>
                <input id="title" name="title" type="text" value="${member.title!}"/>
            </div>

            <div class="field">
              <p>DESCRIPTION</p>
              <textarea rows="2" cols="20">${member.description!}</textarea>
            </div>

			<div class="field">
              <p>ADDRESS</p>
                <input id="address" name="address" type="text" value="${member.address!}"/>
            </div>
            
			<div class="field">
              <p>CITY</p>
                <input id="city" name="city" type="text" value="${member.city!}"/>
            </div>         
            
			<div class="field">
              <p>ZIP</p>
                <input id="email" name="email" type="text" value="${member.email!}"/>
            </div>       
             
			<div class="field">
              <p>PHONE</p>
                <input id="phone" name="phone" type="text" value="${member.phone!}"/>
            </div>                  
            
			<div class="field">
              <p>COUNTRY</p>
              <select id="country" class="country" name="country">
                <#list officialCountries as c>
                  <option value="${c.iso2LetterCode}" <#if member.country==c>selected</#if> >${c.title}</option>
                </#list>
              </select>              
            </div>        
            
			<div class="field">
              <p>HOMEPAGE</p>
                <input id="homepage" name="homepage" type="text" value="${member.homepage!}"/>
            </div>                
            
			<div class="field">
              <p>LOGO URL</p>
                <input id="logoUrl" name="logoUrl" type="text" value="${member.logoURL!}"/>
            </div>                                  
	        
            <div class="field">
              <p>CONTACTS  [ <a href="#">add contacts</a> ] - popup to add a new contact
                <ul class="team">
                  <#list member.contacts as c>
                  <li>
                    <img src="<@s.url value='/img/minus.png'/>">
                      <@common.contact con=c />
                  </li>
                </#list>
              </ul>
            </div>
            
            <div class="create_contact">
              <div id="dialog-form" title="Create new contact">
                <p class="validateTips">All form fields are required.</p>
                <form>
                  <fieldset>
                    <label for="name">Salutation</label>
                    <select name="new_contact_salutation" id="new_contact_salutation">
                      <option> - Select The Title - </option>
                      <option value="Mr.">Mr.</option>
                      <option value="Mrs.">Mrs.</option>
                      <option value="Miss">Miss</option>
                      <option value="Ms.">Ms.</option>
                      <option value="Dr.">Dr.</option>
                      <option value="Prof.">Prof.</option>
                      <option value="Rev.">Rev.</option>
                      <option value="Other">Other</option>		
                    </select>		
                    <label for="firstName">First Name</label>
                    <input type="text" name="new_contact_first_name" id="new_contact_first_name" value="" class="text ui-widget-content ui-corner-all" />
                    <label for="lastName">Last Name</label>
                    <input type="text" name="new_contact_last_name" id="new_contact_last_name" value="" class="text ui-widget-content ui-corner-all" />		
                    <label for="type">Type</label>
                    <select name="new_contact_type" id="new_contact_type">
                      <#list contactTypes as c>
                        <option value="${c}"><@s.text name="enum.contacttype.${c}"/></option>
                      </#list>
                    </select>	
                    <label for="position">Position</label>
                    <input type="text" name="new_contact_position" id="new_contact_position" value="" class="text ui-widget-content ui-corner-all" />		     
                    <label for="description">Description</label>
                    <input type="text" name="new_contact_description" id="new_contact_description" value="" class="text ui-widget-content ui-corner-all" />
                    <label for="province">Province</label>
                    <input type="text" name="new_contact_province" id="new_contact_province" value="" class="text ui-widget-content ui-corner-all" />
                    <label for="city">City</label>
                    <input type="text" name="new_contact_city" id="new_contact_city" value="" class="text ui-widget-content ui-corner-all" />
                    <label for="postal_code">Postal Code</label>
                    <input type="text" name="new_contact_postal_code" id="new_contact_postal_code" value="" class="text ui-widget-content ui-corner-all" />
                    <label for="country">Country</label>
                    <select name="new_contact_country" id="new_contact_country">              
                      <#list officialCountries as c>
                        <option value="${c.iso2LetterCode}" <#if member.country==c>selected</#if> >${c.title}</option>
                      </#list>
                    </select>	
                    <label for="email">E-Mail</label>
                    <input type="text" name="new_contact_email" id="new_contact_email" value="" class="text ui-widget-content ui-corner-all" />
                    <label for="phone">Phone</label>
                    <input type="text" name="new_contact_phone" id="new_contact_phone" value="" class="text ui-widget-content ui-corner-all" />                                                                                                                    	                                   
                  </fieldset>
                </form>
              </div>

              <div id="users-contain" class="ui-widget">
                <table id="users" class="ui-widget ui-widget-content">
                  <thead>
                    <tr class="ui-widget-header ">
                      <th>Salutation</th>
                      <th>First Name</th>
                      <th>Last Name</th>
                      <th>Type</th>
                      <th>Position</th>
                      <th>Description</th>
                      <th>Province</th>
                      <th>City</th>
                      <th>Postal Code</th>
                      <th>Country</th>
                      <th>E-mail</th>
                      <th>Phone</th>
                      <th>Is Primary?</th>
                    </tr>
                  </thead>
                  <tbody>
                  </tbody>
                </table>
              </div>
                
              <button id="create-user">Create new contact</button>

            </div>
            <!-- End contact creation -->               
             

            <div class="field">
              <p>GBIF endorsing node</p>
              <select id="endorsing_node" class="endorsing_node" name="endorsing_node">
                <option value="">Select one of the list below...</option>
                <option value="endorsing_node-1">ACB</option>
                <option value="endorsing_node-2">Andorra</option>
                <option value="endorsing_node-3" selected>Austria</option>
                <option value="endorsing_node-4">Argentina</option>
              </select>
            </div>
            <p/>
            <div class="field">
              <p>Network links</p>
              <select multiple id="endorsing_node" class="endorsing_node" name="endorsing_node">
                <option value="">Select one of the list below...</option>
                <option value="network-1" selected>VertNET</option>
                <option value="network-2">IABIN</option>
                <option value="network-3" selected>African Territory</option>
                <option value="network-4">Natural History Institutions</option>
              </select>
            </div>                     
          </form>
       
          
        </div>
        <div class="bottom"></div>
      </div>

      <nav><a href="<@s.url value='#'/>" title="Edit" class="candy_white_button next"><span>Save Changes</span></a>

        <p>When you are sure about the changes, press 'Save Changes'</p></nav>
    </div>
    <footer></footer>
  </article>
</body>
</html>
