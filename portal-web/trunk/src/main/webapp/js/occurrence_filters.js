/*
 * Copyright 2011 Global Biodiversity Information Facility (GBIF)
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * http://www.apache.org/licenses/LICENSE-2.0
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
/**
 * Occurrence filters module.
 * Implements functionality for widgets that follow the structure of templates: 
 * - template-add-filter: simple filter with 1 input.
 * - template-add-date-filter: occurrence date widget.
 * - map-template-filter: bounding box widget filter.
 * 
 *  Every time a filter is applied/closed a request is sent to the targetUrl parameter.
 *  Parameter "filters" contains a list of predefined filters that would be displayed as applied filters.
 *  The filters parameter must have the form: { title,value, year (valid for date filter only), month (valid for date filter only), key, paramName }
 *  
 */

//DEFAULT fade(in/out) time
var FADE_TIME = 250;

//Maximum size of filters label, 37 = 40 - 3 because of ... (suspensive points); so the real maximum is 40
var MAX_LABEL_SIZE = 37;

//Constant for suspensive points literal.
var SUSPENSIVE_POINTS = "...";

// This is needed as a nasty way to address http://dev.gbif.org/issues/browse/POR-365
// The map is not correctly displayed, and requires a map.invalidateSize(); to be fired
// After the filter div is rendered.  Because of this the map scope is public.
var map;

/**
 * Base module that contains the base implementation for the occurrence widgets.
 * Contains the implementation for the basic operations: create the HTML control, apply filters, show the applied filters and close/hide the widget.
 */
var OccurrenceWidget = (function ($,_) {  

  /**
   * Utility function that validates if the input string is empty.
   */
  function isBlank(str) {
    return (!str || /^\s*$/.test(str));
  };

  /**
   * Inner object/function used for returning the OccurenceWidget instance.
   */
  var InnerOccurrenceWidget = function () {        
  };

  //Prototype object extensions.
  InnerOccurrenceWidget.prototype = {

      /**
       * Default constructor.
       */
      constructor: InnerOccurrenceWidget,

      /**
       * Initializes the widget.
       * This function is not invoked during object construction to allow the executions of binding functions 
       * that usually are not required during object construction. 
       */
      init: function(options){
        this.appliedFilters = new Array();
        this.widgetContainer = options.widgetContainer;
        this.isBound = false;
        this.id = null;
        this.filterElement = null;
        this.onApplyFilterEvent = options.onApplyFilter;
        this.bindingsExecutor = options.bindingsExecutor;
      },

      //IsBlank
      isBlank : isBlank,

      /**
       * Gets the widget identifier.
       * The id field should identify the widget in a page instance.
       */
      getId : function() {
        return this.id;
      },

      /**
       * Sets the widget identifier.
       */
      setId : function(id) {
        this.id = id;
      },

      /**
       * Returns the filters that have been applied  by the filter or by reading HTTP parameters. 
       */
      getAppliedFilters : function(){return this.appliedFilters;},

      /**
       * Shows the HTML widget.
       */
      open : function(){    
        if (!this.isVisible()) {
          this.filterElement.fadeIn(FADE_TIME);
          this.showAppliedFilters();
        }
      },

      /**
       * Return true if the widget has been initialized.
       */
      isCreated : function(){
        return (this.filterElement)
      },

      /**
       * Closes (hides) the HTML widget.
       */
      close : function(){      
        this.filterElement.fadeOut(FADE_TIME);
      },

      /**
       * Determines if the widget is visible or not.
       */
      isVisible : function(){
        return ($(this.filterElement).is(':visible'));
      },

      /**
       * Adds the filter to the list of applied filters and executes the onApplyFilter event.
       */
      applyFilter : function(filter) {
        this.addAppliedFilter(filter);
        this.onApplyFilterEvent.call();
      },

      /**
       * Adds a filter to the list of applied filters.
       */
      addAppliedFilter : function(filter) {
        if (!this.existsFilter(filter)) {
          this.appliedFilters.push(filter);
        }
      },

      /**
       * Binds the widget to an HTML element.
       * The click event of the control parameters shows the widget.
       */
      bindToControl: function(control) {
        if(!this.getId()){                    
          this.setId($(control).attr("data-filter"));   
          var widget = this;
          $(control).on("click", function(e) {
            e.preventDefault();
            widget.addFilter(this);
          });
        }
      },
      
      /**
       * Limit the size of the text to MAX_LABEL_SIZE.
       * If the size of the text y greater than MAX_LABEL_SIZE, the size is limited to that max and suspensive points are added at the end. 
       */
      limitLabel: function(label) {
        var newLabel = label;        
        if(newLabel.length >= MAX_LABEL_SIZE){
          newLabel = newLabel.slice(0,MAX_LABEL_SIZE) + SUSPENSIVE_POINTS;
        }
        return newLabel;
      },

      /**
       * Shows the filters that have been applied.
       * The list of applied filters is shown in element with css class "appliedFilters". 
       */
      showAppliedFilters : function() {
        if(this.filterElement != null) { //widget was created
          var appliedFilters = this.filterElement.find(".appliedFilters");
          //clears the HTML list of applied filters, the list is rebuilt each time this function is called
          appliedFilters.empty(); 
          //HTML element that will hold the list of filters
          var filtersContainer = $("<ul style='list-style: none;display:block;'></ul>"); 
          appliedFilters.append(filtersContainer); 
          //gets the HTML template for applied filters
          var templateFilter = _.template($("#template-applied-filter").html());
          var self = this;
          this.filterElement.find(".appliedFilters,.filtersTitle").toggle(this.appliedFilters.length > 0);
          for(var i=0; i < this.appliedFilters.length; i++) {
            //title field used for attribute <INPU title="currentFilter.title">
            var currentFilter = $.extend(this.appliedFilters[i], {title: this.appliedFilters[i].label, label:this.limitLabel(this.appliedFilters[i].label)});            
            var newFilter = $(templateFilter(currentFilter));
            if( i != this.appliedFilters.length - 1){
              $(newFilter).append('</br>');
            }
            //adds each applied filter to the list using the HTML template
            filtersContainer.append(newFilter);   
            //The click event of element with css class "closeFilter" handles the filter removing and applying the filters 
            newFilter.find(".closeFilter").click( function(e) {
              var input = $(this).parent().find(':input[name=' + self.getId() + ']');              
              self.removeFilter({value: input.val(), key: input.attr('key'), paramName: input.attr('name')});
              self.showAppliedFilters();
            });
          }

          $('.date-dropdown').dropkick(); // adds custom dropdowns

          // This is needed to address http://dev.gbif.org/issues/browse/POR-365 
          // The solution was found https://groups.google.com/forum/?fromgroups=#!topic/leaflet-js/KVm6OvaOU3o
          if (map!=null) map.invalidateSize();
        }
      },

      /**
       * Creates the HTML widget if it was not created previously, then the widget is shown.
       */
      addFilter : function(control) {
        if (!this.isCreated()) {
          this.createHTMLWidget(control);
        }
        this.open(); 
      },

      /**
       * Utility function that renders/creates the HTML widget.
       */
      createHTMLWidget : function(control){        
        var          
        placeholder = $(control).attr("data-placeholder"),
        templateFilter = $(control).attr("template-filter"),
        inputClasses = $(control).attr("input-classes") || {},
        title = $(control).attr("title"),
        template = _.template($("#" + templateFilter).html());

        this.filterElement = $(template({title:title, paramName: this.getId(), placeholder: placeholder, inputClasses: inputClasses }));
        this.widgetContainer.after(this.filterElement);         
        this.bindCloseControl();
        this.bindAddFilterControl();
        this.bindApplyControl();     
        this.executeAdditionalBindings();
      },

      /**
       * Executes binding function bound during the object construction.
       */
      executeAdditionalBindings : function(){this.bindingsExecutor.call();},

      /**
       * Binds the close control to the close function.
       */
      bindCloseControl : function () {
        var self = this;
        this.filterElement.find(".close").click(function(e) {
          e.preventDefault();
          self.close();
        });
      },

      /**
       * Removes a filter that was applied previously and the re-display the list of applied filters.
       */
      removeFilter :function(filter) {        
        for(var i = 0; i < this.appliedFilters.length; i++){
          if(this.appliedFilters[i].value == filter.value){
            this.appliedFilters.splice(i,1);
            this.showAppliedFilters();
            return;            
          }
        }
      },
      
      /**
       * Searches a filter by its value.
       */
      existsFilter :function(filter) {        
        for(var i = 0; i < this.appliedFilters.length; i++){
          if(this.appliedFilters[i].value == filter.value){
            return true;
          }
        }
        return false;
      },

      /**
       * Binds a widget apply control.
       * The apply control is used when the widgets handles several filters at a time and those should be applied in one call.
       */
      bindApplyControl : function() {
        var self = this;
        this.filterElement.find("a.button[data-action]").click( function(e){
          if(self.filterElement.find(".addFilter").size() != 0) { //has and addFilter control
            //gets the value of the input field            
            var input = self.filterElement.find(":input[name=" + self.id + "]:first");                    
            var value = input.val();            
            if (!isBlank(value) && !self.existsFilter({value:value})) {
              var key = "";
              //Auto-complete widgets store the selected key in "key" attribute
              if (input.attr("key") !== undefined) {
                key = input.attr("key"); 
              }
              if ((typeof(value) != "string") && $.isArray(value)) {
                for (var i = 0; i < value.length; i++) {
                  self.applyFilter({value: value[i], key:key});
                }
              } else {
                self.applyFilter({value: value, key:key});
              }
              self.close();
            } else {
              self.onApplyFilterEvent.call();
            }
          } else {
            self.onApplyFilterEvent.call();
          }
        });  
      },      

      /**
       * The add filter control, handler how each individual filter is added to the list of applied filters.
       * The enter key, by default, adds/applies the filter.
       */
      bindAddFilterControl : function() {
        var self = this;
        var input = this.filterElement.find(":input[name=" + this.id + "]:first");
        input.keyup(function(event){
          if(event.keyCode == 13){
            self.addFilterControlEvent(self, input);
          }
        });
        this.filterElement.find(".addFilter").click( function(e){          
          self.addFilterControlEvent(self, input);
        });  
      },

      /**
       * Utility function that validates if the input value is valid (non-blank) and could be added to list of applied filters.
       */
      addFilterControlEvent : function (self,input){        
        //gets the value of the input field            
        var value = input.val();            
        if(!isBlank(value)){            
          var key = "";
          //Auto-complete stores the selected key in "key" attribute
          if (input.attr("key") !== undefined) {
            key = input.attr("key"); 
          }
          self.addAppliedFilter({label:value,value: value, key:key,paramName:self.getId()});            
          self.showAppliedFilters();
          input.val('');
        }
      }
  }

  return InnerOccurrenceWidget;
})(jQuery,_);

/**
 * Occurrence date widget. Allows specify single and range of dates.
 */
var OccurrenceDateWidget = (function ($,_,OccurrenceWidget) {
  
  var InnerOccurrenceDateWidget = function () {        
  };
  
  //Inherits everything from the OccurrenceWidget module.
  InnerOccurrenceDateWidget.prototype = $.extend(true,{}, new OccurrenceWidget());
  
  //The bindAddFilterControl is re-defined, the define dates are validated and then applied.
  InnerOccurrenceDateWidget.prototype.bindAddFilterControl = function() {
    var self = this;
    this.filterElement.find(".addFilter").click( function(e) { 
      e.preventDefault();   
      var monthMin = self.filterElement.find(":input[name=monthMin]:first").val();
      var yearMin  =  self.filterElement.find(":input[name=yearMin]:first").val();
      var monthMax = self.filterElement.find(":input[name=monthMax]:first").val();
      var yearMax  =  self.filterElement.find(":input[name=yearMax]:first").val();
      var value = "";
      var label = "";
      if(!self.isBlank(yearMin) && monthMin != "0"){
        value = monthMin + "/" + yearMin;
        label = value;
      }
      if(!self.isBlank(yearMax) && monthMax != "0"){
        if(!self.isBlank(value)){
          label = "FROM " +  value + " TO ";
          value = value + ",";          
        }
        value = value + monthMax + "/" + yearMax;
        label = label + monthMax + "/" + yearMax;
      }
      if(!self.isBlank(value)) {
        self.addAppliedFilter({label:label, value: value, key: '', paramName: self.getId()});
        self.showAppliedFilters();
      }
    })
  };       
  return InnerOccurrenceDateWidget;
})(jQuery,_,OccurrenceWidget);

/**
 * Location widget. Displays a map that allows select a range bounding box area.
 */
var OccurrenceLocationWidget = (function ($,_,OccurrenceWidget) {
  var InnerOccurrenceLocationWidget = function () {        
  }; 
  //Inherits everything from the OccurrenceWidget module.
  InnerOccurrenceLocationWidget.prototype = $.extend(true,{}, new OccurrenceWidget());
 
  /**
   * The bindAddFilterControl function is re-defined to validate and process the coordinates. 
   */
  InnerOccurrenceLocationWidget.prototype.bindAddFilterControl = function() {
    var self = this;
    this.filterElement.find(".addFilter").click( function(e) { 
      e.preventDefault();          
      var minLat = self.filterElement.find(":input[name=minLatitude]:first").val();
      var minLng = self.filterElement.find(":input[name=minLongitude]:first").val();
      var maxLat = self.filterElement.find(":input[name=maxLatitude]:first").val();
      var maxLng = self.filterElement.find(":input[name=maxLongitude]:first").val();
      if(!self.isBlank(minLat) && !self.isBlank(minLng) && !self.isBlank(maxLat) && !self.isBlank(maxLng)){        
        var value = minLat + ',' + minLng + ',' + maxLat + ',' + maxLng;
        var label = "FROM " + minLat + ',' + minLng + ' TO ' + maxLat + ',' + maxLng;
        self.filterElement.find(":input").val('');
        self.addAppliedFilter({label: label, value: value, key: '', paramName: self.getId()});       
        self.showAppliedFilters();
      }
    })
  };      
  return InnerOccurrenceLocationWidget;
})(jQuery,_,OccurrenceWidget);


/**
 * Basis of Record widget. Displays a multi-select list with the basis of record values.
 */
var OccurrenceBasisOfRecordWidget = (function ($,_,OccurrenceWidget) {
  var InnerOccurrenceBasisOfRecordWidget = function () {        
  }; 
  //Inherits everything from OccurrenceWidget
  InnerOccurrenceBasisOfRecordWidget.prototype = $.extend(true,{}, new OccurrenceWidget());
  
  /**
   * Re-defines the showAppliedFilters function, iterates over the selection list to get the selected values and then show them as applied filters. 
   */
  InnerOccurrenceBasisOfRecordWidget.prototype.showAppliedFilters = function() {
    if(this.filterElement != null) {
      var self = this;
      this.filterElement.find(".basis-of-record > li").each( function() {
        $(this).removeClass("selected");
        for(var i=0; i < self.appliedFilters.length; i++) {
          if(self.appliedFilters[i].key == $(this).attr("key") && !$(this).hasClass("selected")) {
            $(this).addClass("selected");
          }
        }
      });
    }
  };   
  
  InnerOccurrenceBasisOfRecordWidget.prototype.executeAdditionalBindings = function(){
    if(this.filterElement != null) {
      var self = this;
      this.filterElement.find(".basis-of-record > li").click( function() {
        if ($(this).hasClass("selected")) {
          self.removeFilter({value:$(this).attr("key"),key:""});
          $(this).removeClass("selected");
        } else {
          self.addAppliedFilter({value:$(this).attr("key"),key:""});
          $(this).addClass("selected");
        }
      });
    }
  };
  return InnerOccurrenceBasisOfRecordWidget;
})(jQuery,_,OccurrenceWidget);

/**
 * Widget that holds and displays the filters that have been applied to a Occurrence filter(parameter).
 * A filter can be removed and the refresh the results.
 */
var OccurrenceFilterWidget = (function ($,_,OccurrenceWidget) {

  /**
   * Default constructor.
   * templateId: id of the HTML template used by the widget.
   * closeEvent: function that is executes every time a filter is removed.
   * occurrenceWidget: an occurrence widget instance that handles the same filter type managed by the filter widget.
   */
  var InnerOccurrenceFilterWidget = function(templateId,closeEvent, occurrenceWidget){
    this.template = _.template($("#"+ templateId).html());
    this.onCloseEvent = closeEvent;
    this.occurrenceWidget = occurrenceWidget;
    this.filters = new Array();
  };

  //Prototype definition
  InnerOccurrenceFilterWidget.prototype = {
      
      //Object constructor
      constructor : InnerOccurrenceFilterWidget, 

      /**
       * Adds a filter item to the list and then displays the filter in the UI. 
       */
      applyFilter : function(filter) {
        var htmlFilter  = $(this.template(filter));
        this.addFilterItem(htmlFilter);
      },

      /**
       * Adds a filter to the list.
       */
      addFilter : function(filter){
        this.filters.push(filter);
      },

      /**
       * Gets the associated occurrence widget.
       */
      getOccurrenceWidget : function(){
        return this.occurrenceWidget;
      },

      /**
       * Initializes the widget. The filter is displayed in as a row in a HTML table identified by the selector "table.results tr.filters".
       */
      init : function(){
        var tableHeader = $("table.results tr.header");
        var filtersContainer = $("table.results tr.filters td ul");      
        if (filtersContainer.length == 0 && this.filters.length > 0) {  
          //creates the filter container if doesn't exist
          var containerTemplate = _.template($("#template-filter-container").html());
          tableHeader.after($(containerTemplate())); 
          filtersContainer = $("table.results tr.filters td ul");
        }
        //Adds the filter to the container
        if (this.filters.length > 0) {
          var filterTitle = $('a[data-filter=' +  this.filters[0].paramName + ']').attr('title');
          var htmlFilter  = $(this.template({title: filterTitle,paramName: this.filters[0].paramName,filters: this.filters}));          
          $(filtersContainer).append(htmlFilter);
          htmlFilter.fadeIn(FADE_TIME);
          this.bindCloseEvent(htmlFilter);
        }
      },

      /**
       * Removes a filter from the list. The occurrence widget is modified by removing the filter.
       */
      removeFilter : function(htmlFilter){
        var input = htmlFilter.find(":input[type=hidden]");      
        this.occurrenceWidget.removeFilter({key:input.attr("key"), value:input.val()});
      },

      /**
       * Binds the close/remove event to HTML element with the css class "closeFilter".
       */
      bindCloseEvent : function(htmlFilter){
        var self = this;
        htmlFilter.find(".closeFilter").each(function(idx,element){      
          $(element).click(function(e){
            e.preventDefault();
            var
            filterContainer = $(this).parent(),
            li = filterContainer.parent();
            filterContainer.fadeOut(FADE_TIME, function(){            
              self.removeFilter(filterContainer);
              $(this).remove();
              if(li.find("div.filter").length == 0){
                var ul = li.parent();
                li.remove();
                if(ul.find("li").length == 0) { // element about to be removed was the last one
                  //Removes the parent tr element
                  ul.parent().remove();
                }
              }
              //call the onCloseEvent if any
              self.onCloseEvent.call();
            });        
          });
        });
      }
  }

  return InnerOccurrenceFilterWidget;

})(jQuery,_,OccurrenceWidget);

/**
 * Object that controls the creation and default behavior of OccurrenceWidget and OccurrenceFilterWidget instances.
 * Manage how each filter widget should be bound to a occurrence widget instance, additionally controls what occurrence parameter is mapped to an specific widget.
 * This object should be instantiated only once in a page (Singleton).
 * 
 */
var OccurrenceWidgetManager = (function ($,_,OccurrenceWidget) {

  //All the fields are singleton variables
  var filterTemplate = "template-filter"; // template names for applied filters
  var widgets;
  var filterWidgets;
  var targetUrl;

  /**
   * Gets a occurrence widget instance by its id field.
   */
  function getWidgetById(id) {
    for (var i=0;i < widgets.length;i++) {
      if(widgets[i].getId() == id){ return widgets[i];}
    }
    return;
  };

  /**
   * Gets an occurrence filter widget by the id of the occurrence widget associated.
   */
  function getFilterWidgetById(id) {
    for (var i=0;i < filterWidgets.length;i++) {
      if(filterWidgets[i].getOccurrenceWidget().getId() == id){ return filterWidgets[i];}
    }
    return;
  };

  /**
   * Calculates visible position in the screen. The returned value of this function is used to display the "wait dialog" while a request is submitted to the server.
   */
  function getTopPosition(div) {
    return (( $(window).height() - div.height()) / 2) + $(window).scrollTop() - 50;
  };

  /**
   * Displays the "wait dialog" while a request is submitted to the server.
   */
  function showWaitDialog(){
    //Sets the position
    $('#waitDialog').css("top", getTopPosition($('#waitDialog')) + "px");
    //Shows the dialog
    $('#waitDialog').fadeIn("medium", function() { hidden = false; });
    //Append the dialog to the html.body
    $("body").append("<div id='lock_screen'></div>");
    //Locks the screen
    $("#lock_screen").height($(document).height());
    $("#lock_screen").fadeIn("slow");
  };
  
  /**
   * Truncates a decimal value to 2 decimals length of precision.
   */
  function truncCoord(value) {
    var newValue = value.toString();        
    var values = newValue.split('.');
    if (values.length > 1) {
      var decimalValue = values[1];
      if(decimalValue.length > 2) {
        decimalValue = decimalValue.slice(0, 3);
      }
      newValue = values[0] + '.' + decimalValue;
    }        
    return newValue;
  };


  /**
   * Default constructor for the widget manager.
   */
  var InnerOccurrenceWidgetManager = function(targetUrlValue,filters,controlSelector){
    widgets = new Array();
    filterWidgets = new Array();
    targetUrl = targetUrlValue;
    this.bindToWidgetsControl(controlSelector);
    this.initialize(filters);    
  };

  InnerOccurrenceWidgetManager.prototype = {                 

      //Constructor
      constructor : InnerOccurrenceWidgetManager,           

      /**
       * Gets the list of widgets.
       */
      getWidgets : function(){ return widgets;},

      /**
       * Binds the filter rendering to a click event of HTML element.
       * Creates an occurrence widgets depending of its names, for example: if the paramater name "DATE" exists an OccurrenceDateWidget instance is created.
       */
      bindToWidgetsControl : function(element) {
        var self = this;
        var widgetContainer = $("tr.header");
        this.targetUrl = targetUrl;
        //Iterates over all elements with class 'filter-control' in the current page
        $(element).find('.filter-control').each( function(idx,control) {
          //By examinig the attribute data-filter creates the corresponding OccurreWidget(or subtype) instance.
          //Also the binding function is set as parameter, for instance: elf.bindSpeciesAutosuggest. When a binding function isn't needed a empty function is set:  function(){}.
          var filterName = $(control).attr("data-filter");
          var newWidget;
          if(filterName == "TAXON_KEY"){
            newWidget = new OccurrenceWidget();
            newWidget.init({widgetContainer: widgetContainer,onApplyFilter: self.applyOccurrenceFilters,bindingsExecutor: self.bindSpeciesAutosuggest});
          }else if (filterName == "DATASET_KEY") {
            newWidget = new OccurrenceWidget();
            newWidget.init({widgetContainer: widgetContainer,onApplyFilter: self.applyOccurrenceFilters,bindingsExecutor: self.bindDatasetAutosuggest});            
          }else if (filterName == "COLLECTOR_NAME") {
            newWidget = new OccurrenceWidget();
            newWidget.init({widgetContainer: widgetContainer,onApplyFilter: self.applyOccurrenceFilters,bindingsExecutor: self.bindCollectorNameAutosuggest});            
          }else if (filterName == "CATALOG_NUMBER") {
            newWidget = new OccurrenceWidget();
            newWidget.init({widgetContainer: widgetContainer,onApplyFilter: self.applyOccurrenceFilters,bindingsExecutor: self.bindCatalogNumberAutosuggest});            
          }else if (filterName == "BOUNDING_BOX") {
            newWidget = new OccurrenceLocationWidget();
            newWidget.init({widgetContainer: widgetContainer,onApplyFilter: self.applyOccurrenceFilters,bindingsExecutor: self.bindMap});            
          }else if (filterName == "DATE") {
            newWidget = new OccurrenceDateWidget();
            newWidget.init({widgetContainer: widgetContainer,onApplyFilter: self.applyOccurrenceFilters,bindingsExecutor: function(){}});            
          }else if (filterName == "BASIS_OF_RECORD") {
            newWidget = new OccurrenceBasisOfRecordWidget();
            newWidget.init({widgetContainer: widgetContainer,onApplyFilter: self.applyOccurrenceFilters,bindingsExecutor: function(){}});              
          }                  
          else { //By default creates a simple OccurrenceWidget with an empty binding function
            newWidget = new OccurrenceWidget();
            newWidget.init({widgetContainer: widgetContainer,onApplyFilter: self.applyOccurrenceFilters,bindingsExecutor: function(){}});                      
          }
          newWidget.bindToControl(control);
          widgets.push(newWidget);
        });       
      },      
      /**
       * Binds the species auto-suggest widget used by the TAXON_KEY widget.
       */
      bindSpeciesAutosuggest: function(){
        $(':input.species_autosuggest').each( function(idx,el){
          $(el).speciesAutosuggest(cfg.wsClbSuggest, 4, "#nubTaxonomyKey[value]", "#content",false);
        });   
      },
      /**
       * Binds the dataset title auto-suggest widget used by the DATASET_KEY widget.
       */
      bindDatasetAutosuggest: function(){
        $(':input.dataset_autosuggest').each( function(idx,el){
          $(el).datasetAutosuggest(cfg.wsRegSuggest,4,"#content");
        });   
      },
      /**
       * Binds the collector name  auto-suggest widget used by the COLLECTOR_NAME widget.
       */
      bindCollectorNameAutosuggest : function(){        
        $(':input.collector_name_autosuggest').each( function(idx,el){
          $(el).termsAutosuggest(cfg.wsOccCollectorNameSearch, "#content",4);
        });        
      },
      /**
       * Binds the catalog number  auto-suggest widget used by the CATALOG_NAME widget.
       */
      bindCatalogNumberAutosuggest : function(){                
        $(':input.catalog_number_autosuggest').each( function(idx,el){
          $(el).termsAutosuggest(cfg.wsOccCatalogNumberSearch, "#content",4);
        });
      },
      
      /**
       * Binds the catalog number  auto-suggest widget used by the BBOX widget.
       */
      bindMap : function() {
        self = this;
        var CONFIG = { // global config var
            minZoom: 0,
            maxZoom: 14,
            center: [0, 0],
            defaultZoom: 1
        };
        var // see http://maps.cloudmade.com/editor for the styles - 69341 is named GBIF Original  
        cmAttr = 'Map data &copy; 2011 OpenStreetMap contributors, Imagery &copy; 2011 CloudMade',  
        cmUrl  = 'http://{s}.tile.cloudmade.com/BC9A493B41014CAABB98F0471D759707/{styleId}/256/{z}/{x}/{y}.png';

        var    
        minimal   = L.tileLayer(cmUrl, {styleId: 997,   attribution: cmAttr});

        map = L.map('map', {
          center: CONFIG.center,
          zoom: CONFIG.defaultZoom,
          layers: [minimal],
          zoomControl: true
        });

        var drawnItems = new L.LayerGroup();
        map.addLayer(drawnItems);
        var drawControl = new L.Control.Draw({
          position: 'topright',
          polygon: false,
          circle: false,
          marker:false,
          polyline:false
        });
        map.addControl(drawControl); 

        map.on('draw:rectangle-created', function (e) {
          drawnItems.clearLayers();
          drawnItems.addLayer(e.rect);
          var coords = e.rect.getLatLngs();
          $("#minLatitude").val(truncCoord(coords[1].lat));
          $("#minLongitude").val(truncCoord(coords[1].lng));
          $("#maxLatitude").val(truncCoord(coords[3].lat));
          $("#maxLongitude").val(truncCoord(coords[3].lng));                        
        });
      },

      /**
       * Applies the selected filters by issuing a request to target url.
       */
      applyOccurrenceFilters : function(){
        showWaitDialog();
        var params = {};         
        if($("#datasetKey").val()){
          params['datasetKey'] = $("#datasetKey").val();            
        }
        if($("#nubKey").val()){
          params['nubKey'] = $("#nubKey").val();
        }        
        var u = $.url();
        
        //Collect the filter values
        for(var wi=0; wi < widgets.length; wi++) {
          var widgetFilters = widgets[wi].getAppliedFilters();
          for(var fi=0; fi < widgetFilters.length; fi++){
            var filter = widgetFilters[fi];
            var filterId = widgets[wi].getId(); 
            if(params[filterId] == null){
              params[filterId] = new Array();
            }
            if (filter.key != null && filter.key.length > 0) {
              params[filterId].push(filter.key);
            } else {
              params[filterId].push(filter.value);              
            }                      
          }          
        }       
        //redirects the window to the target
        window.location = targetUrl + $.param(params,true);
        return true;  // submit?
      },    

      /**
       * Iterates over all the "filter widgets" and executes on each one the init() function.
       */
      initFilterWidgets : function(){
        for(var i=0; i < filterWidgets.length; i++){          
          filterWidgets[i].init();
        }
      },

      /**
       * Initializes the state of the module and renders the previously applied filters.
       */
      initialize: function(filters){
        var self = this;  
        //The filters parameter could be null or undefined when none filter has been interpreted from the HTTP request 
        if(typeof(filters) != 'undefined' && filters != null){              
          $.each(filters, function(key,filterValues){
            $.each(filterValues, function(idx,filter) {                                  
              var occWidget = getWidgetById(filter.paramName);
              if (occWidget != 'undefined') { //If the parameter doesn't exist avoids the initialization
                occWidget.addAppliedFilter(filter);    
                var filterWidget = getFilterWidgetById(filter.paramName);
                if(filterWidget == undefined){
                  filterWidget = new OccurrenceFilterWidget(filterTemplate,self.applyOccurrenceFilters,occWidget);
                  filterWidgets.push(filterWidget);
                } 
                filterWidget.addFilter(filter);
              }
            });
          });
          this.initFilterWidgets();
        }        
      }
  }
  return InnerOccurrenceWidgetManager;
})(jQuery,_,OccurrenceWidget);
