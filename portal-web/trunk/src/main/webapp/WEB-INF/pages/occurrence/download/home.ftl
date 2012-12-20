<html>
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
      div.general_options ul {position:relative; bottom:0px; left:0px; display:inline-block; width:auto; height:28px; padding:3px 0px 0px 3px; margin:0; background:#282F49; -webkit-border-top-left-radius: 5px; -moz-border-radius-topleft: 5px; border-top-left-radius: 5px; z-index:100;}
      div.map_options ul{display:inline-block; margin:0px; padding:0px; width:auto; height:28px; padding:3px 0px 0px 3px;}
      div.map_options ul li {display:inline-block; width:auto; height:25px; margin-right:1px; vertical-align:middle; overflow:hidden;}
      div.map_options ul li a {display:block; width:auto; height:11px; padding:6px 7px; text-decoration:none; -webkit-border-radius:5px;-moz-border-radius:5px;border-radius:5px;border:1px solid #161A29; font:bold 11px Arial; color:#333333; text-shadow:0 1px white;background:linear-gradient(-90deg,#ffffff,#CACBCE);background:-webkit-gradient(linear,50% 0%,50% 100%,from(#ffffff),to(#CACBCE));background:-moz-linear-gradient(-90deg,#ffffff,#CACBCE);background:-o-linear-gradient(#ffffff,#CACBCE);background:#ffffff\9;cursor:default;}
      div.map_options ul li a:hover {background:linear-gradient(-90deg,#CACBCE,#ffffff);background:-webkit-gradient(linear,50% 0%,50% 100%,from(#CACBCE),to(#ffffff));background:-moz-linear-gradient(-90deg,#CACBCE,#ffffff);background:-o-linear-gradient(#CACBCE,#ffffff);background:#CACBCE\9;cursor:pointer;}

    .description {
      margin-top: 10px;
      padding: 10px;
      color: #666;
      background-color: #E5F5FA;
    }

    p.query {
      color: #999;
      margin: 0px;
      padding: 0px;
      font-size: 11px;
      font-family: DINOT-Medium, sans-serif;
    }
    ul.query {
      list-style: none;
      padding: 0px 0px 10px 10px;
      margin: 0px;
      color: #666;
      font-weight: bold;
    }
    ul.query .boolean {
      color: #999;
      margin: 0px;
      padding: 0px;
      font-size: 11px;
      font-weight: normal;
      font-family: DINOT-Medium, sans-serif;
    }

    select,input {
      margin-right: 5px;
    }
    select.subject {
      width: 150px;
    }
    select.predicate {
      width: 120px;
    }
    select.value {
      width: 200px;
    }

    div#email-container {
      margin-bottom: 10px;
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
   /** var query = $('#query-container').Query();

    // subject container with event wiring to trigger changes on query
    $('#filter-container').Filter({
      json:"<@s.url value='/conf/occurrence-download.json'/>",
      addFilter: function(event, data) {
        query.Query("add", data.filter);
      }
    });**/

  $(document).ready(function() {  
   var widgetManager = new OccurrenceWidgetManager("<@s.url value='/occurrence/download/result'/>?",filtersFromRequest,".dropdown-menu",false);            
    $('#submit-button').click(function() {      
      widgetManager.submit({email:$('#email-text').val()});
    });
  });
  </script>

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
            <tr>
              <td>                
                <div id='email-container'>Email: <input type="text" id="email-text"/></div>
                <div style="width:80px;">
                  <a href="#" class="button candy_blue_button" id="submit-button"><span>Download</span></a>
                </div>                                    
              </td>           
            </tr>                   
          </table> 
    </div>
    <footer></footer>
  </article>
  <#include "/WEB-INF/pages/occurrence/inc/filters.ftl">
</body>
</html>
