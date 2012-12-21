<html xmlns="http://www.w3.org/1999/html">
<head>
  <title>Occurrences - GBIF</title>
  <content tag="extra_scripts">
    <script src='<@s.url value='/js/vendor/jquery.url.js'/>' type='text/javascript'></script>
    <script type="text/javascript" src="<@s.url value='/js/vendor/jquery-ui-1.8.17.min.js'/>"></script>
    <script type="text/javascript" src="<@s.url value='/js/terms_suggest.js'/>"></script>
    <script type="text/javascript" src="<@s.url value='/js/species_autocomplete.js'/>"></script>
    <script type="text/javascript" src="<@s.url value='/js/dataset_autocomplete.js'/>"></script>
    
    <!--Maps-->
    <link rel="stylesheet" href="<@s.url value='/js/vendor/leaflet/leaflet.css'/>" />
    <link rel="stylesheet" href="<@s.url value='/js/vendor/leaflet/draw/leaflet.draw.css'/>" />
    <!--[if lte IE 8]><link rel="stylesheet" href="<@s.url value='/js/vendor/leaflet/leaflet.ie.css'/>" /><![endif]-->
    <script type="text/javascript" src="<@s.url value='/js/vendor/leaflet/leaflet.js'/>"></script>
    <script type="text/javascript" src="<@s.url value='/js/vendor/leaflet/draw/leaflet.draw.js'/>"></script>
    <script type="text/javascript" src="<@s.url value='/js/occurrence_filters.js'/>"></script>    
	<style>     
    div#email-container {
      margin-bottom: 10px;
    }

    #download a {
      width:80px;
    }

    #download {
      border-top: 0px !important;
    }

    #download input {
      width:300px;
    }

  </style>

  <script>
    var filtersFromRequest = new Object();   
      function addFilters(filtersFromRequest,filterKey,filterValue,filterLabel) {
        filtersFromRequest[filterKey].push({ label: filterLabel, value:filterValue, key: filterValue, paramName: filterKey });
      } 
      <#if filters.keySet().size() gt 0>                   
         <#list filters.keySet() as filterKey>
            filtersFromRequest['${filterKey}'] = new Array();
           <#list filters.get(filterKey) as filterValue>
             //the title is taken from the link that has the filterKey value as its data-filter attribute
             addFilters(filtersFromRequest,'${filterKey}','${filterValue}','${action.getFilterTitle(filterKey,filterValue)}');                        
           </#list>
         </#list>
      </#if>

  $(document).ready(function() {  
   var widgetManager = new OccurrenceWidgetManager("<@s.url value='/occurrence/download/result'/>?",filtersFromRequest,".dropdown-menu",false);            
    $('#submit-button').click(function() {      
      widgetManager.submit({email:$('#email-text').val()});
    });
  });
  </script>

  <#if action.hasErrors()>
   <script>
     $(document).ready(function() {
       $("tr.filters}").hide();
     });
    </script>
  </#if>
  </content>

</head>
<body class="search typesmap">

  <content tag="infoband">
    <h2>Download occurrences</h2> 
    </content>
  <article class="ocurrence_results">
    <header></header>
    <div class="content" id="content">
        
          <table class="results">
              <tr class="header">                         
                <td class="options">
                  <ul>                    
                    <li>
                    <a href="#" class="filters" data-toggle="dropdown"><i></i> Add a filter</a>
      
                    <div class="dropdown-menu filters">
                      <div class="tip"></div>
                      <ul>
                        <li><a tabindex="-1" href="#" data-placeholder="Type a scientific name..." data-filter="TAXON_KEY"  title="Scientific name" data-template-filter="template-add-filter" data-input-classes="value species_autosuggest" class="filter-control">Scientific name</a></li>
                        <li><a tabindex="-1" href="#" data-placeholder="Type a location..." data-filter="BOUNDING_BOX" title="Bounding Box" data-template-filter="map-template-filter" class="filter-control">Location</a></li>
                        <li><a tabindex="-1" href="#" data-placeholder="Type a collector name..." data-filter="COLLECTOR_NAME" title="Collector name" data-template-filter="template-add-filter" data-input-classes="value collector_name_autosuggest" class="filter-control">Collector</a></li>
                        <li><a tabindex="-1" href="#" data-placeholder="Type a name..." data-filter="BASIS_OF_RECORD" title="Basis Of Record" data-template-filter="template-basis-of-record-filter" class="filter-control">Basis of record</a></li>
                        <li><a tabindex="-1" href="#" data-placeholder="Type a dataset name..." data-filter="DATASET_KEY" title="Dataset" data-template-filter="template-add-filter" data-input-classes="value dataset_autosuggest" class="filter-control">Dataset</a></li>
                        <li><a tabindex="-1" href="#" data-placeholder="Type a dataset date..." data-filter="DATE" title="Collection date" data-template-filter="template-add-date-filter" class="filter-control">Collection date</a></li>
                        <li><a tabindex="-1" href="#" data-placeholder="Type a catalog number..." data-filter="CATALOG_NUMBER" title="Catalog number" data-template-filter="template-add-filter" data-input-classes="value catalog_number_autosuggest" class="filter-control">Catalog number</a></li>
                        <li><a tabindex="-1" href="#" data-placeholder="Type a altitude value..." data-filter="ALTITUDE" title="Altitude" data-template-filter="template-compare-filter" data-input-classes="value" class="filter-control">Altitude</a></li>
                        <li><a tabindex="-1" href="#" data-placeholder="Type a depth value..." data-filter="DEPTH" title="Depth" data-template-filter="template-compare-filter" data-input-classes="value" class="filter-control">Depth</a></li>
                        <li class="divider"></li>
                        <li class="more"><a tabindex="-1" href="#">Need a different filter?</a></li>
                      </ul>                      
                    </div>
                  </li>
                </ul>
              </td>              
            </tr>  
            <#if !action.hasErrors()>
            <tr>
              <td>                
                <div id="download" class="left">
                    <div class="col">
                      <a href="#" class="button candy_blue_button" id="submit-button"><span>Download</span></a>
                    </div>
                    <div class="col">
                        Notify additional emails: <input type="text" name="emails" title="Additional email addresses seperated by ; that should get notified"/>
                    </div>
                </div>
              </td>           
            </tr> 
            <#else>
            <tr class="header filters-error-list">
              <td>     
                <ul>
                <#list action.fieldErrors.keySet() as field>            
                      <li><h4>${field}</h4>
                      <#list action.fieldErrors.get(field) as error>            
                          <div class="filter filter-error">${error}</div>         
                      </#list>
                      </li>            
                </#list>
                </ul>   
              </td>
             </tr>                  
            </#if>
          </table> 
    </div>
    <footer></footer>
  </article>
  <#include "/WEB-INF/pages/occurrence/inc/filters.ftl">
</body>
</html>
