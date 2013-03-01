
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
	   * Dataset title Autosuggest widget.
	   * @param wsSuggestUrl url to the suggest service
     * @param portalDatasetUrl url to portal dataset details page without the key
	   * @param limit maximum elements expected/this can be overwritten by the server side implementation
	   * @param appendToElement parent element of generated widget
	   * @param onSelectEventHandler function that handles the event when an element is selected
	   */
	  $.fn.datasetAutosuggest = function(wsSuggestUrl, limit, appendToElement, onSelectEventHandler, datasetType) {
		   //reference to the widget
		   var self = $(this);
		   //jquery ui autocomplete widget creation
		   var defaultParams =  new Object();
		   if( undefined != datasetType){
		     defaultParams.type = datasetType;
		   }
		   self.autocomplete({source: function( request, response ) {
				$.ajax({
						url: wsSuggestUrl,
						dataType: 'jsonp', //jsonp is the default
						data: $.extend(defaultParams, {
							q: self.val(),
							limit: limit							
						}),
						success: function(data){//response the data sent by the web service						 
						    response( $.map(data, function( item ) {
		              return {		                
		                value: item.title,
		                label: item.title,
		                key: item.key
		              }
		            }));
						}
					});
				},
				create: function(event, ui) {
				 //forcibly css classes are removed because of conflicts between existing styles and jquery ui styles
				 $(".ui-autocomplete").removeClass("ui-widget-content ui-corner-all");
				},
				open: function(event, ui) {
				    $('.ui-autocomplete.ui-menu').addClass('species_autocomplete');
			     //sets child classes of li elements according to the returned elements
				 if ($(".ui-autocomplete li").length == 1) {
				 	$(".ui-autocomplete li:first-child").addClass("unique");
				 }
				 else {
				 	$(".ui-autocomplete li:first-child").addClass("first");
				 	$(".ui-autocomplete li:last-child").addClass("last");
				 }
				},
				appendTo: appendToElement,
				focus: function( event, ui ) {//on focus: sets the value of the input[text] element
			       if (typeof(ui.item.key) != 'undefined') {
			         self.attr("key",ui.item.key);
			       }
			       self.val( ui.item.value);				       
						 return false;
						},
				select: function( event, ui ) {//on select: goes to dataset detail page
    				  if (typeof(ui.item.key) != 'undefined') {                
    				    self.attr("key",ui.item.key);
              }
    				  self.val( ui.item.value);
    				  if(onSelectEventHandler !== undefined) {
    	          onSelectEventHandler(ui.item);
    	        }
							return false;
						}
			}).data( "autocomplete" )._renderItem = function( ul, item) { 		  
			return $( "<li></li>" )
			.data( "item.autocomplete", item )
			.append("<a class='name'>" + this.highlight(item.value,self.val()) + "</a>")			
			.appendTo( ul );
			//last line customizes the generated elements of the auto-complete widget by highlighting the results and adding new css class
			};   
	   }; 
	 
      