
	   $.extend($.ui.autocomplete.prototype, 
			   {highlight: function(value, term) {
			        return value.replace(new RegExp("(?![^&;]+;)(?!<[^<>]*)(" + term.replace(/([\^\$\(\)\[\]\{\}\*\.\+\?\|\\])/gi, "\\$1") + ")(?![^<>]*>)(?![^&;]+;)", "gi"), "<strong>$1</strong>");
			    }
			   });	   
	   $.fn.speciesAutosuggest = function(wsServiceUrl,limit,chklstKeysElementsSelector,appendToElement) {		   
		   $this = $(this);
		   $this.autocomplete({source: function( request, response ) {
				$.ajax({
						url: wsServiceUrl,
						dataType: 'jsonp',
						data: {
							q: $this.val(),
							limit: limit,
							checklistKey: ( chklstKeysElementsSelector ? $.map($(chklstKeysElementsSelector),function(elem){return elem.value;}) : undefined)
						},
						success: function(data){
							response(data);
						}
					});
				},
				create: function(event, ui) {
				 $(".ui-autocomplete").removeClass("ui-widget-content ui-corner-all");
				 $(".ui-autocomplete").css("z-index",1000);
				},
				open: function(event, ui) {
			     $(".ui-autocomplete").css("z-index",1000);
				 if ($(".ui-autocomplete li").length == 1){
				 	$(".ui-autocomplete li:first-child").addClass("unique");
				 }
				 else{
				 	$(".ui-autocomplete li:first-child").addClass("first");
				 	$(".ui-autocomplete li:last-child").addClass("last");
				 }
				},
				appendTo: appendToElement,
				focus: function( event, ui ) {
							$this.val( ui.item.value);
							return false;
						},
				select: function( event, ui ) {
							$this.val( ui.item.value);											
							return false;
						}
			}).data( "autocomplete" )._renderItem = function( ul, item) {      		
			return $( "<li></li>" )
			.data( "item.autocomplete", item )
			.append( "<a class='name'>" + this.highlight(item.value,$this.val()) + "</a>")
			.appendTo( ul );
			};   
	   }         
      