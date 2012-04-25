$(function() {
	  $( "#dialog-endpoint" ).dialog({
		    autoOpen: false,
		    height: 600,
		    width: 350,
		    modal: true,
		    buttons: {
		      "Create an endpoint": function() {

		      var $form = $( "#endpointForm" ),
		        actionUrl = $form.attr( 'action' );
				type = $("select[name='endpoint.type']").val();
				url = $("input[name='endpoint.url']").val();
				code = $("input[name='endpoint.code']").val();
				description = $("input[name='endpoint.description']").val();
		        /* Send the data via jquery post and if errors are present, keep them on the same modal dialog */
		        $.post( actionUrl, { 'endpoint.type': type, 
		                       'endpoint.url': url,
		                       'endpoint.code': code,
							   'endpoint.description': description },
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

  $( "#create-endpoint" )
    .button()
    .click(function(e) {
      e.preventDefault();
      $( "#dialog-endpoint" ).load(cfg.baseUrl + "/admin/organization/add/endpoint").dialog( "open" );
    });
  });