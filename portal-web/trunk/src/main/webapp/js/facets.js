/*
 * Copyright 2011 Global Biodiversity Information Facility (GBIF)
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */  	
  $(function() {	  		  
	  $('.facetPanel').each( function(){		
		 var $facetDialog = $(this).children('.dialogPopover').first(); 
		 $(this).children('a').bindDialogPopover($facetDialog); 
	  });

    $('.higherTaxonLink').click( function(event){
      event.preventDefault();
      addFacet('highertaxon', $(this).attr('key'));
	  });

    $('.facet ul li').each( function(){
    	var thisLi = this;
    	$('a',thisLi).click( function(event){
    		event.preventDefault();
    		//when a facet is selected, all facet checkboxes are disable to avoid multiple requests
    		$('input',thisLi).attr('checked',!$('input',thisLi).checked);
    		$('input',thisLi).click();
    	});
    	$('input',thisLi).click( function(event){    		
    		var location = window.location.toString();
    		$('.facet input:checkbox').each(function(){$(this).attr('disabled','true');});
    		showWaitDialog();
    		if(this.checked){
    			location =  location + this.value;
    		}else{    			
    			location = location.replace(this.value,'');    			
    		}
    		if(location.indexOf("initDefault=false") < 0){
    			location = location + "&initDefault=false";
    		}
    		window.location= location;
    	})
  	 });


	  $('.facetFilter').each( function(){
      var span = $("span.flabel", this);
      var facetFilter = span.text().toLowerCase();
      var facetValue  = span.attr("val");
      $("a", this).click(function(event) {
        event.preventDefault();
        console.log(facetFilter, facetValue);
        removeFacet(facetFilter, facetValue);
      });
	  });
	  
    function addFacet(facetName,facetFilter) {
      var queryParams = currentFilterParams();
      queryParams.push(facetName + "=" + facetFilter);
      changeLocation(queryParams);
    }
    function replaceFacet(facetName,facetFilter) {
      var queryParams = currentFilterParams();
      $.each(queryParams, function(i, val) {
        if (val.substring(0, facetName.length+1) == facetName+"=") {
          queryParams.splice (i,1);
        }
      });
      queryParams.push(facetName + "=" + facetFilter);
      changeLocation(queryParams);
    }
    function showWaitDialog(){
    	$('#waitDialog').css("top", getTopPosition($('#waitDialog')) + "px");
		$('#waitDialog').fadeIn("medium", function() { hidden = false; });
		$("body").append("<div id='lock_screen'></div>");
	    $("#lock_screen").height($(document).height());
	    $("#lock_screen").fadeIn("slow");
    }
    function getTopPosition(div) {
        return (( $(window).height() - div.height()) / 2) + $(window).scrollTop() - 50;
      }
    
    function removeFacet(facetName,facetFilter) {
      var queryParams = currentFilterParams();
      var removeParam = facetName + "=" + facetFilter;
      var idx = $.inArray(removeParam, queryParams);
      if (idx >= 0){
        queryParams.splice (idx,1);
      }
      changeLocation(queryParams);
    }
    
    function changeLocation(queryParams) {
      window.location.replace(window.location.pathname + '?' + queryParams.join('&'));
    }
	  function currentFilterParams() {
      var facetFilterParams = new Array();
      $('.facetFilter').each(function(){
        var span = $("span.flabel", this);
        facetFilterParams.push(span.text().toLowerCase() + "=" + span.attr("val"));
      });

      $.merge(facetFilterParams,currentQueryParam());
      return facetFilterParams.unique();
	   };
	

	  function currentQueryParam() {
		// get the pairs of params fist
		var pairs = unescape(location.search.substring(1)).split('&');
		var values = [];		
		// now iterate each pair
		for (var i = 0; i < pairs.length; i++) {
		  var params = pairs[i].split('=');
		  if (params[0] != "limit" && params[0] != "offset") {
		    values.push(pairs[i]);		    
		  }
		}
		if($.inArray("initDefault=false",values) < 0 ){
		 values.push("initDefault=false");
		}
		return values;	
	  };
  })
