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
	  
	  $('.facetFilter').each( function(){
		var $spans = $(this).children('span');
		var $facetFilter = $($spans[0]).text();
		var $facetValue = $($spans[1]).text();		
		$(this).children('p').first().children('a').first().click(function(event) {event.preventDefault();removeFacet($facetFilter,$facetValue);});
		//$($spans).remove();
	  });
	  
	  function removeFacet(facetName,facetFilter) {
		var facetFilterParams = new Array(); 
		$('.facetFilter').each(function(){
			var $spans = $(this).children('span');
			var keyV = $($spans[0]).text();
			var valV = $($spans[1]).text();
			if(keyV != facetName && valV != facetFilter){
				facetFilterParams.push('facets[\'' + keyV + '\']' + "=" + valV);
			}
		});		
	    var paramList = removeQueryParam('facets[\'' + facetName + '\']',facetFilter);	
	    addAllIfNotPresent(facetFilterParams,paramList);
	    window.location.replace(window.location.pathname + '?' + paramList.join('&'));
	   };
	
	  function addAllIfNotPresent(facetFilterParams,paramList){
		  for (var i = 0; i < facetFilterParams.length; i++) {
			  if($.inArray(facetFilterParams[i],paramList) < 0){
				  paramList.push(facetFilterParams[i]);
			  }
		  }
	  };
	  
	  function removeQueryParam(paramName, paramValue) {
		// get the pairs of params fist
		var pairs = unescape(location.search.substring(1)).split('&');
		var values = [];		
		// now iterate each pair
		for (var i = 0; i < pairs.length; i++) {
		  var params = pairs[i].split('=');
		  if (params[0] != paramName && params[1] != paramValue && params[0] != "limit" && params[0] != "offset") {	    
		    values.push(pairs[i]);		    
		  }
		}
		if($.inArray("initDefault=false",values) < 0 ){
		 values.push("initDefault=false");
		}
		return values;	
	  };
  })
