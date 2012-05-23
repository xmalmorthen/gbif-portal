/**
 * This library provides the functionality for the filters used to construct criteria for 
 * (e.g.) downloads.  This is built on JQuery-UI with a dependency only of the core and
 * widgets within the JQuery UI project.
 *
 * This contains 2 Widgets:
 *  - Filter providing the means to select the subject, predicate and the value of the 
 *    criteria.  This is driven by a JSON configuration file.
 *
 *  - Query providing a summary view of the query as constructed by filter parts.
 * 
 * Author: Tim Robertson
 */
(function($) {

  /**
   * The filters are driven entirely by JSON configuration.
   * When a filter is added, the addFilter event is broadcast, allowing other widgets
   * to be wired up to this.
   */
  $.widget("gbif.Filter", {
    options: {
  addFilter: $.noop,  // avoid nulls, allow overriding during construction
    },
    
    // call the JSON over AJAX
    _init: function() {
  var self = this.element;
	  this._loadData(this.options.json);
	  this._renderSubjectSelector();
	  this.filterContainer = $("<SPAN/>").appendTo(self);
	  this._renderAddFilter();
	  this.descriptionContainer = $("<DIV class='description'/>").appendTo(self);
	  this.subjectSelect.change();
	  this._deserialize(); // set up any existing filters from the URL
    },
    
    // utilities for setting the subject, predicate and value
    _setSubject: function(val) {
  this.filter.subject = val;
    },
    _setPredicate: function(val) {
  this.filter.predicate = val;
    },
    _setValue: function(val) {
  this.filter.value = val;
    },
    _setSubjectId: function(val) {
  this.filter.subjectId = val;
    },
    _setPredicateId: function(val) {
  this.filter.predicateId = val;
    },
    
    // Loads and stores the data from ajax using a synchronous call (hence not the $json method)
    _loadData: function(url) {
  var that = this;
  console.log("Loading JSON from " + url);
  $.ajax({
    type: 'GET', url: url, async: false, dataType: 'json',
      success: function(data) { 
      console.log("Loaded JSON from " + url);
      that.data = data; 
      }, 
    });  
    },
    
    // Renders the subject selector and broadcasts the changed event
    _renderSubjectSelector: function() {
    console.log("Setting up the subject selector");
  var that = this;
  var self = this.element;
  console.log("Reading JSON to populate subject selector");
  var el = $('<SELECT/>').addClass("subject");
  that.subjectSelect = el;  // to be accessible from other methods
  $.each(that.data.filters, function () {
    var el2 = $("<optgroup label=" + this.group + "/>").appendTo(el);
    $.each(this.options, function () {
      el2.append($('<OPTION></OPTION>').attr('value',this.name).text(this.name));    
    });  
  });
  el.appendTo(self);
  // broadcast changes on the "changed" event
  el.bind('change', function(event) {
    $.each(that.data.filters, function (i, filter) {    
      $.each(this.options, function (i2, filter) {
      if ($(el,"option:selected").val() == filter.name) {
    console.log("Detected subject change to " + el.val());
    that._setSubject(el.val());
    that._setSubjectId(filter.id);
    that._setPredicate(null);
    that._setPredicateId(null);
    that._setValue(null);
    that._renderFilter(filter);
    that.descriptionContainer.html(filter.description);
      }
      });
    });    
  });
  
    },
    
    // utility to allow this to be called from various places
    _fireAddFilter: function() {
	  console.log("Firing the addFilter event");
	  this._trigger('addFilter', null, {filter : this.filter});
    },
    
    // Renders the add filter button, registers the addFilter event
    _renderAddFilter: function() {
  var that = this;
  var self = this.element;
	  that.filter = $("<SPAN/>");
	  that.filter.appendTo(self);
	  
	  that.addFilter = $("<INPUT type='submit' value='Add filter'></INPUT>");
	  // Register the add filter event for public subscription
	  that.addFilter.bind('click', function(event) {
	    that._fireAddFilter();
	  });
	  that.addFilter.appendTo(self);
	},
    
    // Renders the filter calling the renderer by name using bracket notation i.e. ['name']()
    _renderFilter: function(filter) {
  console.log("Rendering filter: " + filter.renderer);
  this.filterContainer[filter.renderer]({parent:this, data:filter.data});
    },
    
    // reads the params from the URL, and sets up the filters on the display
    _deserialize: function() {
  var that = this;
  var loop = true;
  var i=0;
  while(loop) {
    var subjectId = $.url().param('f[' + i + '].s');
    var predicateId = $.url().param('f[' + i + '].p');
    var value = $.url().param('f[' + i + '].v');
		
		if (subjectId != null && predicateId != null && value != null) {
		  // we have a filter from the URL
		  console.log(subjectId + ": " + predicateId + ": " + value);
		  
		  // find the appropriate filter to get the displayable info
		  // this iterates groups (Taxonomy, Geospatial etc)
      $.each(that.data.filters, function (i, filter) {    
    // this iterates options in the group (Scientific name, common name etc)
    $.each(this.options, function (i2, filter) {
      if (subjectId == filter.id) {
        that._setSubject(filter.name);
        that._setSubjectId(filter.id);
        
        // find the chosen predicate
        $.each(filter.data.predicate, function (i3, predicate) {
      if (predicate.value == predicateId) {
        that._setPredicate(predicate.label);
      }
        });
        
        that._setPredicateId(predicateId);
        that._setValue(value);
        console.log(subjectId + ": " + predicateId + ": " + value);
        that._fireAddFilter();
      }
    });
      });
		  
		} else {
		  loop = false;
		}
		
    i++;
  }
  
  // we need to reset the filter to the original values
  // changing the subject selector fires all the initialization
  that.subjectSelect.trigger('change');
    }
    
  });
  
  // Renders a select with a text box input
  $.widget("gbif.SelectAndTextbox", {  
    _init : function() {
  var that = this;
  var self = this.element;
  var parent = this.options.parent; // the owning widget
  var data = this.options.data;
  
  console.log("Rendering SimpleSelect");
  var el = $('<SELECT/>').addClass("predicate");
  this.predicate = el;
  $.each(data.predicate, function () {
    el.append($('<OPTION></OPTION>').attr('value',this.value).text(this.label));    
  });
  el.bind('change', function(event) {
    parent._setPredicate($(el).find("option[value='" + el.val() + "']").text());
    parent._setPredicateId(el.val());
  });    
  el.change();
  
  // TODO: CSS-ify the width
  this.value = $('<INPUT SIZE="30"/>');
  
  this.value.bind('change', function(e) {
    console.log("Filter value changed to " + e.target.value);
    parent._setValue(e.target.value);
  });    
  
  // trigger an add filter on carriage return
  this.value.bind('keypress', function(e) {
    var code = (e.keyCode ? e.keyCode : e.which);
    if(code == 13) {
      parent._setValue(e.target.value);
      parent._fireAddFilter();
    }
  });
    
  self.empty().append(el).append(this.value);	 
    },
  });
  
  // Renders 2 select options
  $.widget("gbif.SelectSelect", {  
    _init : function() {
  var that = this;
  var self = this.element;
  var parent = this.options.parent; // the owning widget
  var data = this.options.data;
  
  console.log("Rendering SelectSelect");
  var el = $('<SELECT/>').addClass("predicate");
  this.predicate = el;
  $.each(data.predicate, function () {
    el.append($('<OPTION></OPTION>').attr('value',this.value).text(this.label));    
  });
  el.bind('change', function(event) {
	    parent._setPredicate($(el).find("option[value='" + el.val() + "']").text());
    parent._setPredicateId(el.val());
  });    
  el.change();

  
  // TODO: CSS-ify the width
  var el2 = $('<SELECT/>').addClass("value");
  this.value = el2;
  $.each(data.value, function () {
    el2.append($('<OPTION></OPTION>').attr('value',this).text(this));    
  });
  el2.bind('change', function(event) {
    parent._setValue(el2.val());
  });   
  // trigger an add filter on carriage return
  this.value.bind('keypress', function(e) {
    var code = (e.keyCode ? e.keyCode : e.which);
    if(code == 13) {
      parent._setValue(e.target.value);
      parent._fireAddFilter();
    }
  });
  
  el2.change();
  self.empty().append(el).append(this.value);	 
    }, 
  });
  
  // Renders the Geometry filter which allows users to draw polygons
  $.widget("gbif.Geometry", {  
    _init : function() {
      var that = this;
      var self = this.element;
      var parent = this.options.parent; // the owning widget
      var data = this.options.data;
  
      var el = $('<SELECT/>').addClass("predicate");
      this.predicate = el;
      $.each(data.predicate, function () {
        el.append($('<OPTION></OPTION>').attr('value',this.value).text(this.label));    
      });
      el.bind('change', function(event) {
	    parent._setPredicate($(el).find("option[value='" + el.val() + "']").text());
        parent._setPredicateId(el.val());
      });    
      el.change();

      self.empty().append(el).append("... TODO ...");	
  
      var el2 = $("<DIV class='geometery-container'/>");
      var mapEl = $("<div id='map_canvas'></div>");
      el2.append(mapEl);
      el2.append("<div class='general_options'><ul><li class='map'><a class='add_polygon'>Draw</a></li></ul></div>");
      
      var styles = [ 
        {
          featureType: 'all',
          stylers: [
            { saturation: -80 }
          ]
        },    
      ];
      var mapOptions = {
        zoom: 2,
        center: new google.maps.LatLng(20, 0),
        mapTypeId: google.maps.MapTypeId.ROADMAP,
        styles: styles,
      };
      //self.parent().parent().append(el2);	


      
      // test a dialog
      var modal = $("<DIV/>");
      modal.append(mapEl);
      modal.append("<div class='map_options'><ul class='add_primary'><li><a class='add_polygon'>Draw</a></li><li class='confirm'><a class='confirm simplemodal-close'>Confirm</a></li><li class='discard'><a class='discard simplemodal-close'>Discard</a></li></ul></div>");
      // This would be a JQuery-UI modal, but the CSS is a nightmare, so using simple modal
      //modal.dialog({modal: true, resizable: false, width: ($(window).width() * 0.8), height: ($(window).height() * 0.8)});
      modal.modal();
      mapEl.css('width', modal.parent().width());
      mapEl.css('height', (modal.parent().height()-30));
      
      //var map = new google.maps.Map(mapEl[0], mapOptions);    

        var map = new google.maps.Map(mapEl[0], {
        zoom: 2,
        center: new google.maps.LatLng(20, 0),
        mapTypeId: google.maps.MapTypeId.ROADMAP,
        styles: styles,
          disableDefaultUI: true,
          zoomControl: true
        });

        var polyOptions = {
          strokeWeight: 0,
          fillOpacity: 0.45,
          editable: true,
          fillColor: "#FF8C00"
        };
        // Creates a drawing manager attached to the map that allows the user to draw
        // markers, lines, and shapes.
        console.log("Adding drawing manager");
        var drawingManager = new google.maps.drawing.DrawingManager({
          drawingMode: google.maps.drawing.OverlayType.POLYGON,
          markerOptions: {
            draggable: true
          },
          polylineOptions: {
            editable: true
          },
          rectangleOptions: polyOptions,
          circleOptions: polyOptions,
          polygonOptions: polyOptions,
          map: map
        });
      
      
   
      
      $(".add_polygon").bind('click', function(e) {
        //map.setOptions({draggableCursor:'crosshair'});
        //var geometry_creator_ = new GeometryCreator(map);
      });
      
      
  }, 
}); 
  
  /**
   * Handles the current search criteria and makes it displayable 
   * for the user
   */
  $.widget("gbif.Query", {  
    _create : function() {
  // hold an array of filters
  this._filters = [];
    },
  
    add: function(filter) {
  // copy the values and put in the array
  this._filters.push({
    subject: filter.subject,
    subjectId: filter.subjectId,
    predicate: filter.predicate,
    predicateId: filter.predicateId,
    value: filter.value});
  
  this._refresh();
    }, 
    
    _refresh: function() {
  var self = this.element.empty();
  
  $.each(this._filters, function(i, filter) {
    // have we seen this subject before?
    // spaces are not allowed in HTML id
    var id = "query-view-" + replaceAll(filter.subject, ' ', '_') + replaceAll(filter.predicate, ' ', '_');
    var ul = $('#' + id);
    if (ul.html() == null) {
      ul = $("<UL class='query' id='" + id +"'/>");
      if (self.children().size()>0) {
    self.append("<P class='query'>AND " + filter.subject.toUpperCase() + " " + filter.predicate.toUpperCase() + "</P>");
      } else {
    self.append("<P class='query'>" + filter.subject.toUpperCase() + " " + filter.predicate.toUpperCase() + "</P>");
      }
      self.append(ul);
    }
    var prefix = "";
    if (ul.children().size()>0) {
      var prefix = "<SPAN class='boolean'>OR</SPAN> ";
    }
    $("<LI>" + prefix + filter.value + " <A href='#'>remove</A></LI>").appendTo(ul);
  });
    },
    
    serialize: function() {
  var s = "";
  $.each(this._filters, function(i, filter) {
    if (i>0) s += "&"; 
    else s += "?";
    s += "f[" + i + "].s=" + filter.subjectId;
    s += "&f[" + i + "].p=" + filter.predicateId;
    s += "&f[" + i + "].v=" + filter.value;
  });
  return s;
    },    
  }); 

  // Utility function
  function replaceAll(txt, replace, with_this) {
    return txt.replace(new RegExp(replace, 'g'),with_this);
  }  
})(jQuery); 