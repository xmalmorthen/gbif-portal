function removeRecentlyAddedFilter(e) {
  e.preventDefault();

  var $li = $(this).parent().parent().parent();

  $li.fadeOut(250, function() { $(this).remove(); });
}

function removeFilter(e) {
  e.preventDefault();

  var
  $li = $(this).parent(),
  $ul = $li.parent(),
  $tr = $ul.parent().parent();

  if ($ul.find("li").length == 1) {

    $tr.fadeOut(250, function() {
     $(this).remove();
    });

  } else {

    $(this).parent().slideUp(250, function() {
      $(this).remove();
    });

  }  
  var applyFunction = $(this).attr("close-function"),
  applyFilters = eval('(' + applyFunction + ')');
  $li.remove();
  applyFilters();
}

function addNewFilter(e) {
  e.preventDefault();
  
  //gets the attribute data-filter of current element, for example
  //<a tabindex="-1" href="#" data-placeholder="Type a scientific name..." data-filter="scientific_name">
  var filter = $(this).attr("data-filter");  
  var input = $("tr.filter").find(":input[name=" + filter + "]:first");
  var applyFunction = $(this).attr("apply-function");
  var title = $(this).attr("title");    
  template = _.template($("#template-filter").html());
  var value = input.val();
  var key = "";
  //Autocompletes store the selected key in "key" attribute
  if (input.attr("key") !== undefined) {
    key = input.attr("key"); 
  }  
  $filter  = $(template({title: title, value: value, paramName: filter, key: key }));
  
  addFilterItem($filter);

  // Removes the filter selector and add the filter
  $("tr.filter").fadeOut(250, function() {
    $(this).remove();    
  });
  //dynamic function call
  var applyFilters = eval('(' + applyFunction + ')');
  applyFilters();
}

function addFilterItem($filter){
  var $tr = $("tr.header");
  $filters = $("tr.filters");
  if ($filters.length > 0) {
    var
    $tr      = $("tr.filters td ul");
    $tr.prepend( $filter );
  } else {
    var
    containerTemplate = _.template($("#template-filter-container").html()),
    $filterContainer  = $(containerTemplate());
    $tr.after($filterContainer);
    $("tr.filter").after( $filterContainer );
    $filterContainer.find("ul").prepend( $filter );
  }
  $filter.fadeIn(250);
}

function addFilter(title, filter, placeholder, templateID,inputClasses) {
  var $tr = $("tr.header");
  var template = _.template($("#" + templateID).html());
  var $filter = $(template({title:title, paramName: filter, placeholder: placeholder, inputClasses: inputClasses }));
  $tr.after( $filter );
  $filter.fadeIn(250);  
}


$(function() {

  // DROPDOWN

  $(".dropdown .title").on("click", function(e) {
    e.preventDefault();
    $(this).parent().toggleClass("selected");
  });

  $(".dropdown-menu ul li a").on("click", function(e) {
    e.preventDefault();

    var
    filter      = $(this).attr("data-filter"),
    placeholder = $(this).attr("data-placeholder"),
    templateFilter = $(this).attr("template-filter"),
    inputClasses = $(this).attr("input-classes"),
    title = $(this).attr("title");    
    addFilter(title,filter, placeholder,templateFilter,inputClasses);    
    $(':input.collector_name_autosuggest').each( function(idx,el){
      $(el).termsAutosuggest(cfg.wsOccCollectorNameSearch, "#content");
    });
    $(':input.catalogue_number_autosuggest').each( function(idx,el){
      $(el).termsAutosuggest(cfg.wsOccCatalogueNumberSearch, "#content");
    });
    $(':input.species_autosuggest').each( function(idx,el){
      $(el).speciesAutosuggest(cfg.wsClbSuggest + "/entities", 4, null, "#content",false);
    });    
  });
  
  if(typeof(filtersFromRequest) != 'undefined' && filtersFromRequest != null){    
    template = _.template($("#template-filter").html());    
    $.each(filtersFromRequest, function(key,filterValues){
      $.each(filterValues, function(idx,filter) {
        $filter  = $(template({title: filter.title, key: filter.key, value: filter.value, paramName: filter.paramName }));
        addFilterItem($filter);
      });
    });    
  }

  $(document).on("click", "tr.filters .close", removeFilter);
  $(document).on("click", "tr.filter .close", removeRecentlyAddedFilter);

  $(document).on("click", "a.button[data-action:'add-new-filter']", addNewFilter);

  // PHOTO GALLERY
  $(".photo_gallery").bindSlideshow();

  // GRAPHS
  $("div.graph li a, div.bargraph li a").on("click", function(e) {
    e.preventDefault();
  });

  $('div.graph').each(function(index) {
    $(this).find('ul li .value').each(function(index) {
      var width = $(this).parents("div").attr("class").replace(/graph /, "");
      $(this).parent().css("width", width);
      var value = $(this).text();
      $(this).delay(index * 100).animate({ height: value }, 400, 'easeOutBounce');
      var label_y = $(this).parent().height() - value - 36;
      $(this).parent().find(".label").css("top", label_y);
      $(this).parent().append("<div class='value_label'>" + value + "</div")
      $(this).parent().find(".value_label").css("top", (label_y + 13));
    });
  });

  $('div.bargraph').each(function(index) {
    $(this).find('ul li .value').each(function(index) {
      var width = $(this).parents("div").attr("class").replace(/bargraph /, "");
      $(this).parent().css("width", width);
      var value = $(this).text();
      $(this).delay(index * 100).animate({ height: value }, 400, 'easeOutBounce');
      var label_y = $(this).parent().height() - value - 36;
      $(this).parent().find(".label").css("top", label_y);
      $(this).parent().append("<div class='value_label'>" + value + "</div")
      $(this).parent().find(".value_label").css("top", (label_y + 13));
    });
  });


  $('div.graph ul li a').click(function(e) {
    e.preventDefault();
  });

  // focus on form input element with class "focus"
  $('input.focus').focus();

  $(".selectbox").selectBox();

  // Activate source popovers
  $("a.sourcePopup").append('<img src="'+((cfg.context+"/img/icons/questionmark.png").replace("//", "/")) +'"/>').each(function(idx, obj){
    $(obj).sourcePopover({"title":$(obj).attr("title"),"message":$(obj).attr("message"),"remarks":$(obj).attr("remarks")});
  });

  // Activate link popovers
  $("a.popover").each(function(idx, obj){
    $(obj).sourcePopover({"title":$(obj).attr("title"),"message":$(obj).attr("message"),"remarks":$(obj).attr("remarks")});
  });

  $("a.download")
  .bindDownloadPopover({explanation:"Occurrences of \"Puma concolor\", collected between Jan 1sr, 2000 and Jan 1st, 2010, from dataset \"Felines of the world\"."});
  $("a.download_2")
  .bindDownloadPopover({template: "direct_download", explanation:"Occurrences of \"Puma concolor\", collected between Jan 1sr, 2000 and Jan 1st, 2010, from dataset \"Felines of the world\"."});

  // setup taxonomic browser
  $("#taxonomicBrowser").taxonomicExplorer({transitionSpeed:300});

  // Dropdown for the sorting options of the taxonomic explorer
  $('#tax_sort_ocurrences').dropdownPopover({
    options: {
      links: [
        { name: "Sort alphabetically",
          callback: function(e) {
            e.preventDefault();
            $("#taxonomy .sp").animate({opacity:0}, 500, function() {
              sortAlphabetically($("#taxonomy .sp ul:first"));
              $("#taxonomy .sp").animate({opacity:1}, 500);
            });
          },
          replaceWith:'Sort alphabetically<span class="more"></span>'
        },
        { name: "Sort by count",
          callback: function(e) {
            e.preventDefault();
            $("#taxonomy .sp").animate({opacity:0}, 500, function() {
              sortByCount($("#taxonomy .sp ul:first"));
              $("#taxonomy .sp").animate({opacity:1}, 500);
            });
          },
          replaceWith:'Sort by count<span class="more"></span>'
        }
      ]
    }
  });


  // Dropdown for the language selector
  $('#language_selector').dropdownPopover({
    options: {
      links: [
        { name: "English",
          callback: function(e) {
            e.preventDefault();
            /* add callback action here */
          },
          replaceWith: "<span>EN</span>",
          select: "EN"
        },
        { name: "Spanish",
          callback: function(e) {
            e.preventDefault();
            /* add callback action here */
          },
          replaceWith: "<span>ES</span>",
          select: "ES"
        },
        { name: "Deutsch",
          callback: function(e) {
            e.preventDefault();
            /* add callback action here */
          },
          replaceWith: "<span>DE</span>",
          select: "DE"
        }
      ]
    }
  });


  $('span.input_text input').focus(function() {
    $(this).parent().addClass("focus");
  });

  $('span.input_text input').focusout(function() {
    $(this).parent().removeClass("focus");
  });

  var processes = {
    dates:[
      {start:"2011-1-1", end: "2011-2-11", title: "123 - HARVESTING ", message:"<a href='/members/process_detail.html'>235 issues</a>"},
      {start:"2011-3-1", title: "123 - HARVESTING ", message:"<a href='/members/process_detail.html'>235 issues</a>"},
      {start:"2011-4-1", end:"2011-4-25", title: "123 - HARVESTING ", message:"<a href='/members/process_detail.html'>235 issues</a>"},
      {start:"2011-5-1", title: "123 - HARVESTING ", message:"<a href='/members/process_detail.html'>235 issues</a>"},
      {start:"2011-6-1", title: "123 - HARVESTING ", message:"No processes"},
      {start:"2011-7-1", title: "123 - HARVESTING ", message:"No processes"},
      {start:"2011-8-1", title: "123 - HARVESTING ", message:"No processes"}
      ]};

      if ($("#holder").length) {
        dataHistory.initialize(generateRandomValues(365), {height: 180, processes: processes});
        dataHistory.show();
      }

      // wrapper to use for i18n in JQuery. See README file for how to use it.
      $i18nresources = $.getResourceBundle("resources");

})
