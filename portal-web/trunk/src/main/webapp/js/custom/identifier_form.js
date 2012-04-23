$(function() {
	  $( "#dialog-identifier" ).dialog({
		    autoOpen: false,
		    height: 600,
		    width: 350,
		    modal: true,
		    buttons: {
		      "Create an identifier": function() {

		      var $form = $( "#identifierForm" ),
		        actionUrl = $form.attr( 'action' );
				type = $("select[name='identifier.type']").val();
				identifier = $("input[name='identifier.identifier']").val();
		        /* Send the data via jquery post and if errors are present, keep them on the same modal dialog */
        $.post( actionUrl, { 'identifier.type': type,
                       'identifier.identifier': identifier},
						        function( data ) {
						            $( "#newone" ).empty().append( data );
	  
						          });
						        },
						        Close: function() {
		        $( this ).dialog( "close" );
				window.location.reload();
		      }
		    },
		  });

  $( "#create-identifier" )
    .button()
    .click(function(e) {
      e.preventDefault();
      $( "#dialog-identifier" ).load("/admin/organization/add/identifier").dialog( "open" );
    });
  });