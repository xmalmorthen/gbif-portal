<#import "/WEB-INF/macros/pagination.ftl" as macro>
<html>
<head>
  <title>Occurrence Search Results</title>
  <meta name="menu" content="occurrences"/>
  <content tag="extra_scripts">
    <link rel="stylesheet" href="<@s.url value='/css/occ_table.css?v=2'/>"/>  
    <script type="text/javascript" src="<@s.url value='/js/custom/jquery.gbif.filters.js'/>"></script>
    <script src='<@s.url value='/js/vendor/jquery.url.js'/>' type='text/javascript'></script>
    <script>
      var query = $('#query-container').Query();

      // subject container with event wiring to trigger changes on query
      $('#filter-container').Filter({
        json:"<@s.url value='/conf/occurrence-search.json'/>",
        addFilter: function(event, data) {
          query.Query("add", data.filter);
        }
      });
      
       $('#submit-button').click(function() {
        // construct the query parameters again.  This will remove ALL
        // parameters and reconstruct the URL with the new filter
        // This might cause issues in the future, if other parameters are needed
        // https://github.com/allmarkedup/jQuery-URL-Parser         
         if($("#datasetKey").val()){
            query.Query("add",'datasetKey=' + $("#datasetKey").val());            
         }
         if($("#nubKey").val()){
            query.Query("add",'nubKey=' + $("#nubKey").val());
         }
         
        var u = $.url();     
        
        window.location = "<@s.url value='/occurrence/search'/>" + query.Query("serialize");
        return true;  // submit?
      });
    </script>
  </content>
</head>
<body class="search typesmap">

<content tag="infoband">
  <h2>Search occurrences</h2> 
</content>

<article class="results light_pane taxonomies">
  <header></header>
  <div class="content">

    <div class="header">
      <div class="left">
        <h2>${searchResponse.count} results</h2>
      </div>
      <div class="right"><h3>Refine your search</h3></div>
    </div>

    <div class="left">
      <div id='filter-container'></div>
      <input type="hidden" value="${datasetKey}" name="datasetKey"/>
      <input type="hidden" value="${nubKey}" name="nubKey"/>
       <#if searchResponse.count gt 0>
         <table id="tableResults" class="hor-minimalist-b">
         <thead>
          <tr>
            <th>Scientific<br>name</th>
            <th>Dataset</th>
            <th>Institution<br>Code</th>
            <th>Collection<br>Code</th>
            <th>Catalogue<br>Number</th>
            <th>Basis<br>of<br>Record</th>
            <th>Year</th>
            <th>Month</th>
            <th>Coordinates</th>
            <th>Country</th>
            <th></th>
          </tr>
          </thead>
          <tbody>
           <#list searchResponse.results as occ>
           <tr>
            <td><#if occ.scientificName?has_content>${occ.scientificName!}</#if></td>
            <td><#if occ.datasetKey?has_content>${occ.datasetKey!}</#if></td>
            <td><#if occ.institutionCode?has_content>${occ.institutionCode!}</#if></td>
            <td><#if occ.collectionCode?has_content>${occ.collectionCode!}</#if></td>
            <td><#if occ.catalogNumber?has_content>${occ.catalogNumber!}</#if></td>
            <td><#if occ.basisOfRecord?has_content>${occ.basisOfRecord!}</#if></td>
            <td><#if occ.occurrenceYear?has_content>${occ.occurrenceYear!?c}</#if></td>
            <td><#if occ.occurrenceMonth?has_content>${occ.occurrenceMonth!?c}</#if></td>
            <td><#if occ.latitude?has_content>${occ.latitude!?c}<#else>-</#if>/<#if occ.longitude?has_content>${occ.longitude!?c}<#else>-</#if></td>
            <td><#if occ.isoCountryCode?has_content> ${occ.isoCountryCode!} </#if></td>
            <td><a href="<@s.url value='/occurrence/${occ.id?c}'/>"><strong>View</strong></a></td>
            </tr>
           </#list>
           </tbody>
         </table>
         <br>
         <div class="footer">          
            <@macro.pagination page=searchResponse url=currentUrl/>          
        </div>
      </#if>              
  </div>
  <div class="right">
    <div id='query-container'></div>      
    <input type="submit" value="Search" id="submit-button"/>
    <div class="download">
      <div class="dropdown">
        <a href="#" class="title" title="Download description"><span>Download occurrences</span></a>
        <ul>
          <li><a href="#a"><span>Download occurrences</span></a></li>
          <li><a href="#a"><span>Download placemarks</span></a></li>
          <li class="last"><a href="#b"><span>Download metadata</span></a></li>
        </ul>
      </div>
    </div>
  </div>   
  </div>
  <footer></footer>  
</article>

</body>
</html>
