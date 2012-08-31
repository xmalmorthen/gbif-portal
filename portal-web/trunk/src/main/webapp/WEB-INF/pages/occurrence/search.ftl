<#import "/WEB-INF/macros/pagination.ftl" as macro>
<html>
  <head>
    <title>Occurrence Search Results</title>

    <content tag="extra_scripts">
    <!--<link rel="stylesheet" href="<@s.url value='/css/occ_table.css?v=2'/>"/>  -->
    <script type="text/javascript" src="<@s.url value='/js/custom/jquery.gbif.filters.js'/>"></script>
    <script src='<@s.url value='/js/vendor/jquery.url.js'/>' type='text/javascript'></script>
    <script type="text/javascript" src="<@s.url value='/js/vendor/jquery-ui-1.8.17.min.js'/>"></script>
    <script type="text/javascript" src="<@s.url value='/js/species_autocomplete.js'/>"></script>
    <script>     
      
      function applyOccurrenceFilters(){
        var params = {};         
        if($("#datasetKey").val()){
          params['datasetKey'] = $("#datasetKey").val();            
        }
        if($("#nubKey").val()){
          params['nubKey'] = $("#nubKey").val();
        }        
        var u = $.url();
        
        $("div .filter").find(":input[type=hidden]").each( function(idx,el){
          if ($(el).attr("key") !== undefined) {
            params[el.name] = $(el).attr("key");
          } else {
            params[el.name] = el.value;
          }
        })
        window.location = "<@s.url value='/occurrence/search'/>?" + $.param(params);
        return true;  // submit?
      }
      <#if filters.keySet().size() gt 0>  
          var filtersFromRequest = new Object();        
         <#list filters.keySet() as filterKey>
           <#list filters.get(filterKey) as filterValue>
             //the title is taken from the link that has the filterKey value as its data-filter attribute=
             filtersFromRequest['${filterKey}']  = { title: $('a[data-filter="${filterKey}"]').attr('title'), value:'${action.getFilterTitle(filterKey,filterValue)}', key: '${filterValue}', paramName: '${filterKey}' };             
           </#list>
         </#list>
      </#if>
      

      $(function() {
      
      
      var query = $('#query-container').Query({
        removeFilter: function(event, data) {
          if(data.widget._filters.length == 0) {          
            $('#submit-button').hide();
            $('#searchTitle').hide();            
          }
          //if the filter is in the url the form is submitted again
          if(window.location.href.indexOf('f['+data.idx+']') != -1){
            $('#submit-button').click();
          }         
        }
      });

      // subject container with event wiring to trigger changes on query
      $('#filter-container').Filter({
        json:"<@s.url value='/conf/occurrence-search.json'/>",
        addFilter: function(event, data) {
          query.Query("add", data.filter);
          $('#submit-button').show();
          $('#searchTitle').show();
        }
      });

      $('#submit-button').click(function() {
        // construct the query parameters again.  This will remove ALL
        // parameters and reconstruct the URL with the new filter
        // This might cause issues in the future, if other parameters are needed
        // https://github.com/allmarkedup/jQuery-URL-Parser
        var params = {};         
        if($("#datasetKey").val()){
          params['datasetKey'] = $("#datasetKey").val();            
        }
        if($("#nubKey").val()){
          params['nubKey'] = $("#nubKey").val();
        }        
        var u = $.url();

        var filterParams = query.Query("serialize");
        var additionalParams = $.param(params);
        if (additionalParams.length > 0){
          if(filterParams.length > 0){
            filterParams = filterParams + "&" + additionalParams;
            }else{
            filterParams = filterParams + "?" + additionalParams;
          }
        }
        window.location = "<@s.url value='/occurrence/search'/>" + filterParams;
        return true;  // submit?

      });
    });

    </script>

    </content>
  </head>
  <body class="search typesmap">

    <content tag="infoband">
    <h2>Search occurrences</h2> 
    </content>

    <article class="ocurrence_results">
    <header></header>

    <div class="content" id="content">

      <table class="results">

        <tr class="header">

          <td class="summary">
            <h2>${searchResponse.count} results</h2>
          </td>

          <td class="options" colspan="3">
            <ul>
              <li><a href="#" class="configure"><i></i> Configure</a></li>
              <li>
              <a href="#" class="filters" data-toggle="dropdown"><i></i> Add a filter</a>

              <div class="dropdown-menu filters">
                <div class="tip"></div>
                <ul>
                  <li><a tabindex="-1" href="#" data-placeholder="Type a scientific name..." data-filter="nubKey"  title="Scientific name" template-filter="template-scientific-name-filter" class="species_autosuggest">Scientific name</a></li>
                  <li><a tabindex="-1" href="#" data-placeholder="Type a location..." data-filter="coordinate" title="Coordinate" template-filter="template-add-filter">Location</a></li>
                  <li><a tabindex="-1" href="#" data-placeholder="Type a collector name..." data-filter="collectorName" title="Collector name" template-filter="template-add-filter">Collector</a></li>
                  <li><a tabindex="-1" href="#" data-placeholder="Type a name..." data-filter="basisOfRecord" title="Basis Of Record" template-filter="template-add-filter">Basis of record</a></li>
                  <li><a tabindex="-1" href="#" data-placeholder="Type a dataset name..." data-filter="datasetKey" title="Dataset" template-filter="template-add-filter">Dataset</a></li>
                  <li><a tabindex="-1" href="#" data-placeholder="Type a dataset date..." data-filter="collectionDate" title="Collection date" template-filter="template-add-filter">Collection date</a></li>
                  <li><a tabindex="-1" href="#" data-placeholder="Type a catalogue number..." data-filter="catalogueNumber" title="Catalogue number" template-filter="template-add-filter">Catalogue number</a></li>
                  <li class="divider"></li>
                  <li class="more"><a tabindex="-1" href="#">Need a different filter?</a></li>
                </ul>
              </div>

            </div>


            </li>
          </ul>
        </td>
      </tr>      
      <#if searchResponse.count gt 0>
      <#list searchResponse.results as occ>
      <tr>
        <td>
          <div class="header"> 
            <span class="code">${occ.key?c}</span> 
            <#if occ.catalogNumber?has_content>· <span class="catalogue">Cat. ${occ.catalogNumber!}</span></#if>
          </div>
          <#if occ.scientificName?has_content><a href="<@s.url value='/occurrence/${occ.key?c}'/>">${occ.scientificName}</a></#if>

          <div class="footer">Published by <#if occ.datasetKey?has_content>${action.getDatasetTitle(occ.datasetKey)!}</#if></div>
        </td>
        <td class="country"><#if occ.isoCountryCode?has_content><div class="country">${occ.isoCountryCode!}</div></#if>
          <div class="coordinates">
            <#if occ.latitude?has_content>${occ.latitude!?c}<#else>-</#if>/<#if occ.longitude?has_content>${occ.longitude!?c}<#else>-</#if>
          </div>
        </td>
        <td class="kind">Specimen</td>
        <td class="date">
          <#if occ.occurrenceMonth?has_content>${occ.occurrenceMonth!?c}</#if>
          <#if occ.occurrenceYear?has_content>${occ.occurrenceYear!?c}</#if>
        </td>
      </tr>
      </#list>
      </#if>                  

    </table>

    <div class="footer">
     <@macro.pagination page=searchResponse url=currentUrl/>
    </div>
  </div>  
  <footer></footer>    
  </article>


  <article class="download_ocurrences">
  <header></header>
  <div class="content">

    <div class="header">
      <h2>Download 213,212 occurrences for your search</h2>
      <span> Or refine it using the <a href="#">advanced search</a></span>
    </div>

    <div class="dropdown">
      <a href="#" class="title" title="Download description"><span>Download occurrences</span></a>
      <ul>
        <li><a href="#a"><span>Download occurrences</span></a></li>
        <li><a href="#a"><span>Download placemarks</span></a></li>
        <li class="last"><a href="#b"><span>Download metadata</span></a></li>
      </ul>
    </div>

  </div>
  <footer></footer>
  </article>


  <!-- Filter templates -->

  <script type="text/template" id="template-add-filter">
    <tr class="filter">
      <td colspan="4">
        <div class="inner">
          <h4><%= title %></h4>
          <div class="filter">
            <input type="text" class="value" name="<%=name%>" placeholder="<%= placeholder %>" />
            <a href="#" class="button candy_blue_button" data-action="add_filter" data-filter="<%= name %>" apply-function="applyOccurrenceFilters"><span>Apply filter</span></a>
          </div>
          <a href="#" class="close"></a>
        </div>
      </td>
    </tr>
  </script>
  
  <script type="text/template" id="template-scientific-name-filter">
    <tr class="filter">
      <td colspan="4">
        <div class="inner">
          <h4><%= title %></h4>
          <div class="filter">
            <input type="text" name="<%=paramName%>" class="value species_autosuggest" placeholder="<%= placeholder %>" />
            <a href="#" class="button candy_blue_button" title="<%= title %>" data-action="add_filter" data-filter="<%= paramName %>" apply-function="applyOccurrenceFilters"><span>Apply filter</span></a>
          </div>
          <a href="#" class="close"></a>
        </div>
      </td>
    </tr>
  </script>

  <script type="text/template" id="template-filter">
    <li>
    <h4><%= title %></h4>
    <div class="filter"><a href="#"><%= value %></a><input name="<%= paramName %>" type="hidden" key="<%= key %>" value="<%= value %>"/></div>
    <a href="#" class="close" close-function="applyOccurrenceFilters"></a>    
    </li>
  </script>

  <script type="text/template" id="template-filter-container">
    <tr class="filters">
      <td colspan="4">
        <ul class="filters"></ul>
      </td>
    </tr>
  </script>

  <!-- /Filter templates -->

</body>
</html>
