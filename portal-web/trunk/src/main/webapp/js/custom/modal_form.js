$(function() {
  $( "#dialog-form" ).dialog({
    autoOpen: false,
    height: 600,
    width: 350,
    modal: true,
    buttons: {
      "Create a contact": function() {

      var $form = $( "#contactForm" ),
        url = $form.attr( 'action' );
		firstName = $("input[name='contact.firstName']").val();
		lastName = $("input[name='contact.lastName']").val();
		email = $("input[name='contact.email']").val();
		type = $("select[name='contact.type']").val();
		country = $("select[name='contact.country']").val();
		salutation = $("input[name='contact.salutation']").val();
		position = $("input[name='contact.position']").val();
		description = $("input[name='contact.description']").val();
		address = $("input[name='contact.address']").val();
		city = $("input[name='contact.city']").val();
		province = $("input[name='contact.province']").val();
		postalCode = $("input[name='contact.postalCode']").val();
		phone = $("input[name='contact.phone']").val();
		onlineUrl = $("input[name='contact.onlineUrl']").val();
        /* Send the data via jquery post and if errors are present, keep them on the same modal dialog */
        $.post( url, { 'contact.firstName': firstName, 
                       'contact.lastName': lastName,
                       'contact.email': email,
					   'contact.type': type,
					   'contact.salutation': salutation,
					   'contact.position': position,
					   'contact.description': description,
					   'contact.address': address,		
					   'contact.city': city,
					   'contact.province': province,
					   'contact.postalCode': postalCode,
					   'contact.type': type,		
					   'contact.phone': phone,	
					   'contact.phone': phone,					   
					   'contact.onlineUrl': onlineUrl },
        function( data ) {
          $( "#newone" ).empty().append( data );
          $( "#tempContacts" ).append( "<tr>" +
            "<td>" + firstName + "</td>" + 
            "<td>" + lastName + "</td>" + 
            "<td>" + email + "</td>" +
			"<td>" + type + "</td>" +  				
            "</tr>" ); 		  
        });
      },
      Close: function() {
        $( this ).dialog( "close" );
		window.location.reload();
      }
    },
  });

  $( "#create-user" )
    .button()
    .click(function(e) {
      e.preventDefault();
      $( "#dialog-form" ).load("/admin/organization/add/contact").dialog( "open" );
    });
  });