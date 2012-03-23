$(function() {
  // a workaround for a flaw in the demo system (http://dev.jqueryui.com/ticket/4375), ignore!
  $( "#dialog:ui-dialog" ).dialog( "destroy" );
		
  var salutation = $( "#new_contact_salutation" ),
  first_name = $( "#new_contact_first_name" ),
  last_name = $( "#new_contact_last_name" ),
  type = $( "#new_contact_type" ),
  position = $( "#new_contact_position" ),
  description = $( "#new_contact_description" ),
  province = $( "#new_contact_province" ),
  city = $( "#new_contact_city" ),
  postal_code = $( "#new_contact_postal_code" ),
  country = $( "#new_contact_country" ),
  email = $( "#new_contact_email" ),  
  phone = $( "#new_contact_phone" ),  
  allFields = $( [] ).add( salutation ).add( first_name ).add( last_name ).add( type ).add( position ).add( description )
  .add( province ).add( city ).add( postal_code ).add( country ).add( email ).add( phone ),
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
    height: 600,
    width: 350,
    modal: true,
    buttons: {
      "Create a contact": function() {
        var bValid = true;
        allFields.removeClass( "ui-state-error" );

        //bValid = bValid && checkLength( name, "new_contact_username", 3, 16 );
        //bValid = bValid && checkLength( email, "new_contact_email", 6, 80 );
        //bValid = bValid && checkLength( password, "new_contact_password", 5, 16 );

        //bValid = bValid && checkRegexp( name, /^[a-z]([0-9a-z_])+$/i, "Username may consist of a-z, 0-9, underscores, begin with a letter." );
        // From jquery.validate.js (by joern), contributed by Scott Gonzalez: http://projects.scottsplayground.com/email_address_validation/
        bValid = bValid && checkRegexp( email, /^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.?$/i, "eg. ui@jquery.com" );

        //bValid = bValid && checkRegexp( password, /^([0-9a-zA-Z])+$/, "Password field only allow : a-z 0-9" );

        if ( bValid ) {
          $( "#users tbody" ).append( "<tr>" +
            "<td>" + salutation.val() + "</td>" + 
            "<td>" + first_name.val() + "</td>" + 
            "<td>" + last_name.val() + "</td>" + 
            "<td>" + type.val() + "</td>" + 						
            "<td>" + position.val() + "</td>" + 
            "<td>" + description.val() + "</td>" + 
            "<td>" + province.val() + "</td>" + 
            "<td>" + city.val() + "</td>" + 
            "<td>" + postal_code.val() + "</td>" + 
            "<td>" + country.val() + "</td>" + 						
            "<td>" + email.val() + "</td>" + 						
            "<td>" + phone.val() + "</td>" + 						
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