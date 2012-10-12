<#import "/WEB-INF/macros/pagination.ftl" as macro>
<html>
  <head>
    <title>Occurrence Search Results</title>

    <content tag="extra_scripts">    
    <link rel="stylesheet" href="<@s.url value='/css/combobox.css?v=2'/>"/>    
    <script src='<@s.url value='/js/vendor/jquery.url.js'/>' type='text/javascript'></script>
    <script type="text/javascript" src="<@s.url value='/js/vendor/jquery-ui-1.8.17.min.js'/>"></script>
    <script type="text/javascript" src="<@s.url value='/js/terms_suggest.js'/>"></script>
    <script type="text/javascript" src="<@s.url value='/js/species_autocomplete.js'/>"></script>
    
    <!--Maps-->
    <link rel="stylesheet" href="<@s.url value='/js/vendor/leaflet/leaflet.css'/>" />
    <link rel="stylesheet" href="<@s.url value='/js/vendor/leaflet/draw/leaflet.draw.css'/>" />
    <!--[if lte IE 8]><link rel="stylesheet" href="<@s.url value='/js/vendor/leaflet/leaflet.ie.css'/>" /><![endif]-->
    <script type="text/javascript" src="<@s.url value='/js/vendor/leaflet/leaflet.js'/>"></script>
    <script type="text/javascript" src="<@s.url value='/js/vendor/leaflet/draw/leaflet.draw.js'/>"></script>
    <script type="text/javascript" src="<@s.url value='/js/occurrence_filters.js'/>"></script>
    <script>                 
      var filtersFromRequest = new Object();    
      <#if filters.keySet().size() gt 0>                   
         <#list filters.keySet() as filterKey>
            filtersFromRequest['${filterKey}'] = new Array();
           <#list filters.get(filterKey) as filterValue>
             //the title is taken from the link that has the filterKey value as its data-filter attribute=
             if('${filterKey}' == 'date') {
              value ='${action.getFilterTitle(filterKey,filterValue)}'.split('/');
              year = "";
              month = "";
              if(value.length > 0) {
                year = value[0];
              }
              if(value.length > 1) {
                month = value[1];
              }              
              filtersFromRequest['${filterKey}'].push({ title: $('a[data-filter="${filterKey}"]').attr('title'), year:year, month:month, value: '${filterValue}', paramName: '${filterKey}' });
             } else {
              filtersFromRequest['${filterKey}'].push({ title: $('a[data-filter="${filterKey}"]').attr('title'), value:'${action.getFilterTitle(filterKey,filterValue)}', key: '${filterValue}', paramName: '${filterKey}' });
             }             
           </#list>
         </#list>
      </#if>
     $(document).ready(function() {  
       var widgetManager = new OccurrenceWidgetManager("<@s.url value='/occurrence/search'/>?",filtersFromRequest,".dropdown-menu");      
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
                  <li><a tabindex="-1" href="#" data-placeholder="Type a scientific name..." data-filter="TAXON_KEY"  title="Scientific name" template-filter="template-add-filter" input-classes="value species_autosuggest" class="filter-control">Scientific name</a></li>
                  <li><a tabindex="-1" href="#" data-placeholder="Type a location..." data-filter="BBOX" title="Bounding Box" template-filter="map-template-filter" class="filter-control">Location</a></li>
                  <li><a tabindex="-1" href="#" data-placeholder="Type a collector name..." data-filter="COLLECTOR_NAME" title="Collector name" template-filter="template-add-filter" input-classes="value collector_name_autosuggest" class="filter-control">Collector</a></li>
                  <li><a tabindex="-1" href="#" data-placeholder="Type a name..." data-filter="BASIS_OF_RECORD" title="Basis Of Record" template-filter="template-basis-of-record-filter" class="filter-control">Basis of record</a></li>
                  <li><a tabindex="-1" href="#" data-placeholder="Type a dataset name..." data-filter="DATASET_KEY" title="Dataset" template-filter="template-add-filter" class="filter-control">Dataset</a></li>
                  <li><a tabindex="-1" href="#" data-placeholder="Type a dataset date..." data-filter="DATE" title="Collection date" template-filter="template-add-date-filter" class="filter-control">Collection date</a></li>
                  <li><a tabindex="-1" href="#" data-placeholder="Type a catalogue number..." data-filter="CATALOGUE_NUMBER" title="Catalogue number" template-filter="template-add-filter" input-classes="value catalogue_number_autosuggest" class="filter-control">Catalogue number</a></li>
                  <li class="divider"></li>
                  <li class="more"><a tabindex="-1" href="#">Need a different filter?</a></li>
                </ul>
                <input type="hidden" id="nubTaxonomyKey" value="${nubTaxonomyKey}"/>
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
        <td class="country"><#if occ.country?has_content><div class="country">${occ.country.title!}</div></#if>
          <div class="coordinates">
            <#if occ.latitude?has_content>${occ.latitude!?c}<#else>-</#if>/<#if occ.longitude?has_content>${occ.longitude!?c}<#else>-</#if>
          </div>
        </td>
        <td class="kind">${action.getFilterTitle('basisOfRecord',occ.basisOfRecord)!}</td>
        <td class="date">
          <#if occ.occurrenceMonth?has_content>${occ.occurrenceMonth!?c}<#else>-</#if>     
          /    
          <#if occ.occurrenceYear?has_content>${occ.occurrenceYear!?c}<#else>-</#if>
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
      <h2>Download ${searchResponse.count} occurrences for your search</h2>
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
  <script type="text/template" id="template-add-date-filter">
    <tr class="filter">
      <td colspan="4">
        <div class="inner">          
          <div class="filter">
          <h4><%= title %></h4>
            <table>
              <tr>
                <td style="border: 0px none !important;"><h4>from</h4>
                  <span>
                    <label for="monthMin">Month</label>
                    <select name="monthMin" class="selectbox">
                      <option value="0">-</option>
                      <option value="1">January</option>
                      <option value="2">February</option>
                      <option value="3">March</option>
                      <option value="4">April</option>
                      <option value="5">May</option>
                      <option value="6">June</option>
                      <option value="7">July</option>
                      <option value="8">August</option>
                      <option value="9">September</option>
                      <option value="10">October</option>
                      <option value="11">November</option>
                      <option value="12">December</option>
                    </select>
                    <label for="yearMin">Year</label>
                    <input type="text" name="yearMin" size="10" maxlength="4" style="width: 50px !important; padding: 6px !important;"/>
                  </span>
                </td>
                <td style="border: 0px none !important;"><h4>to</h4>
                  <label for="monthMax">Month</label>
                  <select name="monthMax">
                    <option value="0">-</option>
                    <option value="1">January</option>
                    <option value="2">February</option>
                    <option value="3">March</option>
                    <option value="4">April</option>
                    <option value="5">May</option>
                    <option value="6">June</option>
                    <option value="7">July</option>
                    <option value="8">August</option>
                    <option value="9">September</option>
                    <option value="10">October</option>
                    <option value="11">November</option>
                    <option value="12">December</option>
                  </select>
                  <label for="yearMax">Year</label>
                  <input type="text" name="yearMax" size="10" maxlength="4" style="width: 50px !important; padding: 6px !important;"/>
                  <input type="image" src="<@s.url value='/img/admin/add-small.png'/>" class="addFilter">
                </td>
                <td style="border: 0px none !important;"><div class="appliedFilters"></div></td>
              </tr>              
              </tr>
            </table>              
            <a href="#" class="button candy_blue_button" title="<%= title %>" data-action="add-new-date-filter" data-filter="<%= paramName %>" apply-function="applyOccurrenceFilters"><span>Apply filter</span></a>
          </div>          
          <a href="#" class="close"></a>
        </div>
      </td>
    </tr>
  </script>
  
  
  <script type="text/template" id="template-basis-of-record-filter">
    <tr class="filter">
      <td colspan="4">
        <div class="inner">
          <h4><%= title %></h4>
          <div class="filter">
            <span>              
              <select name="BASIS_OF_RECORD" multiple="multiple">
                <#list basisOfRecords as basisOfRecord>
                  <option value="${basisOfRecord}">${action.getFilterTitle('basisOfRecord',basisOfRecord)}</option>
                </#list> 
              </select>              
            </span>
            <a href="#" class="button candy_blue_button" title="<%= title %>" data-action="add-new-date-filter" data-filter="<%= paramName %>" apply-function="applyOccurrenceFilters"><span>Apply filter</span></a>
          </div>
          <a href="#" class="close"></a>
        </div>
      </td>
    </tr>
  </script>
  
  
  <script type="text/template" id="template-add-filter">
    <tr class="filter">
      <td colspan="4">
        <div class="inner">
          <h4><%= title %></h4>
          <div class="filter">
            <table width="100%">                
                <tr> 
                  <td style="border: 0px none !important;">                    
                    <input type="text" name="<%=paramName%>" class="<%= inputClasses %>" placeholder="<%= placeholder %>" />
                    <input type="image" src="<@s.url value='/img/admin/add-small.png'/>" class="addFilter">
                    <span style="display:none" class="erroMsg">Please enter a value</span>
                  </td>
                  <td style="border: 0px none !important;">
                    <div class="appliedFilters" style="width:400px; overflow-y: auto;clear:both;"></div>
                  </td>                  
                </tr>
             </table>            
            <a href="#" class="button candy_blue_button" title="<%= title %>" data-action="add-new-filter" data-filter="<%= paramName %>" apply-function="applyOccurrenceFilters"><span>Apply filter</span></a>
          </div>          
          <a href="#" class="close"></a>
        </div>
      </td>
    </tr>
  </script>

  <script type="text/template" id="template-filter">
    <li id="filter-<%=paramName%>">
    <h4><%= title %></h4>
    <% _.each(filters, function(filter) { %>
        <div class="filter"><%= filter.value %><input name="<%= filter.paramName %>" type="hidden" key="<%= filter.key %>" value="<%= filter.value %>"/><a href="#" class="closeFilter"></a></div>        
      <% }); %>            
    </li>
  </script>
  
  <script type="text/template" id="template-applied-filter">
    <li style="list-style: none;display:block;">    
    <div><div style="float:left;"><%= value %><input name="<%= paramName %>" type="hidden" key="<%= key %>" value="<%= value %>"/></div><a href="#" class="closeFilter" style="float:left;"></a></div>       
    </li>
  </script>
 
  <script type="text/template" id="template-filter-container">
    <tr class="filters">
      <td colspan="4">
        <ul class="filters"></ul>
      </td>
    </tr>
  </script>
    
  <script type="text/template" id="map-template-filter">
     <tr class="filter">
      <td colspan="4">        
        <div class="inner">  
          <h4>Location</h4>  
          <div>                                                        
              <table width="100%">                
                <tr>    
                  <td style="border: 0px none !important;width: 500px !important;">                                    
                     <div id="map" class="map_widget"/>                 
                  </td>
                   <td valign="top" style="border: 0px none !important;">    
                      <h4>Bounding box from</h4>   
                      <br>            
                      <span>
                        <input name="minLatitude" id="minLatitude" type="text" size="10" style="width:60px;"/>
                        <input name="minLongitude" id="minLongitude" type="text" size="10" style="width:60px;"/>
                      </span>
                      <br>             
                      <h4>To</h4>
                      <br>         
                      <span>
                        <input name="maxLatitude" id="maxLatitude" type="text" size="10" style="width:60px;"/>
                        <input name="maxLongitude" id="maxLongitude" type="text" size="10" style="width:60px;"/>
                      </span>
                      <br>
                      <input type="image" src="<@s.url value='/img/admin/add-small.png'/>" class="addFilter">                      
                      <br>                                            
                      <div class="appliedFilters"></div>
                      <br>                      
                  </td>
                </tr>                                 
              </table>         
           </div>         
           <a href="#" class="button candy_blue_button" title="<%= title %>" data-action="add-new-bbox-filter" data-filter="<%= paramName %>"><span>Apply filter</span></a>         
          <a href="#" class="close"></a>     
        </div>
       </td>
     </tr>
  </script>

  <!-- /Filter templates -->

</body>
</html>
