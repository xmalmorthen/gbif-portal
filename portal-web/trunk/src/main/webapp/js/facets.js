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
      addFacet('HIGHERTAXON', $(this).attr('key'));
	  });

	  $('.facetFilter').each( function(){
      var $spans = $(this).children('span');
      var $facetFilter = $($spans[0]).text();
      var $facetValue = $($spans[1]).text();
      $(this).children('p').first().children('a').first().click(function(event) {
        event.preventDefault();
        removeFacet($facetFilter,$facetValue);
      });
	  });
	  
    function addFacet(facetName,facetFilter) {
      var queryParams = currentFilterParams();
      queryParams.push('facets[\'' + facetName + '\']' + "=" + facetFilter);
      changeLocation(queryParams);
    }
    function removeFacet(facetName,facetFilter) {
      var queryParams = currentFilterParams();
      var removeParam = 'facets[\'' + facetName + '\']' + "=" + facetFilter;
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
        var $spans = $(this).children('span');
        var keyV = $($spans[0]).text();
        var valV = $($spans[1]).text();
        facetFilterParams.push('facets[\'' + keyV + '\']' + "=" + valV);
      });

      return $.unique($.merge(facetFilterParams,currentQueryParam()));
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
