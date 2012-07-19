
	/**
	 * jquery ui is extended with a new highlight function.
	 * This function highlights the input term in value result.
	 */
	 $.extend($.ui.autocomplete.prototype, 
			   {highlight: function(value, term) {
			        return value.replace(new RegExp("(?![^&;]+;)(?!<[^<>]*)(" + term.replace(/([\^\$\(\)\[\]\{\}\*\.\+\?\|\\])/gi, "\\$1") + ")(?![^<>]*>)(?![^&;]+;)", "gi"), "<strong>$1</strong>");
			    }
	  });
	 
	  /**
	   * Species name Autosuggest widget.
	   * @param wsServiceUrl url to the search/suggest service
	   * @param limit maximum elements expected/this can be overwritten by the server side implementation
	   * @param chklstKeysElementsSelector jquery/css selector for get the values of checklists key/ can be null (assuming  a server side default)
	   * @param appendToElement parent element of generated widget
	   */
	  $.fn.speciesAutosuggest = function(wsServiceUrl,limit,chklstKeysElementsSelector,appendToElement) {
		   //reference to the widget
		   $this = $(this);
		   //jquery ui autocomplete widget creation
		   $this.autocomplete({source: function( request, response ) {
				$.ajax({
						url: wsServiceUrl,
						dataType: 'jsonp', //jsonp is the default
						data: {
							q: $this.val(),
							limit: limit,
							checklistKey: ( chklstKeysElementsSelector ? $.map($(chklstKeysElementsSelector),function(elem){return elem.value;}) : undefined) //if the selector is null, the parameter is not sent
						},
						success: function(data){//response the data sent by the web service
							response(data);
						}
					});
				},
				create: function(event, ui) {
				 //forcibly css classes are removed because of conflicts between existing styles and jquery ui styles
				 $(".ui-autocomplete").removeClass("ui-widget-content ui-corner-all");
				 $(".ui-autocomplete").css("z-index",1000);
				},
				open: function(event, ui) {
			     //a high z-index ensures that the autocomplete will be "always" visible on top of other elements
			     $(".ui-autocomplete").css("z-index",1000);
			     //sets child classes of li elements according to the returned elements
				 if ($(".ui-autocomplete li").length == 1){
				 	$(".ui-autocomplete li:first-child").addClass("unique");
				 }
				 else{
				 	$(".ui-autocomplete li:first-child").addClass("first");
				 	$(".ui-autocomplete li:last-child").addClass("last");
				 }
				},
				appendTo: appendToElement,
				focus: function( event, ui ) {//on focus: sets the value of the input[text] element
							$this.val( ui.item.value);
							return false;
						},
				select: function( event, ui ) {//on select: sets the value of the input[text] element
							$this.val( ui.item.value);											
							return false;
						}
			}).data( "autocomplete" )._renderItem = function( ul, item) {      		
			return $( "<li></li>" )
			.data( "item.autocomplete", item )
			.append( "<a class='name'>" + this.highlight(item.value,$this.val()) + "</a>")
			.appendTo( ul );
			//last line customizes the generated elements of the auto-complete widget by highlighting the results and adding new css class
			};   
	   }         
      