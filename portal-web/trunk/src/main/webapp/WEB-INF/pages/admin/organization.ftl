<#import "/WEB-INF/macros/common.ftl" as common>
<html>
<head>
  <title>Edit Organization - GBIF</title>
  <meta name="menu" content="datasets"/>
    <script type="text/javascript" src="<@s.url value='/js/vendor/jquery-1.7.1.min.js'/>"></script>
    <script type="text/javascript" src="jquery.horizontal.scroll.js"></script>
	<script type="text/javascript">
	$(function() {
		// a workaround for a flaw in the demo system (http://dev.jqueryui.com/ticket/4375), ignore!
		$( "#dialog:ui-dialog" ).dialog( "destroy" );
		
		var name = $( "#new_contact_name" ),
			email = $( "#new_contact_email" ),
			password = $( "#new_contact_password" ),
			allFields = $( [] ).add( name ).add( email ).add( password ),
			tips = $( ".validateTips" );

		function updateTips( t ) {
			tips
				.text( t )
				.addClass( "ui-state-highlight" );
			setTimeout(function() {
				tips.removeClass( "ui-state-highlight", 1500 );
			}, 500 );
		}

		function checkLength( o, n, min, max ) {
		alert(o.val());
		alert(o.val().length);
			if ( o.val().length > max || o.val().length < min ) {
				o.addClass( "ui-state-error" );
				updateTips( "Length of " + n + " must be between " +
					min + " and " + max + "." );
				return false;
			} else {
				return true;
			}
		}

		function checkRegexp( o, regexp, n ) {
			if ( !( regexp.test( o.val() ) ) ) {
				o.addClass( "ui-state-error" );
				updateTips( n );
				return false;
			} else {
				return true;
			}
		}
		
		$( "#dialog-form" ).dialog({
			autoOpen: false,
			height: 300,
			width: 350,
			modal: true,
			buttons: {
				"Create an account": function() {
					var bValid = true;
					allFields.removeClass( "ui-state-error" );

					bValid = bValid && checkLength( name, "new_contact_username", 3, 16 );
					bValid = bValid && checkLength( email, "new_contact_email", 6, 80 );
					bValid = bValid && checkLength( password, "new_contact_password", 5, 16 );

					bValid = bValid && checkRegexp( name, /^[a-z]([0-9a-z_])+$/i, "Username may consist of a-z, 0-9, underscores, begin with a letter." );
					// From jquery.validate.js (by joern), contributed by Scott Gonzalez: http://projects.scottsplayground.com/email_address_validation/
					bValid = bValid && checkRegexp( email, /^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.?$/i, "eg. ui@jquery.com" );
					bValid = bValid && checkRegexp( password, /^([0-9a-zA-Z])+$/, "Password field only allow : a-z 0-9" );

					if ( bValid ) {
						$( "#users tbody" ).append( "<tr>" +
							"<td>" + name.val() + "</td>" + 
							"<td>" + email.val() + "</td>" + 
							"<td>" + password.val() + "</td>" +
						"</tr>" ); 
						$( this ).dialog( "close" );
					}
				},
				Cancel: function() {
					$( this ).dialog( "close" );
				}
			},
			close: function() {
				allFields.val( "" ).removeClass( "ui-state-error" );
			}
		});

		$( "#create-user" )

			.button()
			.click(function(e) {
				e.preventDefault();
				$( "#dialog-form" ).dialog( "open" );
			});
	});
	</script>    
  
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
            
<div class="demo">

<div id="dialog-form" title="Create new user">
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
		<input type="text" name="new_contact_salutation" id="new_contact_salutation" class="text ui-widget-content ui-corner-all" />
		<label for="email">First Name</label>
		<input type="text" name="new_first_name" id="new_first_name" value="" class="text ui-widget-content ui-corner-all" />
		<label for="email">Last Name</label>
		<input type="text" name="new_last_name" id="new_last_name" value="" class="text ui-widget-content ui-corner-all" />		
		<label for="name">Type</label>
		<select name="new_contact_type" id="new_contact_type">
		  <#list contactTypes as c>
		    <option value="${c}"><@s.text name="enum.contacttype.${c}"/></option>
		  </#list>
		</select>	
	</fieldset>
	</form>
</div>

	<style>
		body { font-size: 62.5%; }
		label, input { display:block; }
		input.text { margin-bottom:12px; width:95%; padding: .4em; }
		fieldset { padding:0; border:0; margin-top:25px; }
		h1 { font-size: 1.2em; margin: .6em 0; }
		div#users-contain { width: 350px; margin: 20px 0; }
		div#users-contain table { margin: 1em 0; border-collapse: collapse; width: 100%; }
		div#users-contain table td, div#users-contain table th { border: 1px solid #eee; padding: .6em 10px; text-align: left; }
		.ui-dialog .ui-state-error { padding: .3em; }
		.validateTips { border: 1px solid transparent; padding: 0.3em; }
	</style>

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
			</tr>
		</thead>
		<tbody>
		</tbody>
	</table>
</div>
<button id="create-user">Create new contact</button>

</div><!-- End demo -->               
             

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
