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

//Error CSS class for invalid input values.
var ERROR_CLASS = "error";

//predicates constants
//Greater than
var GT = "gt";

//Less than
var LT = "lt";

//Equals
var EQ = "eq";

// This is needed as a nasty way to address http://dev.gbif.org/issues/browse/POR-365
// The map is not correctly displayed, and requires a map.invalidateSize(); to be fired
// After the filter div is rendered.  Because of this the map scope is public.
var map;

//Markers to display the bounding box boundaries.
var bboxMarkerLeft = null, bboxMarkerRight = null;

/**
 * Base module that contains the base implementation for the occurrence widgets.
 * Contains the implementation for the basic operations: create the HTML control, apply filters, show the applied filters and close/hide the widget.
 */
var OccurrenceWidget = (function ($,_,OccurrenceWidgetManager) {  

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
        this.filters = new Array();
        this.widgetContainer = options.widgetContainer;
        this.isBound = false;
        this.id = null;
        this.filterElement = null;
        this.summaryView = null;
        this.manager = options.manager;
        this.bindingsExecutor = options.bindingsExecutor;
        this.summaryTemplate = options.summaryTemplate;
      },

      //IsBlank
      isBlank : isBlank,
      
      /**
       * Validates if the input string is unsigned integer.
       */
      isUnsignedInteger: function(s) {
        return (s.search(/^[0-9]+$/) == 0);
      },
      
      /**
       * Checks is the input value is a valid number.
       * isDecimal: true/false if the value is a decimal number or not.
       * minValue/maxValue: range of accepted values, could be null.
       */
      isValidNumber : function(value,isDecimal,minValue,maxValue){
        if(value.length > 0){
          var numValue;
          if(isDecimal){
            numValue = parseFloat(value);
          }else{            
            if(!this.isUnsignedInteger(value)){
              return false;
            }
            numValue = parseInt(value);
          }
          if (isNaN(numValue)) {
            return false;
          }
          var validMinValue = (minValue == null || (numValue >= minValue));
          var validMaxValue = (maxValue == null || (numValue <= maxValue));          
          return (validMinValue && validMaxValue);
        }
        return true;
      },

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
      getFilters : function(){return this.filters;},

      /**
       * Shows the HTML widget.
       */
      open : function(){    
        if (!this.isVisible()) {
          this.filterElement.fadeIn(FADE_TIME);
          this.showFilters();
          this.showEditView();
          this.toggleApplyButton();          
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
        if (this.filterElement != null) {          
          this.showSummaryView();
          this.filterElement.find('.edit').show();
        }
        //removes the filter that haven't been submitted
        this.removeNoSubmittedFilters();        
      },
     
      
      /**
       * Shows the summary view. Hides the filter edition view.
       */
      showSummaryView: function(){ 
        if(this.filterElement != null) {
          var submittedFilters = this.getFiltersBySubmitted(true); 
          if(submittedFilters.length > 0) {
            var filterView = this.filterElement.find('.filter_view');
            if (!this.isCreated()) {
              this.createHTMLWidget(this.control);
            }
            if (!this.filterElement.is(':visible')) {
              this.filterElement.fadeIn(FADE_TIME);
            }
            this.initSummaryView($(this.control).attr('title'),submittedFilters);            
            if (filterView.is(':visible')) {
              var self = this;
              filterView.fadeOut(FADE_TIME,function(){ self.filterElement.find('.summary_view').fadeIn(FADE_TIME);});
            }else {
              this.filterElement.find('.summary_view').fadeIn(FADE_TIME);
            }
            this.bindRemoveFilterEvent();
            this.bindSuggestions();
          } else {
            this.filterElement.fadeOut(FADE_TIME);
          }
        }
      }, 
      
      /**
       * Shows the edit view. Hides the filter summary view.
       */
      showEditView: function(){   
        var self = this;
        if (!this.isCreated()) {
          this.createHTMLWidget(this.control);          
        }
        this.filterElement.fadeIn(FADE_TIME);
        this.filterElement.find('.summary_view').fadeOut(FADE_TIME,function(){ self.filterElement.find('.filter_view').fadeIn(FADE_TIME, function(){
       // This is needed to address http://dev.gbif.org/issues/browse/POR-365 
          // The solution was found 
          if (map!=null) { 
            map.invalidateSize(); 
          }          
        });});
        self.filterElement.find('.edit').hide();
        this.showFilters();        
      }, 
      
      /**
       * Remove all the filter whose filter.submitted field is false.
       */
      removeNoSubmittedFilters : function() {
        for (var i = 0; i < this.filters.length; i++) {
          if(!this.filters[i].submitted){
            this.filters.splice(i,1);
            i--; // decrement since length has changed
          }
        }
      },
      
      /**
       * Gets all the filters whose filter.submitted field is equals to submitted.
       */
      getFiltersBySubmitted : function(submitted) {
        var filteredFilters = new Array();
        for (var i = 0; i < this.filters.length; i++) {
          if(this.filters[i].submitted == submitted){
            filteredFilters.push(this.filters[i]);
          }
        }
        return filteredFilters;
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
      applyFilter : function(filterP) {
        this.addFilter(filterP);
        this.manager.applyOccurrenceFilters(true);
      },
      
      /**
       * Hides/shows the apply button if there are filters to be applied.
       */
      toggleApplyButton: function() {
        if(this.filterElement != null) {
          if(this.getNoSubmittedFiltersCount() > 0) {
            this.filterElement.find(".apply").show();
          } else {
            this.filterElement.find(".apply").hide();
          }
        }
      },
      
      /**
       * Gets the number no submitted filters.
       */
      getNoSubmittedFiltersCount : function() {
        var noSubCount = 0;
        for (var i = 0; i < this.filters.length; i++) {
          if(!this.filters[i].submitted){
            noSubCount++;
          }
        }
        return noSubCount;
      },

      /**
       * Adds a filter to the list of filters.
       */
      addFilter : function(filter) {        
        if (!this.existsFilter(filter)) {
          this.filters.push(filter);
        }
        this.toggleApplyButton();
      },

      /**
       * Binds the widget to an HTML element.
       * The click event of the control parameters shows the widget.
       */
      bindToControl: function(control) {
        this.control = control;
        if(!this.getId()){                    
          this.setId($(control).attr("data-filter"));   
          var widget = this;
          widget.create($(control));
          widget.showSummaryView();
          $(control).on("click", function(e) {
            e.preventDefault();
            widget.showEditView();
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
       * Shows the list of html elements with the css class "filters". 
       */
      showFilters : function() {
        if(this.filterElement != null) { //widget was created          
          var appliedFilters = this.filterElement.find(".appliedFilters");
          //clears the HTML list of filters, the list is rebuilt each time this function is called
          appliedFilters.empty(); 
          //HTML element that will hold the list of filters
          var filtersContainer = $("<ul style='list-style: none;display:block;'></ul>"); 
          appliedFilters.append(filtersContainer); 
          //gets the HTML template for filters
          var templateFilter = _.template($("#template-applied-filter").html());
          var self = this;
          this.filterElement.find(".appliedFilters,.filtersTitle").toggle(this.filters.length > 0);
          for(var i=0; i < this.filters.length; i++) {
            //title field used for attribute <INPU title="currentFilter.title">
            var currentFilter = $.extend(this.filters[i], {title: this.filters[i].label, label:this.limitLabel(this.filters[i].label)});            
            var newFilter = $(templateFilter(currentFilter));
            if( i != this.filters.length - 1){
              $(newFilter).append('</br>');
            }
            //adds each filter to the list using the HTML template
            filtersContainer.append(newFilter);   
            //The click event of element with css class "closeFilter" handles the filter removing and applying the filters 
            newFilter.find(".closeFilter").click( function(e) {
              var input = $(this).parent().find(':input[name=' + self.getId() + ']');              
              self.removeFilter({value: input.val(), key: input.attr('key'), paramName: input.attr('name')});
              self.showFilters();
            });
          }          
        }
      },

      /**
       * Creates the HTML widget if it was not created previously, then the widget is shown.
       */
      create : function(control) {
        if (!this.isCreated()) {
          this.createHTMLWidget(control);          
        }
      },

      /**
       * Utility function that renders/creates the HTML widget.
       */
      createHTMLWidget : function(control){        
        var          
        placeholder = $(control).attr("data-placeholder"),
        templateFilter = $(control).attr("data-template-filter"),
        inputClasses = $(control).attr("data-input-classes") || {},
        title = $(control).attr("title"),
        template = _.template($("#" + templateFilter).html()),
        submittedFilters = this.getFiltersBySubmitted(true);

        this.filterElement = $(template({title:title, paramName: this.getId(), placeholder: placeholder, inputClasses: inputClasses }));        
        this.filterElement.find(".apply").hide();
        this.widgetContainer.after(this.filterElement);
        this.initSummaryView(title,submittedFilters);
        this.bindEditHover();
        this.bindCloseControl();
        this.bindAddFilterControl();
        this.bindApplyControl();     
        this.executeAdditionalBindings();        
      },
      
      /**
       * Binds the edit event on hover the filter container.
       */
      bindEditHover: function() {
        var self = this;
        this.filterElement.find('a.edit').click( function(e) {
          self.showEditView();
          $(this).hide();
        });
        
        this.filterElement.hover( 
            function(e){
              if(self.filterElement.find('.filter_view').is(':visible')){
                self.filterElement.find('.edit').hide();
                return;
              }
              if(self.summaryView.is(':visible')){
                self.filterElement.find('.edit').show();
              }
            },
            function(e){
              if(self.filterElement.find('.filter_view').is(':visible')){
                self.filterElement.find('.edit').hide();
                return;
              }
              if(self.summaryView.is(':visible')){
                self.filterElement.find('.edit').hide();
              }
            }
        );
      },
      
      /**
       * Initializes the summary view. It will be hidden by default.
       */
      initSummaryView : function(title,submittedFilters){
        var sumaryViewTemplate = _.template($("#" + this.summaryTemplate).html());        
        this.summaryView = this.filterElement.find('.summary_view'); 
        this.summaryView.html('');
        this.summaryView.prepend($(sumaryViewTemplate({paramName: this.getId(), title:title, filters: submittedFilters})));
        this.summaryView.hide();
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
       * Removes a filter and then re-display the list of filters.
       */
      removeFilter :function(filter) {        
        for (var i = 0; i < this.filters.length; i++) {
          if(this.filters[i].value == filter.value){
            var removedFilter = this.filters[i];
            this.filters.splice(i,1);            
            this.showFilters();
            if(removedFilter.submitted){
              this.filterElement.find(".apply").show();
            }
            return;            
          }
        }        
      },
      
      /**
       * Removes filters by the paramName field.
       */
      removeFilterByParamName :function(paramName) {        
        for(var i = 0; i < this.filters.length; i++){
          if(this.filters[i].paramName == paramName){
            this.filters.splice(i,1);         
            i--; //decrement since length has changed
          }
        }        
      },
      
      /**
       * Searches a filter by its value.
       */
      existsFilter :function(filterP) {        
        for(var i = 0; i < this.filters.length; i++){
          if(this.filters[i].value == filterP.value){
            return true;
          }
        }
        return false;
      },
      
      /**
       * Searches a filter by its value.
       */
      clearFilters :function() { 
        this.filters = new Array();
        this.showFilters();
        this.toggleApplyButton();
      },

      /**
       * Binds a widget apply control.
       * The apply control is used when the widgets handles several filters at a time and those should be submitted in one call.
       */
      bindApplyControl : function() {
        var self = this;
        this.filterElement.find("a.button[data-action]").click( function(e){
          if(self.filterElement.find(".addFilter").size() != 0) { //has and addFilter control
            //gets the value of the input field            
            var input = self.filterElement.find(":input[name=" + self.id + "]:first");                    
            var value = input.val();            
            if (!isBlank(value) && !self.existsFilter({value:value})) {
              var key = null;
              //Auto-complete widgets store the selected key in "key" attribute
              if (input.attr("key") !== undefined) {
                key = input.attr("key"); 
              }
              if ((typeof(value) != "string") && $.isArray(value)) {
                var values_idx = 0;
                while (values_idx < value.length) {
                  self.applyFilter({value: value[values_idx], key:key});
                  values_idx = values_idx + 1;
                }
              } else {
                self.applyFilter({value: value, key:key});
              }
              self.close();
            } else {
              self.manager.applyOccurrenceFilters(true);
            }
          } else {
            self.manager.applyOccurrenceFilters(true);
          }
        });  
      },      

      /**
       * The add filter control, handler how each individual filter is added to the list of filters.
       * The enter key, by default, adds/applies the filter.
       */
      bindAddFilterControl : function() {
        var self = this;
        var input = this.filterElement.find(":input[name=" + this.id + "]:first");
        if ($(input).hasClass('auto_add')) {
          input.keyup(function(event){
            if(event.keyCode == 13){
              self.addFilterControlEvent(self, input);
            }
          });
        }
        this.filterElement.find(".addFilter").click( function(e){          
          self.addFilterControlEvent(self, input);
        });  
      },

      /**
       * Binds the close/remove event to HTML element with the css class "closeFilter".
       */
      bindRemoveFilterEvent : function(){
        var self = this;
        this.filterElement.find(".closeFilter").each(function(idx,element){      
          $(element).click(function(e){
            e.preventDefault();
            var
            filterContainer = $(this).parent(),
            li = filterContainer.parent(),
            input = filterContainer.find(":input[type=hidden]");            
            self.removeFilter({key:input.attr("key"), value:input.val()});
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
              self.manager.applyOccurrenceFilters(true);
              self.removeUnusedSuggestionBoxes();
            });        
          });
        });
      },
      
      /**
       * Utility function that validates if the input value is valid (non-blank) and could be added to list of filters.
       */
      addFilterControlEvent : function (self,input){        
        //gets the value of the input field            
        var value = input.val();            
        if(!isBlank(value)){            
          var key = null;
          //Auto-complete stores the selected key in "key" attribute
          if (input.attr("key") !== undefined) {
            key = input.attr("key"); 
          }
          self.addFilter({label:value,value: value, key:key,paramName:self.getId(), submitted: false});            
          self.showFilters();
          input.val('');
        }
      },
      
      
      /**
       * Determines if a filter with value parameter exists.
       */
      hasFilterWithValue: function(value) {
        for(var i = 0;  i < this.filters.length; i++){
          if (this.filters[i].value == value) {
            return true;
          }
        }
        return false;
      },
      
      /**
       * Removes the suggestions boxes that are not applicable.
       * Some of them could be obsolete because the user previously selected a suggestion.
       */
      removeUnusedSuggestionBoxes: function() {
        var self = this;
        $(".suggestionBox[data-suggestion]").each( function(idx,el) {
          var suggestion = $(el).attr('data-suggestion');
          if(!self.hasFilterWithValue(suggestion)){
            $(el).remove();
          }
        });
      },
      
      /**
       * Binds the click(checked) event of a suggestion item to perform several actions: 
       * removed the old filter value, update the occurrence widget, replace the UI content and then adds the filter.
       */
      bindSuggestions: function() {
        var self = this;
        $('input.suggestion').click( function(e) {          
          var filterContainer = $('div.filter:has(input[value="'+ $(this).attr('data-sciname') +'"][type="hidden"])');
          if (filterContainer) {                         
            var thisValue = $(this).val();
            var newFilter = {label:$('label[for="nameUsageSearchResult' + thisValue + '"]').text(), paramName:$(this).attr('name'),value:thisValue,key:thisValue, submitted: false};            
            $(this).attr('checked',true);
            self.replaceFilterValues($(filterContainer).find(":input[type=hidden]").val(),newFilter);
            self.showSummaryView();            
            //remove the container div
            $(this).parent().remove();                       
            self.manager.applyOccurrenceFilters(true);  
            return true;
          }
        });
      },
      
      /**
       * Replace all the filters with filter.value == oldValue, with the values taken from parameter newFilter.
       */
      replaceFilterValues: function(oldValue, newFilter){
        for(var i = 0;  i < this.filters.length; i++){
          if(this.filters[i].value == oldValue){
            this.filters[i].value = newFilter.value;
            this.filters[i].key = newFilter.key;
            this.filters[i].label = newFilter.label;
          }
        }
      },
  }

  return InnerOccurrenceWidget;
})(jQuery,_,OccurrenceWidgetManager);

/**
 * Occurrence date widget. Allows specify single and range of dates.
 */
var OccurrenceDateWidget = (function ($,_,OccurrenceWidget) {
  
  var InnerOccurrenceDateWidget = function () {        
  };
  
  //Inherits everything from the OccurrenceWidget module.
  InnerOccurrenceDateWidget.prototype = $.extend(true,{}, new OccurrenceWidget());
  
  /**
   * Validates if the selected is acceptable: year is a valid number between 0 and maxValidYear, and monthValue must be selected is the year is not blank.
   */
  InnerOccurrenceDateWidget.prototype.isValidDate = function(yearValue, monthValue, maxValidYear, yearInputName, monthInputName) {    
    if((!this.isBlank(yearValue) && !this.isValidNumber(yearValue,false,0,maxValidYear)) || (monthValue != "0" && this.isBlank(yearValue))){
      this.filterElement.find(":input[name=" + yearInputName + "]:first").addClass(ERROR_CLASS);
      this.filterElement.find("#yearErrorMessage").show();
      return false;
    } else if (monthValue == "0" && !this.isBlank(yearValue)) {
      this.filterElement.find("#dk_container_" + monthInputName).addClass(ERROR_CLASS);
      return false;
    }
    return true;
  };
  
  /**
   * Validates if the date range is: yearMax > yearMin and monthMin < monthMax when yearMax == yearMin .
   */
  InnerOccurrenceDateWidget.prototype.isValidDateRange = function(yearMax, yearMin, monthMax, monthMin) {
    var intYearMax = parseInt(yearMax);
    var intYearMin = parseInt(yearMin);
    
    if(intYearMax < intYearMin) {
      this.filterElement.find("#yearRangeErrorMessage").show();
      this.filterElement.find(":input[name=yearMax]:first,:input[name=yearMin]:first").addClass(ERROR_CLASS);
      return false;
    }
    
    if( (intYearMax == intYearMin) && (parseInt(monthMin) > parseInt(monthMax))) {
      this.filterElement.find("#monthRangeErrorMessage").show();
      this.filterElement.find(":input[name=monthMax]:first,:input[name=monthMin]:first,#dk_container_monthMax,#dk_container_monthMin").addClass(ERROR_CLASS);      
      return false;
    }
    return true;
  };
  
  //The bindAddFilterControl is re-defined, the define dates are validated and then added.
  InnerOccurrenceDateWidget.prototype.bindAddFilterControl = function() {
    var self = this;
    $('.date-dropdown').dropkick(); // adds custom dropdowns
    
    $(document).on('click','#dk_container_monthMin > [class*="dk"], #dk_container_monthMax > [class*="dk"]', function(e) {      
        self.filterElement.find("#monthRangeErrorMessage").hide();
    });
    
    this.filterElement.find(":input[name=yearMin],:input[name=yearMax]").focus( function(e){
      self.filterElement.find(".year_error,.month_error").hide();
    });    
    
    this.filterElement.find('.helpPopup').each( function(idx,el){
      $(el).prepend('<img src="'+((cfg.context+"/img/icons/questionmark.png").replace("//", "/")) +'"/> ').sourcePopover({"title":$(el).attr("title"),"message":$(el).attr("data-message"),"remarks":$(el).attr("data-remarks")});
    });
    
    this.filterElement.find(".addFilter").click( function(e) { 
      e.preventDefault();   
      self.filterElement.find('.' + ERROR_CLASS).removeClass(ERROR_CLASS)
      self.filterElement.find("#monthRangeErrorMessage").hide();
      self.filterElement.find(".year_error,.month_error").hide();
      var maxValidYear = parseInt(self.filterElement.find(":input[name=max_year]").val());
      var monthMin = self.filterElement.find(":input[name=monthMin]:first").val();
      var yearMin  =  self.filterElement.find(":input[name=yearMin]:first").val();
      var monthMax = self.filterElement.find(":input[name=monthMax]:first").val();
      var yearMax  =  self.filterElement.find(":input[name=yearMax]:first").val();
      var value = "";
      var label = "";
      
      if(!self.isValidDate(yearMin,monthMin,maxValidYear,"yearMin","monthMin")){
        return;
      }      
    
      value = monthMin + "/" + yearMin;
      label = value;
      
      if(!self.isValidDate(yearMax,monthMax,maxValidYear,"yearMax","monthMax")){
        return;
      }      
      if(!self.isValidDateRange(yearMax, yearMin, monthMax, monthMin)){
        return;
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
        self.filterElement.find(".year_error").hide();
        self.filterElement.find("#monthRangeErrorMessage").hide();
        self.addFilter({label:label, value: value, key: '', paramName: self.getId(), submitted: false});
        self.showFilters();
        self.filterElement.find(":input[name=yearMax]:first,:input[name=yearMin]:first").val("");
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
      self.filterElement.find('.' + ERROR_CLASS).removeClass(ERROR_CLASS);
      var minLat = self.filterElement.find(":input[name=minLatitude]:first").val();
      var minLng = self.filterElement.find(":input[name=minLongitude]:first").val();
      var maxLat = self.filterElement.find(":input[name=maxLatitude]:first").val();
      var maxLng = self.filterElement.find(":input[name=maxLongitude]:first").val();
      
      if((!self.isBlank(minLat) && !self.isValidNumber(minLat,true,null,null)) || self.isBlank(minLat)){
        self.filterElement.find(":input[name=minLatitude]:first").addClass(ERROR_CLASS);
        return;
      }
      
      if((!self.isBlank(minLng) && !self.isValidNumber(minLng,true,null,null)) || self.isBlank(minLng)){
        self.filterElement.find(":input[name=minLongitude]:first").addClass(ERROR_CLASS);
        return;
      }
      
      if((!self.isBlank(maxLat) && !self.isValidNumber(maxLat,true,null,null)) || self.isBlank(maxLat)){
        self.filterElement.find(":input[name=maxLatitude]:first").addClass(ERROR_CLASS);
        return;
      }
      
      if((!self.isBlank(maxLng) && !self.isValidNumber(maxLng,true,null,null)) || self.isBlank(maxLng)){
        self.filterElement.find(":input[name=maxLongitude]:first").addClass(ERROR_CLASS);
        return;
      }
              
      var value = minLat + ',' + minLng + ',' + maxLat + ',' + maxLng;
      var label = "FROM " + minLat + ',' + minLng + ' TO ' + maxLat + ',' + maxLng;
      self.filterElement.find(":input").val('');
      self.addFilter({label: label, value: value, key: null, paramName: self.getId(), submitted: false});
      //GEOREFERENCED filters must be removed
      self.removeFilterByParamName('GEOREFERENCED');
      self.filterElement.find(':checkbox[name="GEOREFERENCED"]').removeAttr('checked');
      self.showFilters();      
    })
  };
  
  /**
   * Executes binding function bound during the object construction.
   */
  InnerOccurrenceLocationWidget.prototype.executeAdditionalBindings = function(){
    var self = this;
    self.bindingsExecutor.call();
    this.filterElement.find(':checkbox[name="GEOREFERENCED"]').change( function(e) {
      self.clearFilters();
      if ($(this).attr('checked')) {
        self.addFilter({label:$(this).val() == 'true' ?'Yes':'No',value: $(this).val(), key:  $(this).val(),paramName:'GEOREFERENCED', submitted: false});
        self.filterElement.find(':checkbox[name="GEOREFERENCED"][id!=' + $(this).attr('id') + ']').removeAttr('checked');
      }
    });
  };  
  
  return InnerOccurrenceLocationWidget;
})(jQuery,_,OccurrenceWidget);


/**
 * Comparator widget. Displays an selection list of available comparators (=,>,<) and an input box for the value.
 */
var OccurrenceComparatorWidget = (function ($,_,OccurrenceWidget) {
  
  var InnerOccurrenceComparatorWidget = function () {        
  }; 
  //Inherits everything from the OccurrenceWidget module.
  InnerOccurrenceComparatorWidget.prototype = $.extend(true,{}, new OccurrenceWidget());
  
  /**
   * Validates if the filter value exists for the input predicate.
   */
  InnerOccurrenceComparatorWidget.prototype.existsFilterWithPredicate = function(valueP,predicateP){
    if(predicateP == EQ) {
      return this.existsFilter({value: valueP});
    } else {
      return this.existsFilter({value: predicateP + ',' + valueP});
    }
  },
 
  /**
   * The bindAddFilterControl function is re-defined to validate and process the coordinates. 
   */
  InnerOccurrenceComparatorWidget.prototype.addFilterControlEvent = function (self,input) {        
    //gets the value of the input field            
    var value = input.val();     
    input.removeClass(ERROR_CLASS)
    var predicate = self.filterElement.find(':input[name=predicate] option:selected').val();
    var predicateText = self.filterElement.find(':input[name=predicate] option:selected').text();
    if(!self.isBlank(value) && !this.existsFilterWithPredicate(value, predicate)){            
      var key = "";
      //Auto-complete stores the selected key in "key" attribute
      if (input.attr("key") !== undefined) {
        key = input.attr("key"); 
      }
      if(self.isBlank(value) || (!self.isBlank(value) && !self.isValidNumber(value,false,null,null))){
        input.addClass(ERROR_CLASS);
        return;
      } 
      if(predicate == EQ) {
        self.addFilter({label:predicateText + ' ' + value,value: value, key:key,paramName:self.getId(),submitted: false});
      } else {
        self.addFilter({label:predicateText + ' ' + value,value: predicate + ',' + value, key:key,paramName:self.getId(),submitted: false});
      }
      self.showFilters();
      input.val('');
    }
  };      
  return InnerOccurrenceComparatorWidget;
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
   * Re-defines the showFilters function, iterates over the selection list to get the selected values and then show them as filters. 
   */
  InnerOccurrenceBasisOfRecordWidget.prototype.showFilters = function() {
    if(this.filterElement != null) {
      var self = this;
      this.filterElement.find(".basis-of-record > li").each( function() {
        $(this).removeClass("selected");
        for(var i=0; i < self.filters.length; i++) {
          if(self.filters[i].value == $(this).attr("key") && !$(this).hasClass("selected")) {
            $(this).addClass("selected");
          }
        }
      });
    }
  };   
  
  /**
   * Executes addtional bindings: binds click event of each basis of record element.
   */
  InnerOccurrenceBasisOfRecordWidget.prototype.executeAdditionalBindings = function(){
    if(this.filterElement != null) {
      var self = this;
      this.filterElement.find(".basis-of-record > li").click( function() {
        if ($(this).hasClass("selected")) {
          self.removeFilter({value:$(this).attr("key"),key:null});
          $(this).removeClass("selected");
        } else {
          self.addFilter({value:$(this).attr("key"),key:null,submitted: false,paramName:self.getId()});
          $(this).addClass("selected");
        }
      });
    }
  };
  return InnerOccurrenceBasisOfRecordWidget;
})(jQuery,_,OccurrenceWidget);

/**
 * Object that controls the creation and default behavior of OccurrenceWidget and OccurrenceFilterWidget instances.
 * Manage how each filter widget should be bound to a occurrence widget instance, additionally controls what occurrence parameter is mapped to an specific widget.
 * This object should be instantiated only once in a page (Singleton).
 * 
 */
var OccurrenceWidgetManager = (function ($,_) {

  //All the fields are singleton variables
  var filterTemplate = "template-filter"; // template name for filters
  var sciNamefilterTemplate = "sciname-template-filter";
  var widgets;
  var targetUrl;
  var submitOnApply = false;
  
  //Holds the list of the configuration setting when the page in loaded
  var initialConfParams;

  /**
   * Gets a occurrence widget instance by its id field.
   */
  function getWidgetById(id) {
    var widgetId = id;
    if(widgetId == 'GEOREFERENCED') { //GEOREFERENCED parameter is handled by BOUNDING_BOX widget
      widgetId = 'BOUNDING_BOX';
    }
    for (var i=0;i < widgets.length;i++) {
      if(widgets[i].getId() == widgetId){ return widgets[i];}
    }
    return;
  };
  
  function buildOnSelectHandler(paramName,el){
    return function (newFilter) {        
      var widget = getWidgetById(paramName);
      widget.addFilter($.extend({},newFilter,{paramName:paramName,submitted: false}));            
      widget.showFilters();
      $(el).val('');        
    };
  };

  /**
   * Calculates visible position in the screen. The returned value of this function is used to display the "wait dialog" while a request is submitted to the server.
   */
  function getTopPosition(div) {
    return (( $(window).height() - div.height()) / 2) + $(window).scrollTop() - 50;
  };
  
  /**
   * Gets the widget filter template using the filterName parameter.
   */
  function getFilterTemplate(filterName){
    if(filterName == 'TAXON_KEY'){ //only taxon key uses a different template
      return sciNamefilterTemplate;
    }
    return filterTemplate;
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
  var InnerOccurrenceWidgetManager = function(targetUrlValue,filters,controlSelector,submitOnApplyParam){
    widgets = new Array();
    targetUrl = targetUrlValue;
    submitOnApply = submitOnApplyParam;
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
          if (filterName != "GEOREFERENCED") { //this filter is skkiped because it uses the same widget as the bounding box widget
            var newWidget;
            var summaryTemplate = getFilterTemplate(filterName);
            if (filterName == "TAXON_KEY") {
              newWidget = new OccurrenceWidget();
              newWidget.init({widgetContainer: widgetContainer,manager: self,bindingsExecutor: self.bindSpeciesAutosuggest,summaryTemplate:summaryTemplate});
            } else if (filterName == "DATASET_KEY") {
              newWidget = new OccurrenceWidget();
              newWidget.init({widgetContainer: widgetContainer,manager: self,bindingsExecutor: self.bindDatasetAutosuggest,summaryTemplate:summaryTemplate});            
            } else if (filterName == "COLLECTOR_NAME") {
              newWidget = new OccurrenceWidget();
              newWidget.init({widgetContainer: widgetContainer,manager: self,bindingsExecutor: self.bindCollectorNameAutosuggest,summaryTemplate:summaryTemplate});            
            } else if (filterName == "CATALOG_NUMBER") {
              newWidget = new OccurrenceWidget();
              newWidget.init({widgetContainer: widgetContainer,manager: self,bindingsExecutor: self.bindCatalogNumberAutosuggest,summaryTemplate:summaryTemplate});            
            } else if (filterName == "BOUNDING_BOX") {
              newWidget = new OccurrenceLocationWidget();
              newWidget.init({widgetContainer: widgetContainer,manager: self,bindingsExecutor: self.bindMap,summaryTemplate:summaryTemplate});            
            } else if (filterName == "DATE") {
              newWidget = new OccurrenceDateWidget();
              newWidget.init({widgetContainer: widgetContainer,manager: self,bindingsExecutor: function(){},summaryTemplate:summaryTemplate});            
            } else if (filterName == "BASIS_OF_RECORD") {
              newWidget = new OccurrenceBasisOfRecordWidget();
              newWidget.init({widgetContainer: widgetContainer,manager: self,bindingsExecutor: function(){},summaryTemplate:summaryTemplate});              
            } else if (filterName == "COUNTRY") {
              newWidget = new OccurrenceWidget();
              newWidget.init({widgetContainer: widgetContainer,manager: self,bindingsExecutor: self.bindCountryAutosuggest,summaryTemplate:summaryTemplate});              
            } else if (filterName == "ALTITUDE" || filterName == "DEPTH") {
              newWidget = new OccurrenceComparatorWidget();
              newWidget.init({widgetContainer: widgetContainer,manager: self,bindingsExecutor: function(){},summaryTemplate:summaryTemplate});              
            } else { //By default creates a simple OccurrenceWidget with an empty binding function
              newWidget = new OccurrenceWidget();
              newWidget.init({widgetContainer: widgetContainer,manager: self,bindingsExecutor: function(){},summaryTemplate:summaryTemplate});                      
            }
            newWidget.bindToControl(control);
            widgets.push(newWidget);
          }
        });       
      },
      
      /**
       * Handles the click event to positioning the dropdown menus relative to the element that shows them.
       */
      centerDropDownMenus: function() {
        $('a.[data-toggle="dropdown"]').click( function(e){                    
          // .position() uses position relative to the offset parent, 
          var pos = $(this).position();

          var height = $(this).outerHeight();
          
          // .outerWidth() takes into account border and padding.
          var width = $(this).outerWidth();          

          //show the menu directly over the placeholder
          $('div.dropdown-menu').css({
              position: "absolute",
              top: (pos.top + height) + "px",
              left: (pos.left - (width/2)) + "px",
              right: width + "px"
          });
        });
      }, 
      
      /**
       * Binds the configure widget.
       */
      bindConfigureWidget: function() {
        var self = this; 
        
        //Apply the configuration settings
        $('div.configure > div.buttonContainer > #applyConfiguration.button').click( function(){
          $(this).parent().parent().hide();
          self.submit(self.getConfigurationParams());
        });
        
        // prevents the dropdown menu to be closed by the boostrap.min.js script
        $('div.configure').click( function(e) {           
          e.stopPropagation();          
        });
        
        //Ensures that the default values are set everytime the div is shown
        $('a.configure').click( function(e) {
          self.setPredefinedCheckboxesValues('occurrence_columns','columns');
          self.setPredefinedCheckboxesValues('summary_fields','summary');
        });
                
        //Ensures that at least 1 checkbox of summary fields exists
        $('#summary_fields li :checkbox').click( function(e){
          if($("#summary_fields li :checkbox[checked]").size() == 0){
            e.preventDefault();
          }
        });
      },
      
      /**
       * Utility function to set the checkboxes state using the default configuration settings.
       */
      setPredefinedCheckboxesValues: function(containerId,attribute) {
        if (initialConfParams[attribute]) {
          $('#'+ containerId + ' > li > :checkbox').each(function(idx,el){
            if($.inArray($(el).val(),initialConfParams[attribute]) > -1){
              $(this).attr('checked',true);
            } else {
              $(this).removeAttr('checked');
            }
          });
        }
      },
      
      /**
       * Iterates over the checkboxes to get the values for columns and summary fiels that must be displayed.
       */
      getConfigurationParams : function(){       
        var params = {};
        $('#occurrence_columns li :checkbox, #summary_fields li :checkbox').each(function(idx,el){
          if($(el).attr('checked')) {
            var paramName = $(el).attr('name');
            if (params[paramName] == null) {
              params[paramName] = new Array();
            }
            params[paramName].push($(el).val());
          }
        });
        return params;
      },
      
      /**
       * Binds the species auto-suggest widget used by the TAXON_KEY widget.
       */
      bindSpeciesAutosuggest: function(){
        $(':input.species_autosuggest').each( function(idx,el){
          $(el).speciesAutosuggest(cfg.wsClbSuggest, 4, "#nubTaxonomyKey[value]", "#content",buildOnSelectHandler('TAXON_KEY',el));
        });   
      },
      
      /**
       * Binds the species auto-suggest widget used by the TAXON_KEY widget.
       */
      bindCountryAutosuggest: function(){        
        var self = this;
        $(':text[name="COUNTRY"]').each( function(idx,el){
          $(el).countryAutosuggest(countryList,"#content",buildOnSelectHandler('COUNTRY',el));
        });   
      },
      
      /**
       * Binds the dataset title auto-suggest widget used by the DATASET_KEY widget.
       */
      bindDatasetAutosuggest: function(){        
        $(':input.dataset_autosuggest').each( function(idx,el){
          $(el).datasetAutosuggest(cfg.wsRegSuggest, 6,"#content", buildOnSelectHandler('DATASET_KEY',el));
        });   
      },
      
      /**
       * Binds the collector name  auto-suggest widget used by the COLLECTOR_NAME widget.
       */
      bindCollectorNameAutosuggest : function(){        
        $(':input.collector_name_autosuggest').each( function(idx,el){
          $(el).termsAutosuggest(cfg.wsOccCollectorNameSearch, "#content",4,buildOnSelectHandler('COLLECTOR_NAME',el));
        });        
      },
      
      /**
       * Binds the catalog number  auto-suggest widget used by the CATALOG_NUMBER widget.
       */
      bindCatalogNumberAutosuggest : function(){                
        $(':input.catalog_number_autosuggest').each( function(idx,el){
          $(el).termsAutosuggest(cfg.wsOccCatalogNumberSearch, "#content",4, buildOnSelectHandler('CATALOG_NUMBER',el));
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
          if(bboxMarkerLeft != null){
            map.removeLayer(bboxMarkerLeft);
          }          
          if(bboxMarkerRight != null){
            map.removeLayer(bboxMarkerRight);
          }
          
          drawnItems.clearLayers();
          drawnItems.addLayer(e.rect);
          var coords = e.rect.getLatLngs();
          $("#minLatitude").val(truncCoord(coords[0].lat));
          $("#minLongitude").val(truncCoord(coords[0].lng));
          $("#maxLatitude").val(truncCoord(coords[2].lat));
          $("#maxLongitude").val(truncCoord(coords[2].lng));         
          bboxMarkerLeft = L.marker(coords[0]).addTo(map);
          bboxMarkerLeft.bindPopup('Location ' + coords[0]);
          bboxMarkerRight = L.marker(coords[2]).addTo(map);
          bboxMarkerRight.bindPopup('Location ' + coords[2]);
        });            
      },

      /**
       * Applies the selected filters by issuing a request to target url.
       */
      applyOccurrenceFilters : function(refreshFilters){        
        if (refreshFilters) {
          this.addFiltersFromWidgets();
        }
        //if this.submitOnApply the elements are not submitted
        if (submitOnApply) {        
          return this.submit({});
        }
      },    
      
      /**
       * Reads the filters on each widget and then creates the filter widgets.
       */
      addFiltersFromWidgets : function() {
       var filters = new Object();
        var i = widgets.length - 1;
        while (i >= 0) {
          var appliedFilters = widgets[i].getFilters();
          var filters_idx =  appliedFilters.length - 1;
          while (filters_idx >= 0) {
            if(filters[widgets[i].getId()] == undefined){
              filters[widgets[i].getId()] = new Array();
            }
            filters[widgets[i].getId()].push(appliedFilters[filters_idx]);
            filters_idx=filters_idx-1;
          }
          widgets[i].close();
          i=i-1;
        }
        this.initialize(filters);
      },
      
      /**
       * Submits the request using the selected filters.
       */
      submit : function(additionalParams, submitTargetUrl){
        submitTargetUrl = submitTargetUrl || targetUrl;
        showWaitDialog();
        var params = $.extend({},additionalParams);               
        
        //Collect the filter values
        for(var wi=0; wi < widgets.length; wi++) {
          var widgetFilters = widgets[wi].getFilters();
          for(var fi=0; fi < widgetFilters.length; fi++){
            var filter = widgetFilters[fi];
            var paramName = filter.paramName;
            if(undefined == filter.paramName){              
              paramName = widgets[wi].getId();
            }
            if (params[paramName] == null) {
              params[paramName] = new Array();
            }
            if (filter.key != null) {
              //key field could be a string or a number, but is sent as a string
              if($.type(filter.key) == 'string' && filter.key.length > 0){
                params[paramName].push(filter.key);
              } else if ($.type(filter.key) == 'number'){
                params[paramName].push(filter.key.toString());
              }
            } else {
              params[paramName].push(filter.value);              
            }                      
          }          
        }       
        //redirects the window to the target
        window.location = submitTargetUrl + $.param(params,true);
        return true;  // submit?
      },

      /**
       * Iterates over all the "filter widgets" and executes on each one the init() function.
       */
      initWidgets : function(){
        for(var i=0; i < widgets.length; i++){          
          widgets[i].showSummaryView();          
        }
      },
     
      /**
       * Initializes the state of the module and renders the previously submitted filters.
       */
      initialize: function(filters){
        var self = this;  
        //The filters parameter could be null or undefined when none filter has been interpreted from the HTTP request 
        if(typeof(filters) != undefined && filters != null) {              
          $.each(filters, function(key,filterValues){
            $.each(filterValues, function(idx,filter) {                                  
              var occWidget = getWidgetById(filter.paramName);
              if (occWidget != undefined) { //If the parameter doesn't exist avoids the initialization
                occWidget.addFilter(filter);                    
              }
            });
          });
          this.initWidgets();
        }
        this.centerDropDownMenus();
        initialConfParams = this.getConfigurationParams();
        this.bindConfigureWidget();            
      }
  }
  return InnerOccurrenceWidgetManager;
})(jQuery,_);

