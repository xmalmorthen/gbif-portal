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

var FADE_TIME = 250;
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
        //this.bindToControl(control);
        this.onApplyFilterEvent = options.onApplyFilter;
        this.bindingsExecutor = options.bindingsExecutor;
      },
      
      //IsBlank
      isBlank : isBlank,
      
      getId : function() {
         return this.id;
      },
      
      setId : function(id) {
        this.id = id;
     },
     
     getAppliedFilters : function(){return this.appliedFilters;},
      
     open : function(){    
        if (!this.isVisible()) {
          this.filterElement.fadeIn(FADE_TIME);
          this.showAppliedFilters();
        }
      },
      
      isCreated : function(){
        return (this.filterElement)
      },
      
      close : function(){      
        this.filterElement.fadeOut(FADE_TIME);
      },
      
      isVisible : function(){
        return ($(this.filterElement).is(':visible'));
      },
      
      applyFilter : function(filter) {
        this.addAppliedFilter(filter);
        this.onApplyFilterEvent.call();
      },
      
      addAppliedFilter :function(filter){
        this.appliedFilters.push(filter);
      },
      
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
      
      showAppliedFilters : function() {
        if(this.filterElement != null) {
          var appliedFilters = this.filterElement.find(".appliedFilters");
          appliedFilters.empty();
          var filtersContainer = $("<ul style='list-style: none;display:block;'></ul>"); 
          appliedFilters.append(filtersContainer); 
          var templateFilter = _.template($("#template-applied-filter").html());
          var self = this;
          for(var i=0; i < this.appliedFilters.length; i++) {
            var currentFilter = this.appliedFilters[i];
            var newFilter = $(templateFilter({title:currentFilter.value, paramName: this.getId(), key: currentFilter.key, value: currentFilter.value}));
            filtersContainer.append(newFilter);          
            newFilter.find(".closeFilter").click(function(e){
              self.removeFilter(currentFilter);
              self.showAppliedFilters();
            });
          }
        }
      },
      
      addFilter : function(control) {
        if (!this.isCreated()) {
          this.createHTMLWidget(control);
        }
        this.open(); 
      },
      
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
      
      executeAdditionalBindings : function(){this.bindingsExecutor.call();},
     
      bindCloseControl : function () {
        var self = this;
        this.filterElement.find(".close").click(function(e) {
          e.preventDefault();
          self.close();
        });
      },
      
      removeFilter :function(filter) {        
        for(var i = 0; i < this.appliedFilters.length; i++){
          if(this.appliedFilters[i].value == filter.value){
            if(this.appliedFilters[i].key && (this.appliedFilters[i].key == filter.key)){
              this.appliedFilters.splice(i,1);
              this.showAppliedFilters();
              return;
            } else {
              this.appliedFilters.splice(i,1);
              this.showAppliedFilters();
              return;
            }
          }
        }
      },
      
      bindApplyControl : function() {
        var self = this;
        this.filterElement.find("a.button[data-action]").click( function(e){
          if(self.filterElement.find(".addFilter").size() == 0) { //has and addFilter control
            //gets the value of the input field            
            var input = self.filterElement.find(":input[name=" + self.id + "]:first");                    
            var value = input.val();            
            if(!isBlank(value)){            
              var key = "";
              //Autocompletes store the selected key in "key" attribute
              if (input.attr("key") !== undefined) {
                key = input.attr("key"); 
              }
              if($.isArray(value)) {
                for (var i = 0; i < value.length;i++) {
                  self.applyFilter({value: value[i], key:key});
                }
              } else {
                self.applyFilter({value: value, key:key});
              }
              self.close();
            }
          }else {
            self.onApplyFilterEvent.call();
          }
        });  
      },      
      
      
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
      
      addFilterControlEvent : function (self,input){        
        //gets the value of the input field            
        var value = input.val();            
        if(!isBlank(value)){            
          var key = "";
          //Autocompletes store the selected key in "key" attribute
          if (input.attr("key") !== undefined) {
            key = input.attr("key"); 
          }
          self.addAppliedFilter({value: value, key:key});            
          self.showAppliedFilters();
          input.val('');
        }
      }
  }
  
  return InnerOccurrenceWidget;
})(jQuery,_);

var OccurrenceDateWidget = (function ($,_,OccurrenceWidget) {
   var InnerOccurrenceDateWidget = function () {        
   }; 
   InnerOccurrenceDateWidget.prototype = $.extend(true,{}, new OccurrenceWidget());
   InnerOccurrenceDateWidget.prototype.bindAddFilterControl = function() {
        var self = this;
        this.filterElement.find(".addFilter").click( function(e) { 
        e.preventDefault();   
        var monthMin = self.filterElement.find(":input[name=monthMin]:first").val();
        var yearMin  =  self.filterElement.find(":input[name=yearMin]:first").val();
        var monthMax = self.filterElement.find(":input[name=monthMax]:first").val();
        var yearMax  =  self.filterElement.find(":input[name=yearMax]:first").val();
        var value = "";
        if(!self.isBlank(yearMin) && monthMin != "0"){
          value = monthMin + "/" + yearMin;
        }
        if(!self.isBlank(yearMax) && monthMax != "0"){
          if(!self.isBlank(value)){
            value = value + ",";
          }
          value = value + monthMax + "/" + yearMax;
        }
        if(!self.isBlank(value)) {
          self.addAppliedFilter({value: value, monthMin: monthMin, yearMin: yearMin, monthMax: monthMax, yearMax: yearMax});
          self.showAppliedFilters();
         }
        })
     };       
  return InnerOccurrenceDateWidget;
})(jQuery,_,OccurrenceWidget);


var OccurrenceLocationWidget = (function ($,_,OccurrenceWidget) {
  var InnerOccurrenceLocationWidget = function () {        
  }; 
  InnerOccurrenceLocationWidget.prototype = $.extend(true,{}, new OccurrenceWidget());
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
         self.filterElement.find(":input").val('');
         self.addAppliedFilter({value: value, key: ''});       
         self.showAppliedFilters();
        }
       })
    };      
 return InnerOccurrenceLocationWidget;
})(jQuery,_,OccurrenceWidget);


var OccurrenceBasisOfRecordWidget = (function ($,_,OccurrenceWidget) {
  var InnerOccurrenceBasisOfRecordWidget = function () {        
  }; 
  InnerOccurrenceBasisOfRecordWidget.prototype = $.extend(true,{}, new OccurrenceWidget());
  InnerOccurrenceBasisOfRecordWidget.prototype.showAppliedFilters = function() {
      if(this.filterElement != null) {
         var self = this;
         this.filterElement.find("select[name='basisOfRecord'] > option").each( function() {
           $(this).removeAttr("selected");
           for(var i=0; i < self.appliedFilters.length; i++) {
             if(self.appliedFilters[i].value == $(this).val() && $(this).attr("selected") == undefined) {
               $(this).attr("selected","selected");
             }
            }
         });
      }
    };   
 return InnerOccurrenceBasisOfRecordWidget;
})(jQuery,_,OccurrenceWidget);

var OccurrenceFilterWidget = (function ($,_,OccurrenceWidget) {
  
  var InnerOccurrenceFilterWidget = function(templateId,closeEvent, occurrenceWidget){
    this.template = _.template($("#"+ templateId).html());
    this.onCloseEvent = closeEvent;
    this.occurrenceWidget = occurrenceWidget;
    this.filters = new Array();
  };
   
  InnerOccurrenceFilterWidget.prototype = {
     constructor : InnerOccurrenceFilterWidget, 
     
     applyFilter : function(filter) {
       var htmlFilter  = $(this.template(filter));
       this.addFilterItem(htmlFilter);
     },
     
     addFilter : function(filter){
       this.filters.push(filter);
     },
     
     getOccurrenceWidget : function(){
       return this.occurrenceWidget;
     },
     
     
     init : function(){
       var tableHeader = $("table.results tr.header");
       var filtersContainer = $("table.results tr.filters td ul");      
       if (filtersContainer.length == 0 && this.filters.length > 0) {       
         var containerTemplate = _.template($("#template-filter-container").html());
         tableHeader.after($(containerTemplate())); 
         filtersContainer = $("table.results tr.filters td ul");
       }
       if (this.filters.length > 0) {
         var htmlFilter  = $(this.template({title: this.filters[0].title,paramName: this.filters[0].paramName,filters: this.filters}));          
         $(filtersContainer).append(htmlFilter);
         htmlFilter.fadeIn(FADE_TIME);
         this.bindCloseEvent(htmlFilter);
       }
     },
     
    
    removeFilter : function(htmlFilter){
      var input = htmlFilter.find(":input[type=hidden]");      
      this.occurrenceWidget.removeFilter({key:input.attr("key"), value:input.val()});
    },
    
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

var OccurrenceWidgetManager = (function ($,_,OccurrenceWidget) {
  
  var filterTemplate = "template-filter"; // template names for applied filters
  var widgets;
  var filterWidgets;
  var targetUrl;
  
  function getWidgetById(id) {
    for (var i=0;i < widgets.length;i++) {
      if(widgets[i].getId() == id){ return widgets[i];}
    }
    return;
  };
  
  function getFilterWidgetById(id) {
    for (var i=0;i < filterWidgets.length;i++) {
      if(filterWidgets[i].getOccurrenceWidget().getId() == id){ return filterWidgets[i];}
    }
    return;
  };
  
  function formatLabelByFilter(filter) {
    var label = filter.label;
    if(filter.paramName == 'date') {
      var values = filter.value.split(',');
      if(values.length > 0){
        label = values[0] + " TO " + values[1];
      }                
    }else if(filter.paramName == 'bbox') {
      var values = filter.value.split(',');
      label = values[0] + ',' + values[1] + " TO " + values[2] + ',' + values[3];                
    }
    return label;
  };
  
  
  
  var InnerOccurrenceWidgetManager = function(targetUrlValue,filters,controlSelector){
    widgets = new Array();
    filterWidgets = new Array();
    targetUrl = targetUrlValue;
    this.bindToWidgetsControl(controlSelector);
    this.initialize(filters);    
  };
  
  InnerOccurrenceWidgetManager.prototype = {                 
      
      constructor : InnerOccurrenceWidgetManager,           
      
      getWidgets : function(){ return widgets;},
      
      /**
       * Binds the filter rendering to a click event of HTML element.
       */
      bindToWidgetsControl : function(element) {
        var self = this;
        var widgetContainer = $("tr.header");
        this.targetUrl = targetUrl;
        $(element).find('.filter-control').each( function(idx,control){
          var filterName = $(control).attr("data-filter");
          var newWidget;
          if(filterName == "TAXON_KEY"){
            newWidget = new OccurrenceWidget();
            newWidget.init({widgetContainer: widgetContainer,onApplyFilter: self.applyOccurrenceFilters,bindingsExecutor: self.bindSpeciesAutosuggest});
          }else if (filterName == "COLLECTOR_NAME") {
            newWidget = new OccurrenceWidget();
            newWidget.init({widgetContainer: widgetContainer,onApplyFilter: self.applyOccurrenceFilters,bindingsExecutor: self.bindCollectorNameAutosuggest});            
          }else if (filterName == "CATALOGUE_NUMBER") {
            newWidget = new OccurrenceWidget();
            newWidget.init({widgetContainer: widgetContainer,onApplyFilter: self.applyOccurrenceFilters,bindingsExecutor: self.bindCatalogueNumberAutosuggest});            
          }else if (filterName == "BBOX") {
            newWidget = new OccurrenceLocationWidget();
            newWidget.init({widgetContainer: widgetContainer,onApplyFilter: self.applyOccurrenceFilters,bindingsExecutor: self.bindMap});            
          }else if (filterName == "DATE") {
            newWidget = new OccurrenceDateWidget();
            newWidget.init({widgetContainer: widgetContainer,onApplyFilter: self.applyOccurrenceFilters,bindingsExecutor: function(){}});            
          }else if (filterName == "BASIS_OF_RECORD") {
            newWidget = new OccurrenceBasisOfRecordWidget();
            newWidget.init({widgetContainer: widgetContainer,onApplyFilter: self.applyOccurrenceFilters,bindingsExecutor: function(){}});              
          }                  
          else {
            newWidget = new OccurrenceWidget();
            newWidget.init({widgetContainer: widgetContainer,onApplyFilter: self.applyOccurrenceFilters,bindingsExecutor: function(){}});                      
          }
          newWidget.bindToControl(control);
          widgets.push(newWidget);
        });       
      },      
      bindSpeciesAutosuggest: function(){
        $(':input.species_autosuggest').each( function(idx,el){
          $(el).speciesAutosuggest(cfg.wsClbSuggest, 4, "#nubTaxonomyKey[value]", "#content",false);
        });   
      },

      bindCollectorNameAutosuggest : function(){        
        $(':input.collector_name_autosuggest').each( function(idx,el){
          $(el).termsAutosuggest(cfg.wsOccCollectorNameSearch, "#content",4);
        });        
      },
      
      bindCatalogueNumberAutosuggest : function(){                
        $(':input.catalogue_number_autosuggest').each( function(idx,el){
          $(el).termsAutosuggest(cfg.wsOccCatalogueNumberSearch, "#content",4);
        });
      },
      
      /**
       * Binds/initializes the map widget.
       */
      bindMap : function() {
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

        var map = L.map('map', {
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
          $("#minLatitude").val(coords[1].lat);
          $("#minLongitude").val(coords[1].lng);
          $("#maxLatitude").val(coords[3].lat);
          $("#maxLongitude").val(coords[3].lng);                        
        });
      },
      
      /**
       * Function that applies the selected filters issuing a request to target url.
       */
      applyOccurrenceFilters : function(){
        var params = {};         
        if($("#datasetKey").val()){
          params['datasetKey'] = $("#datasetKey").val();            
        }
        if($("#nubKey").val()){
          params['nubKey'] = $("#nubKey").val();
        }        
        var u = $.url();
        
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
        window.location = targetUrl + $.param(params,true);
        return true;  // submit?
      },     
     
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
        if(typeof(filters) != 'undefined' && filters != null){              
          $.each(filters, function(key,filterValues){
            $.each(filterValues, function(idx,filter) {              
              filter.label = formatLabelByFilter(filter);              
              var occWidget = getWidgetById(filter.paramName);
              if (occWidget != 'undefined') {
                occWidget.addAppliedFilter({key:filter.key,value:filter.value})     
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
