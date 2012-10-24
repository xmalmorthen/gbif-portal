<html>
<head>
  <title>Crawler - GBIF</title>
  <content tag="extra_scripts">
    <!-- If this table design/behaviour suits our needs, then 'jquery.dataTables.js' should be stored locally -->
    <script type="text/javascript" language="javascript" src="http://www.datatables.net/release-datatables/media/js/jquery.dataTables.js"></script>
    <link rel="stylesheet" href="<@s.url value='/css/crawl-table.css'/>"/>

<script>  
  $(document).ready(function() {
      $('#table_crawl').dataTable( {
        "aaSorting": [[ 0, "asc" ]]
      });
  });

  $('#hostingNodesList').change(function() {
    $("#hostingPublisher").html("<img src='../img/ajax-loader.gif'/ height='15'>");
    var url = cfg.wsReg + 'node/' + $("#hostingNodesList").val() + '/organization?callback=?';
    $.getJSON(url, function(data) {
      var options = '<option value="" selected="selected">Choose a data publisher</option>';
      $.each(data.results, function(key, val) {
        options += '<option value="' + val.key + '">' + val.title + '</option>';
      });
      $("#hostingPublisher").html(""); 
      $("select#hostingPublisherList").removeAttr('disabled');
      $("select#hostingPublisherList").html(options);
    });
  });    
    
  $('#owningNodesList').change(function() {
    $("#owningPublisher").html("<img src='../img/ajax-loader.gif'/ height='15'>");    
    var url = cfg.wsReg + 'node/' + $("#owningNodesList").val() + '/organization?callback=?';
    $.getJSON(url, function(data) {
      var options = '<option value="" selected="selected">Choose a data publisher</option>';
      $.each(data.results, function(key, val) {
        options += '<option value="' + val.key + '">' + val.title + '</option>';
      });
      $("#owningPublisher").html("");
      $("select#owningPublisherList").removeAttr('disabled');
      $("select#owningPublisherList").html(options);
    });
  });    
    
  $('#hostingButton').click(function() {
    $('#crawl_process').html("<img src='../img/ajax-loader.gif'/ height='15'> Wait while we retrieve the datasets...");
    var url = '${baseUrl}/admin/crawler?orgHost=' + $("#hostingPublisherList").val()+'&nodeHost=' + $("#hostingNodesList").val();
    window.location.href = url;
  });      
    
  $('#owningButton').click(function() {
    $('#crawl_process').html("<img src='../img/ajax-loader.gif'/ height='15'> Wait while we retrieve the datasets...");
    var url = '${baseUrl}/admin/crawler?orgOwn=' + $("#owningPublisherList").val();
    window.location.href = url;
  });  
    
  $('.crawl').click(function() {
    var $parentRow = $(this).parent();
    var dsKey = $(this).attr("id");
    var url = '${baseUrl}/admin/crawler/crawl/' + dsKey;
    $.get(url, function(data) {
      $parentRow.html("<img src='../img/ajax-loader.gif'/ height='15'> crawling...");
    });      
  });           
    
  $('.crawl_popup').click(function(e) {
    e.preventDefault();
    var $context = $(".crawl_popup").attr("content");
    $('#crawlContext').html($context);
    $('#crawlContext').dialog();
  });             
</script>

</content>

</head>
<body class="dataset">
  <article class="results">
    <header></header>
    <div class="content">
      <div class="header">
        <h2>Crawling monitoring</h2>        
      </div>
      <table><tr><td>
      <p /><br />
          
        Hosting institution in node:<br/>
        <@s.select name="hostingNodesList" value="'${(member!).endorsingNodeKey!}'" list="nodes" 
          listKey="key" listValue="title" headerKey="" headerValue="Choose a node"/>
        <br />
        Hosting institution:<br/>
        <span id="hostingPublisher"></span>
        <@s.select name="hostingPublisherList" value="'${(member!).endorsingNodeKey!}'"
          headerKey="" headerValue="Choose a publisher" disabled="true"/>
          
        <p><button type="button" id="hostingButton">Get results</button></p>
        
        Owning institution in node:<br/>         
        <@s.select name="owningNodesList" value="'${(member!).endorsingNodeKey!}'" list="nodes" 
          listKey="key" listValue="title" headerKey="" headerValue="Choose a node"/>
        <br />
        Owning institution:<br/>
        <span id="owningPublisher"></span>
        <@s.select name="owningPublisherList" value="'${(member!).endorsingNodeKey!}'"
          headerKey="" headerValue="Choose a publisher" disabled="true"/>
          
        <p><p><button type="button" id="owningButton">Get results</button></p></p>
        
        <span id="crawl_process"></span>
      </td><td>
        <#list occurrenceEndpoints as endpoint>
          <@s.checkbox label="name" name="name" value="name" disabled="true"/> ${endpoint}<br/>
        </#list> 
      </td></tr></table>
      <div>
        [ <a href="<@s.url value='crawler'/>">Show current crawls</a> ]
        <p />
          
        <table id="table_crawl" class="display">
          <thead>
            <tr>
              <th>Publisher</th>
              <th>Dataset</th>
              <th>Started</th>
              <th>Finished</th>
              <th>Context</th>
              <th>Pages crawled</th>
              <th>Pages fragmented</th>
              <th>Fragments processed</th>
              <th>Crawl?</th>
            </tr>
          </thead>
          <tbody>
            <#list metrics! as ds>
              <tr>
                <td><a href="${baseUrl}/organization/${(ds.dataset.owningOrganizationKey)!}">${ds.owningOrganizationName!}</a></td>
                <td><a href="${baseUrl}/dataset/${(ds.dataset.key)!}">${(ds.dataset.title)!}</a></td>
                <td>${(ds.crawlMetrics.startedCrawling?datetime)!"--"}</td>
                <td>${(ds.crawlMetrics.finishedCrawling?datetime)!"--"}</td>
                <td><a href="#" class="crawl_popup" content='${(ds.crawlMetrics.crawlContext)!'No crawl context available'}'>View<div id="crawlContext"></div></a></td>
                <td>${(ds.crawlMetrics.pagesCrawled)!"--"}</td>
                <td>${(ds.crawlMetrics.pagesFragmented)!"--"}</td>
                <td>${(ds.crawlMetrics.fragmentsProcessed)!"--"}</td>
                <td><button type="button" class="crawl" id="${(ds.dataset.key)!}">Crawl me!</button></td>
              </tr>
            </#list>
          </tbody>
        </table>  
      </div>
    </article>
  <footer></footer>

</body>
</html>
