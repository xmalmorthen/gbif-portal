<#import "/WEB-INF/macros/pagination.ftl" as macro>
<html>
  <head>
    <title>Occurrence Search Results</title>
    <meta name="menu" content="occurrences"/>
    <content tag="extra_scripts">
    <!--<link rel="stylesheet" href="<@s.url value='/css/occ_table.css?v=2'/>"/>  -->
    <script type="text/javascript" src="<@s.url value='/js/custom/jquery.gbif.filters.js'/>"></script>
    <script src='<@s.url value='/js/vendor/jquery.url.js'/>' type='text/javascript'></script>
    <script>

      $(function() {

        $(".dropdown .title").on("click", function(e) {
          e.preventDefault();
          $(this).parent().toggleClass("selected");
        });

      });

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

    </script>
    </content>
  </head>
  <body class="search typesmap">

    <content tag="infoband">
    <h2>Search occurrences</h2> 
    </content>

    <article class="ocurrence_results">
    <header></header>

    <div class="content">

      <table class="results">
        <tr class="header">
          <td>      
            <h2>${searchResponse.count} results</h2>
          </td>
          <td class="options" colspan="3">
            <ul>
              <li><a href="#" class="configure"><i></i> Configure</a></li>
              <li><a href="#" class="filters"><i></i> Add a filter</a></li>
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
        <a href="#" class="candy_white_button previous"><span>Previous page</span></a>
        <div class="pagination">viewing page 2 of 31</div>
        <a href="#" class="candy_white_button next"><span>Next page</span></a>
      </div>

      <!--
      <div id='filter-container'></div>
      <br>
      <input type="hidden" value="${datasetKey}" name="datasetKey" id="datasetKey"/>
      <input type="hidden" value="${nubKey}" name="nubKey" id="nubKey"/>
      <#if searchResponse.count gt 0>
      <div style="overflow: auto !important;"> 
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
              <td><#if occ.scientificName?has_content>${occ.scientificName}</#if></td>
              <td><#if occ.datasetKey?has_content><a href="<@s.url value='/dataset/${occ.datasetKey}'/>">${action.getDatasetTitle(occ.datasetKey)!}</a></#if></td>
              <td><#if occ.institutionCode?has_content>${occ.institutionCode!}</#if></td>
              <td><#if occ.collectionCode?has_content>${occ.collectionCode!}</#if></td>
              <td><#if occ.catalogNumber?has_content>${occ.catalogNumber!}</#if></td>
              <td><#if occ.basisOfRecord?has_content>${occ.basisOfRecord!}</#if></td>
              <td><#if occ.occurrenceYear?has_content>${occ.occurrenceYear!?c}</#if></td>
              <td><#if occ.occurrenceMonth?has_content>${occ.occurrenceMonth!?c}</#if></td>
              <td><#if occ.latitude?has_content>${occ.latitude!?c}<#else>-</#if>/<#if occ.longitude?has_content>${occ.longitude!?c}<#else>-</#if></td>
              <td><#if occ.isoCountryCode?has_content> ${occ.isoCountryCode!} </#if></td>
              <td><a href="<@s.url value='/occurrence/${occ.key?c}'/>"><strong>View</strong></a></td>
            </tr>
            </#list>
          </tbody>
        </table>  
      </div>        
      <br>
      <div class="footer">          
        <@macro.pagination page=searchResponse url=currentUrl/>          
      </div>        
      </#if>                  
    </div>

    <div class="right">
      <div id='query-container'></div>      
      <input type="submit" value="Search" id="submit-button" style="display: none"/>

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
      -->


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




  </body>
</html>
