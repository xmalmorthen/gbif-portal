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
 * @param appendToElement parent element of generated widget
 */
$.fn.countryAutosuggest = function(countryList,appendToElement, onSelectEventHandler) {
  //reference to the widget
  var self = $(this);  
  //jquery ui autocomplete widget creation
  self.autocomplete({
    source:function(request, response) {
      var matches = $.map( countryList, function(country) {
        if ( country.label.toUpperCase().indexOf(request.term.toUpperCase()) === 0 ) {
          return country;
        }
      });
      if (!matches || matches.length == 0) {
        matches.push({label:"No results found",iso2Lettercode:0});
      }
      response(matches);
    },
    create: function(event, ui) {
      //forcibly css classes are removed because of conflicts between existing styles and jquery ui styles
      $(".ui-autocomplete").removeClass("ui-widget-content ui-corner-all");
      $(".ui-autocomplete").css("z-index",1000);
    },
    open: function(event, ui) {
      $('.ui-autocomplete.ui-menu').addClass('autocomplete');
      //a high z-index ensures that the autocomplete will be "always" visible on top of other elements
      $(".ui-autocomplete").css("z-index",1000);
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
      return false;
    },
    select: function( event, ui ) {//on select: sets the value of the input[text] element
      if (ui.item.iso2Lettercode != 0){
        self.attr("data-key",ui.item.iso2Lettercode);
        self.val( ui.item.label);
        if(onSelectEventHandler !== undefined) {
          onSelectEventHandler({key: ui.item.iso2Lettercode,value: ui.item.label,label: ui.item.label});
        }
      }
      return false;
    }
  }).data( "autocomplete" )._renderItem = function( ul, item) {    
    return $( "<li></li>" )
      .data( "item.autocomplete", item )
      .append("<a class='name'>" + this.highlight(item.label,self.val()) + "</a>")
      .appendTo( ul );
    //last line customizes the generated elements of the auto-complete widget by highlighting the results and adding new css class
  };
};