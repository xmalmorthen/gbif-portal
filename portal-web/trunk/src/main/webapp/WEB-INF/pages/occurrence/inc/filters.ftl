  <#import "/WEB-INF/macros/common.ftl" as common>
  <!-- Filter templates -->
  <script type="text/template" id="template-add-date-filter">
    <tr class="filter">
      <td colspan="4">
        <a class="edit" style="display:none;"/>
        <div class="inner filter_view">                    
          <div class="filter">          
            <h4><%= title %></h4>                    
            <table>              
              <tr>
                <td style="border: 0px none !important;">                  
                  <div class="date-filter">
                    <a class="helpPopup" title="Year interpretation" data-message="The year is interpreted literally. i.e. 19 is the year 19 AD, 1900 is the year 1900 AD." data-remarks="" style="float:right;"/>
                    <h4>from</h4>
                    <select name="monthMin" class="date-dropdown">
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
                    <input type="text" name="yearMin" size="10" maxlength="4" style="width: 50px !important; padding: 6px !important;"/>
                </div>
                                
                <div class="date-filter">
                  <h4>to</h4>                  
                  <select name="monthMax" class="date-dropdown">
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
                  <input type="image" src="<@s.url value='/img/admin/add-small.png'/>" class="addFilter"/>                  
                  <input type="hidden" name="max_year" value="${action.currentYear?c}"/>
                </div>
                <span style="display: none;" id="yearErrorMessage" class="warningBox year_error">
                    <p>Year must be a valid number between 0 and ${action.currentYear?c}</p>
                </span>
                <span style="display: none;" id="yearRangeErrorMessage" class="warningBox year_error">
                    <p>Invalid range of years has been specified, second year must be greater that the first one</p>
                </span>
                
                <span style="display: none;" id="monthRangeErrorMessage" class="warningBox month_error">
                    <p>Invalid range of months has been specified, second month must be greater than the first one</p>
                </span>
                </td>
                <td style="border: 0px none !important;">
                  <h4 class="filtersTitle" style="display:none;">Filters</h4>
                  <div class="appliedFilters filterlist" style="display:none;"></div>
                </td>                           
              </tr>
            </table>                         
            <a href="#" class="button candy_blue_button apply" title="<%= title %>" data-action="add-new-date-filter" data-filter="<%= paramName %>" apply-function="applyOccurrenceFilters"><span>Apply</span></a>
          </div>          
          <a href="#" class="close"></a>
        </div>
        <div class="summary_view">          
          
        </div>
      </td>
    </tr>
  </script>
  
  
  <script type="text/template" id="template-basis-of-record-filter">
    <tr class="filter">
      <td colspan="4">
        <a class="edit" style="display:none;"/>
        <div class="inner filter_view">
          <h4><%= title %></h4>
          <div class="filter">
            <ul class="basis-of-record">
              <#list basisOfRecords as basisOfRecord>         
                <li key="${basisOfRecord}"><a href="#">${action.getFilterTitle('basisOfRecord',basisOfRecord)}</a></li>         
              </#list>
            </ul>            
          </div>
          <div>
            <a href="#" class="button candy_blue_button apply" title="<%= title %>" data-action="add-new-filter" data-filter="<%= paramName %>" apply-function="applyOccurrenceFilters"><span>Apply</span></a>
          </div>
          <a href="#" class="close"></a>
        </div>
        <div class="summary_view">          
          
        </div>
      </td>
    </tr>
  </script>
  
  <script type="text/template" id="template-add-filter">
    <tr class="filter">
      <td colspan="4">
        <a class="edit" style="display:none;"/>
        <div class="inner filter_view">
          <h4><%= title %></h4>
          <div class="filter">
            <table width="100%">                
                <tr> 
                  <td style="border: 0px none !important;">                    
                    <input type="text" name="<%=paramName%>" class="<%= inputClasses %>" placeholder="<%= placeholder %>" />
                    <input type="image" src="<@s.url value='/img/admin/add-small.png'/>" class="addFilter"/>
                    <span style="display:none" class="erroMsg">Please enter a value</span>
                  </td>
                  <td style="border: 0px none !important;">
                    <h4 class="filtersTitle" style="display:none;">Filters</h4>
                    <div class="appliedFilters filterlist" style="display:none;"></div>
                  </td>                  
                </tr>
             </table>                        
          </div>
          <div>          
            <a href="#" class="button candy_blue_button apply" title="<%= title %>" data-action="add-new-filter" data-filter="<%= paramName %>" apply-function="applyOccurrenceFilters"><span>Apply</span></a>
          </div>
          <a href="#" class="close"></a>
        </div>
        <div class="summary_view">          
          
        </div>
      </td>
    </tr>
  </script>
  
  
   <script type="text/template" id="template-simple-filter">
    <tr class="filter">
      <td colspan="4">
        <a class="edit" style="display:none;"/>  
        <div class="inner filter_view">
          <h4><%= title %></h4>
          <div class="filter">
            <table width="100%">                
                <tr> 
                  <td style="border: 0px none !important;">                    
                    <input type="text" name="<%=paramName%>" class="<%= inputClasses %>" placeholder="<%= placeholder %>" />                    
                  </td>
                  <td style="border: 0px none !important;">
                    <h4 class="filtersTitle" style="display:none;">Filters</h4>
                    <div class="appliedFilters filterlist" style="display:none;"></div>
                  </td>                  
                </tr>
             </table>                        
          </div>
          <div>          
            <a href="#" class="button candy_blue_button apply" title="<%= title %>" data-action="add-new-filter" data-filter="<%= paramName %>" apply-function="applyOccurrenceFilters"><span>Apply</span></a>
          </div>
          <a class="close"></a>
        </div>
        <div class="summary_view">          
          
        </div>                
      </td>
    </tr>
  </script>
  
  <script type="text/template" id="template-compare-filter">
    <tr class="filter">
      <td colspan="4">
        <a class="edit" style="display:none;"/>
        <div class="inner filter_view">
          <h4><%= title %></h4>
          <div class="filter">
            <table width="100%">                
                <tr> 
                  <td style="border: 0px none !important;">                    
                    <input type="text" name="<%=paramName%>" class="<%= inputClasses %>" placeholder="<%= placeholder %>" />
                    <select name="predicate" class="date-dropdown">
                      <option value="eq">Is</option>
                      <option value="gt">Is greater than</option>
                      <option value="lt">Is less than</option>
                      <option value="gte">Is greater than or equals</option>
                      <option value="lte">Is less than or equals</option>                      
                    </select>                    
                    <input type="image" src="<@s.url value='/img/admin/add-small.png'/>" class="addFilter">
                    <span style="display:none" class="erroMsg">Please enter a value</span>
                  </td>
                  <td style="border: 0px none !important;">
                    <h4 class="filtersTitle" style="display:none;">Filters</h4>
                    <div class="appliedFilters filterlist" style="display:none;"></div>
                  </td>                  
                </tr>
             </table>                        
          </div>
          <div>          
            <a href="#" class="button candy_blue_button apply" title="<%= title %>" data-action="add-new-filter" data-filter="<%= paramName %>" apply-function="applyOccurrenceFilters"><span>Apply</span></a>
          </div>
          <a href="#" class="close"></a>
        </div>
      </td>
      <div class="summary_view">          
          
        </div> 
    </tr>
  </script>

  <script type="text/template" id="template-filter">
    <ul>
    <li id="filter-<%=paramName%>">
    <div style="display:inline-block"><h4><%= title %></h4></div>
    <% _.each(filters, function(filter) { %>
        <div class="filter"><%= filter.label %><input name="<%= filter.paramName %>" type="hidden" key="<%= filter.key %>" value="<%= filter.value %>"/><a href="#" class="closeFilter"></a></div>        
      <% }); %>                  
    </li>
    </ul>
  </script>
  
  
  <script type="text/template" id="DATASET_KEY-suggestions-template">
    <#list datasetsSuggestions.replacements?keys as title>   
      <#assign suggestion = datasetSuggestions.replacements[title]>         
      <div class="suggestionBox" data-replacement="${title}">         
        <div class="warningBox"> <span class="warningCounter">!</span> The dataset name <strong>"${title}"</strong> was replaced by: <br>            
          ${suggestion.title}                             
        </div>                               
      </div>               
     </#list>         
    <#list datasetsSuggestions.suggestions?keys as title>            
      <div class="suggestionBox" data-suggestion="${title}">         
       <#assign suggestions = datasetsSuggestions.suggestions[title]>
         <#if suggestions?has_content>
          <div class="warningBox"> <span class="warningCounter">!</span> We found more than one scientific name that matched <strong>"${title}"</strong>.Please select a dataset from the list below.</div>                               
          <#list suggestions as datasetSearchResult>
              <input id="searchResult${datasetSearchResult.key}" type="radio" value="${datasetSearchResult.key}" name="DATASET_KEY" class="suggestion" data-suggestion="${title}"/>
              <label for="searchResult${datasetSearchResult.key}">${datasetSearchResult.title}
              <#if datasetSearchResult.owningOrganizationTitle?has_content>                 
                (Published by  <em>${datasetSearchResult.owningOrganizationTitle} </em>)
              <#elseif datasetSearchResult.networkOfOriginKey?has_content>
                (Originates from <em>${action.getNetWorkTitle(datasetSearchResult.networkOfOriginKey)!"Unknown"}</em>)
              </#if>                
              </label>                
              </br>                                                    
          </#list>
         <#else>
           <div class="warningBox"> <span class="warningCounter">${title_index + 1}</span> We haven't found any dataset name that matched <strong>"${title}"</strong>.</div>
         </#if>                  
      </div>               
     </#list>
  </script>
  
  
  <script type="text/template" id="suggestions-template-filter">
    <ul>
    <li id="filter-<%=paramName%>">
    <div style="display:inline-block"><h4><%= title %></h4></div>
    <% _.each(filters, function(filter) { %>
        <div class="filter"><%= filter.label %><input name="<%= filter.paramName %>" type="hidden" key="<%= filter.key %>" value="<%= filter.value %>"/><a href="#" class="closeFilter"></a></div>         
      <% }); %>                  
      <%=_.template($( "#" + paramName + "-suggestions-template").html())()%>      
    </li>
    </ul>
  </script>
  
  <script type="text/template" id="COLLECTOR_NAME-suggestions-template">  
    <#list collectorSuggestions.suggestions?keys as name>            
      <div class="suggestionBox" data-suggestion="${name}">         
       <#assign suggestions = collectorSuggestions.suggestions[name]>
         <#if suggestions?has_content>
          <div class="warningBox"> <span class="warningCounter">!</span>The collector name  <strong>"${name}"</strong> didn't match any existing record.You can select one from the list below to try improving your search results.</div>                               
          <#list suggestions as suggestion>
              <input id="searchResult${suggestion}" type="radio" value="${suggestion}" name="COLLECTOR_NAME" class="suggestion" data-suggestion="${name}"/>
              <label for="searchResult${suggestion}">${suggestion}</label>                
              </br>                                                    
          </#list>           
         </#if>                  
      </div>               
     </#list>       
  </script>
  
  
  <script type="text/template" id="CATALOG_NUMBER-suggestions-template">  
    <#list catalogNumberSuggestions.suggestions?keys as name>            
      <div class="suggestionBox" data-suggestion="${name}">         
       <#assign suggestions = catalogNumberSuggestions.suggestions[name]>
         <#if suggestions?has_content>
          <div class="warningBox"> <span class="warningCounter">!</span>The catalog number  <strong>"${name}"</strong> didn't match any existing record. You can select one from the list below to try improving your search results.</div>                               
          <#list suggestions as suggestion>
              <input id="searchResult${suggestion}" type="radio" value="${suggestion}" name="CATALOG_NUMBER" class="suggestion" data-suggestion="${name}"/>
              <label for="searchResult${suggestion}">${suggestion}</label>                
              </br>                                                    
          </#list>           
         </#if>                  
      </div>               
     </#list>       
  </script>
  
  <script type="text/template" id="TAXON_KEY-suggestions-template">    
    <#list nameUsagesSuggestions.replacements?keys as sciname>   
      <#assign suggestion = nameUsagesSuggestions.replacements[sciname]>         
      <div class="suggestionBox" data-replacement="${sciname}">         
        <div class="warningBox"> <span class="warningCounter">!</span> The scientific name <strong>"${sciname}"</strong> was replaced by: <br>            
          ${suggestion.scientificName}                  
          <ul class="taxonomy">
            <#list suggestion.higherClassificationMap?values as classificationName>                    
              <li <#if !classificationName_has_next> class="last" </#if>>${classificationName}</li>
            </#list>
           </ul>
        </div>                               
      </div>               
     </#list>         
    <#list nameUsagesSuggestions.suggestions?keys as sciname>            
      <div class="suggestionBox" data-suggestion="${sciname}">         
       <#assign suggestions = nameUsagesSuggestions.suggestions[sciname]>
         <#if suggestions?has_content>
          <div class="warningBox"> <span class="warningCounter">!</span> We found more than one scientific name that matched <strong>"${sciname}"</strong>.Please select a name from the list below.</div>                               
          <#list suggestions as nameUsageSearchResult>
              <input id="searchResult${nameUsageSearchResult.key?c}" type="radio" value="${nameUsageSearchResult.key?c}" name="TAXON_KEY" class="suggestion" data-suggestion="${sciname}"/><label for="searchResult${nameUsageSearchResult.key?c}">${nameUsageSearchResult.scientificName}</label>
              </br>                
              <ul class="taxonomy">
                <#list nameUsageSearchResult.higherClassificationMap?values as classificationName>
                  <li <#if !classificationName_has_next> class="last" </#if>> ${classificationName} </li>
                </#list>
               </ul>              
              </br>                          
          </#list>
         <#else>
           <div class="warningBox"> <span class="warningCounter">${sciname_index + 1}</span> We haven't found any scientific name that matched <strong>"${sciname}"</strong>.</div>
         </#if>                  
      </div>               
     </#list>  
  </script>
  
  <script type="text/template" id="template-applied-filter">
    <li style="list-style: none;display:block;">    
      <div><div style="float:left;" title="<%=title%>"><%= label %><input name="<%= paramName %>" type="hidden" key="<%= key %>" value="<%= value %>"/></div><a href="#" class="closeFilter" style="float:left;"></a></div>       
    </li>
  </script>
    
  <script type="text/template" id="map-template-filter">
     <tr class="filter">
      <td colspan="4">        
        <a class="edit" style="display:none;"/>
        <div class="inner filter_view">  
          <h4>Location</h4>                   
          <div id="bboxContainer">  
              <div style="width:300px;">
                <fieldset class="location_option_geo">
                  <legend>Show only records</legend>                
                  <label for="isGeoreferenced">Georeferenced</label> <input type="checkbox" name="GEOREFERENCED" id="isGeoreferenced" value="true" <#if action.isInFilter('GEOREFERENCED', 'true')> checked</#if>/>
                  <span>&nbsp;&nbsp;&nbsp;&nbsp;</span>
                  <label for="isNotGeoreferenced">NON georeferenced</label> <input type="checkbox" name="GEOREFERENCED" id="isNotGeoreferenced" value="false" <#if action.isInFilter('GEOREFERENCED', 'false') && !action.isInFilter('GEOREFERENCED', 'true')> checked</#if>/>
                </fieldset>
              </div>
              <fieldset class="location_option_geo">  
              <legend>Bounding box</legend>                                                    
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
                      <h4 class="filtersTitle" style="display:none;">Filters</h4>
                      <div class="appliedFilters filterlist" style="display:none;"></div>
                      <br>                      
                  </td>
                </tr>                                 
              </table>
              </fieldset>
              <div>         
                <a href="#" class="button candy_blue_button apply" title="<%= title %>" data-action="add-new-bbox-filter" data-filter="<%= paramName %>"><span>Apply</span></a>
               </div>         
           </div>                             
           <a href="#" class="close"></a>     
        </div>
        <div class="summary_view">          
          
        </div> 
       </td>
     </tr>
  </script>