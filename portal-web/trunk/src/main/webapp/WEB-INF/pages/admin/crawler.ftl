<html>
<head>
  <title>Crawler - GBIF</title>
  <content tag="extra_scripts">
    <script type="text/javascript" language="javascript" src="http://www.datatables.net/release-datatables/media/js/jquery.dataTables.js"></script>
    <link rel="stylesheet" href="<@s.url value='/css/crawl-table.css'/>"/>

	<style>
      .selectBox {
        width: 150px;
      }
    </style>

  <script>
  
$(document).ready(function() {
    $('#table_id').dataTable( {
        "aaSorting": [[ 0, "asc" ]]
        });
} );

    $('#hostingNodesList').change(function() {
      var url = cfg.wsReg + 'node/' + $("#hostingNodesList").val() + '/organization?callback=?';
      $.getJSON(url, function(data) {
        var options = '<option value="" selected="selected">Choose a data publisher</option>';
        $.each(data.results, function(key, val) {
          options += '<option value="' + val.key + '">' + val.title + '</option>';
        });
        $("select#hostingPublisherList").html(options);
      });  
    });    
    
    $('#owningNodesList').change(function() {
      var url = cfg.wsReg + 'node/' + $("#owningNodesList").val() + '/organization?callback=?';
      $.getJSON(url, function(data) {
        var options = '<option value="" selected="selected">Choose a data publisher</option>';
        $.each(data.results, function(key, val) {
          options += '<option value="' + val.key + '">' + val.title + '</option>';
        });
        $("select#owningPublisherList").html(options);
      });  
    });    
  </script>

  </content>

</head>
<body class="dataset">

  <article class="results light_pane">
    <header></header>
    <div class="content">

      <div class="header">
          <h2>Crawling monitoring</h2>        
      </div>
          <table class><tr><td>
          <p /><br />
          Hosting institution in node:<br/>
          <@s.select name="hostingNodesList" value="'${(member!).endorsingNodeKey!}'" list="nodes" 
            listKey="key" listValue="title" headerKey="" headerValue="Choose a node" cssClass="selectBox" label="ddd" labelposition="top"/>
          <br />
          Hosting institution:<br/>
          <@s.select name="hostingPublisherList" value="'${(member!).endorsingNodeKey!}'"
            headerKey="" headerValue="Choose a publisher" cssClass="selectBox"/>          
          <br />    
          Owning institution in node:<br/>         
          <@s.select name="owningNodesList" value="'${(member!).endorsingNodeKey!}'" list="nodes" 
            listKey="key" listValue="title" headerKey="" headerValue="Choose a node" cssClass="selectBox"/>
          <br />
          Owning institution:<br/>
          <@s.select name="owningPublisherList" value="'${(member!).endorsingNodeKey!}'"
            headerKey="" headerValue="Choose a publisher" cssClass="selectBox"/>     
          </td><td>
          <#list occurrenceEndpoints as endpoint>
            <@s.checkbox label="name" name="name" value="name"/> ${endpoint}<br/>
          </#list> 
          </td></tr></table>
          <table id="table_id" class="display">
            <thead>
              <tr>
                <th>Data publisher</th>
                <th>Dataset</th>
                <th>Target count</th>
                <th>Max harvested</th>
                <th>Harvested</th>
                <th>Dropped</th>
                <th>Start</th>
                <th>Last</th>
                <th>Next</th>
              </tr>
            </thead>
            <tbody>
              <#list metrics as ds>
                <tr>
                  <td><a href="${baseUrl}/organization/${ds.dataset.owningOrganizationKey!}">${ds.owningOrganizationName!}</a></td>
                  <td><a href="${baseUrl}/dataset/${ds.dataset.key!}">${ds.dataset.title!}</a></td>
                  <td>0</td>
                  <td>${(ds.metrics.harvestedRecords)!"--"}</td>
                  <td>${(ds.metrics.harvestedRecords)!"--"}</td>
                  <td>${(ds.metrics.droppedRecords)!"--"}</td>
                  <td>${(ds.metrics.harvestingStart)!"--"}</td>
                  <td>${(ds.metrics.harvestingFinished)!"--"}</td>
                  <td>${(ds.metrics.harvestingFinished)!"--"}</td>
                </tr>
              </#list>
            </tbody>
          </table>  
    </div>
    <footer></footer>
  </article>

</body>
</html>
