$(function() {
	  $( "#dialog-tag" ).dialog({
		    autoOpen: false,
		    height: 600,
		    width: 350,
		    modal: true,
		    buttons: {
		      "Create an endpoint": function() {

		      var $form = $( "#tagForm" ),
		        actionUrl = $form.attr( 'action' );
				namespace = $("input[name='tag.namespace']").val();
				predicate = $("input[name='tag.predicate']").val();
				value = $("input[name='tag.value']").val();
		        /* Send the data via jquery post and if errors are present, keep them on the same modal dialog */
        $.post( actionUrl, { 'tag.namespace': namespace,
                       'tag.predicate': predicate,
					   'tag.value': value },
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

  $( "#create-tag" )
    .button()
    .click(function(e) {
      e.preventDefault();
      $( "#dialog-tag" ).load(cfg.baseUrl + "/admin/organization/add/tag").dialog( "open" );
    });
  });