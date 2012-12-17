<#import "/WEB-INF/macros/pagination.ftl" as macro>
<html>
  <head>
    <title>Occurrence Search Results</title>

    <content tag="extra_scripts">    
<!--    <link rel="stylesheet" href="<@s.url value='/css/combobox.css?v=2'/>"/>    -->
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
       var widgetManager = new OccurrenceWidgetManager("<@s.url value='/occurrence/search'/>?",filtersFromRequest,".dropdown-menu",true);      
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
                  <li><a tabindex="-1" href="#" data-placeholder="Type a scientific name..." data-filter="TAXON_KEY"  title="Scientific name" data-template-filter="template-add-filter" data-input-classes="value species_autosuggest" class="filter-control">Scientific name</a></li>
                  <li><a tabindex="-1" href="#" data-placeholder="Type a location..." data-filter="BOUNDING_BOX" title="Bounding Box" data-template-filter="map-template-filter" class="filter-control">Location</a></li>
                  <li><a tabindex="-1" href="#" data-placeholder="Type a collector name..." data-filter="COLLECTOR_NAME" title="Collector name" data-template-filter="template-add-filter" data-input-classes="value collector_name_autosuggest" class="filter-control">Collector</a></li>
                  <li><a tabindex="-1" href="#" data-placeholder="Type a name..." data-filter="BASIS_OF_RECORD" title="Basis Of Record" data-template-filter="template-basis-of-record-filter" class="filter-control">Basis of record</a></li>
                  <li><a tabindex="-1" href="#" data-placeholder="Type a dataset name..." data-filter="DATASET_KEY" title="Dataset" data-template-filter="template-add-filter" data-input-classes="value dataset_autosuggest" class="filter-control">Dataset</a></li>
                  <li><a tabindex="-1" href="#" data-placeholder="Type a dataset date..." data-filter="DATE" title="Collection date" data-template-filter="template-add-date-filter" class="filter-control">Collection date</a></li>
                  <li><a tabindex="-1" href="#" data-placeholder="Type a catalog number..." data-filter="CATALOG_NUMBER" title="Catalog number" data-template-filter="template-add-filter" data-input-classes="value catalog_number_autosuggest" class="filter-control">Catalog number</a></li>
                  <li class="divider"></li>
                  <li class="more"><a tabindex="-1" href="#">Need a different filter?</a></li>
                </ul>
                <input type="hidden" id="nubTaxonomyKey" value="${nubTaxonomyKey}"/>
              </div>
            </li>
          </ul>
        </td>
      </tr>      
      <#if searchResponse.count gt 0>
      <tr class="results-header">
        <td></td>
        <td><h4>Location</h4></td>
        <td><h4>Basis of record</h4></td>
        <td><h4>Date</h4></td>
      </tr>
      <#list searchResponse.results as occ>
      <tr>
        <td>
          <div class="header"> 
            <span class="code">${occ.key?c}</span> 
            <#if occ.catalogNumber?has_content>· <span class="catalog">Cat. ${occ.catalogNumber!}</span></#if>
          </div>
          <#if occ.scientificName?has_content><a href="<@s.url value='/occurrence/${occ.key?c}'/>">${occ.scientificName}</a></#if>

          <div class="footer">Published by <#if occ.datasetKey?has_content>${action.getDatasetTitle(occ.datasetKey)!}</#if></div>
        </td>
        <td class="country"><#if occ.country?has_content><div class="country">${occ.country.title!}</div></#if>
          <div class="coordinates">
            <#if occ.latitude?has_content || occ.longitude?has_content>
              <#if occ.latitude?has_content>${occ.latitude!?string("0.00")}<#else>-</#if>/<#if occ.longitude?has_content>${occ.longitude!?string("0.00")}<#else>-</#if>
            <#else>
              N/A
            </#if>
          </div>
        </td>
        <td class="kind">
        <#if occ.basisOfRecord?has_content || occ.longitude?has_content>
          ${action.getFilterTitle('basisOfRecord',occ.basisOfRecord)!}
        <#else>
         N/A
        </#if></td>
        <td class="date">
          <#if occ.occurrenceMonth?has_content || occ.occurrenceYear?has_content>
            <#if occ.occurrenceMonth?has_content>${occ.occurrenceMonth!?c}<#else>-</#if>     
            /    
            <#if occ.occurrenceYear?has_content>${occ.occurrenceYear!?c}<#else>-</#if>
          <#else>
            N/A
          </#if>
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
      <span> Or refine it using the <a href="<@s.url value='/occurrence/download'/>">advanced search</a></span>
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

  <#include "/WEB-INF/pages/occurrence/inc/filters.ftl">

  <!-- /Filter templates -->
  <div class="infowindow" id="waitDialog">
    <div class="light_box">
      <div class="content" >
        <h3>Processing request</h3>
        <p>Wait while your request is processed...
        <img src="<@s.url value='/img/ajax-loader.gif'/>" alt=""/>
      </div>
    </div>
  </div>
</body>
</html>
