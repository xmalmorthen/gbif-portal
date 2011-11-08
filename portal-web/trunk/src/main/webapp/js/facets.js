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
   $("div.facet > select").multiselect({minWidth: 180});
   //$("div.facet > select").multiselect("checkAll");   
});

  function removeFacet(facetName,facetFilter) {	   
    var paramList = removeQueryParam(escape('facets[\'' + facetName + '\']'),escape(facetFilter));	   	  
    window.location.replace(window.location.pathname + '?' + paramList.join('&'));
  };
	   
  function removeQueryParam(paramName, paramValue) {
	// get the pairs of params fist
	var pairs = location.search.substring(1).split('&');
	var values = [];
	// now iterate each pair
	for (var i = 0; i < pairs.length; i++) {
	  var params = pairs[i].split('=');
	  if (params[0] != paramName && params[1] != paramValue) {	    
	    values.push(pairs[i]);
	  }
	}
	if (values.length > 0) {
	  return values;
	} else {
	  
	  return undefined;
	}
  }; 
