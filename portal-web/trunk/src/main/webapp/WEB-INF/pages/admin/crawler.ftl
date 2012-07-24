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
  <meta name="menu" content="occurrences"/>
</head>
<body class="dataset">

  <article class="results light_pane">
    <header></header>
    <div class="content">

      <div class="header">
        <div class="left">
          <h2>Crawling monitoring</h2>        
        </div>
        <div class="right">
          <h3>Filters</h3>
        </div>
      </div>
        <div class="left">
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
              <tr>
                <td>BCRC</td>
                <td>Archaea Collection in BCRC</td>
                <td>340,000</td>
                <td>340,000</td>
                <td>340,000</td>
                <td>0</td>
                <td>2012-7-17</td>
                <td>2012-7-17</td>
                <td>2012-7-17</td>
              </tr>
              <tr>
                <td>Association for Nature Wolf</td>
                <td>Bats of Poland</td>
                <td>450,000</td>
                <td>455,000</td>
                <td>447,000</td>
                <td>3000 <a href="#">[details]</a></td>
                <td>2012-7-17</td>
                <td>2012-7-17</td>
                <td>2012-7-17</td>
              </tr>
              <tr>
                <td>National Biodiversity Centre</td>
                <td>Bees of Ireland</td>
                <td>3,120</td>
                <td>3,100</td>
                <td>3,100</td>
                <td>20 <a href="#">[details]</a></td>
                <td>2012-7-17</td>
                <td>2012-7-17</td>
                <td>2012-7-17</td>
              </tr>
              <tr>
                <td>Museum of Natural History</td>
                <td>Collection of Coleoptera</td>
                <td>N/A</td>
                <td>5,500</td>
                <td>5,000</td>
                <td>250 <a href="#">[details]</a></td>
                <td>2012-7-17</td>
                <td>2012-7-17</td>
                <td>2012-7-17</td>
              </tr>
              <tr>
                <td>University of Warsaw</td>
                <td>Herbarium BSG Vascular Plants</td>
                <td>N/A</td>
                <td>10,300</td>
                <td>10,100</td>
                <td>150 <a href="#">[details]</a></td>
                <td>2012-7-17</td>
                <td>2012-7-17</td>
                <td>2012-7-17</td>
              </tr>
              <tr>
                <td>Museum of Natural History</td>
                <td>Collection of Coleoptera</td>
                <td>N/A</td>
                <td>5,500</td>
                <td>5,000</td>
                <td>250 <a href="#">[details]</a></td>
                <td>2012-7-17</td>
                <td>2012-7-17</td>
                <td>2012-7-17</td>
              </tr>
              <tr>
                <td>University of Warsaw</td>
                <td>Herbarium BSG Vascular Plants</td>
                <td>N/A</td>
                <td>10,300</td>
                <td>10,100</td>
                <td>150 <a href="#">[details]</a></td>
                <td>2012-7-17</td>
                <td>2012-7-17</td>
                <td>2012-7-17</td>
              </tr>
              <tr>
                <td>Museum of Natural History</td>
                <td>Collection of Coleoptera</td>
                <td>N/A</td>
                <td>5,500</td>
                <td>5,000</td>
                <td>250 <a href="#">[details]</a></td>
                <td>2012-7-17</td>
                <td>2012-7-17</td>
                <td>2012-7-17</td>
              </tr>
              <tr>
                <td>University of Warsaw</td>
                <td>Herbarium BSG Vascular Plants</td>
                <td>N/A</td>
                <td>10,300</td>
                <td>10,100</td>
                <td>150 <a href="#">[details]</a></td>
                <td>2012-7-17</td>
                <td>2012-7-17</td>
                <td>2012-7-17</td>
              </tr>
              <tr>
                <td>Museum of Natural History</td>
                <td>Collection of Coleoptera</td>
                <td>N/A</td>
                <td>5,500</td>
                <td>5,000</td>
                <td>250 <a href="#">[details]</a></td>
                <td>2012-7-17</td>
                <td>2012-7-17</td>
                <td>2012-7-17</td>
              </tr>
              <tr>
                <td>University of Warsaw</td>
                <td>Herbarium BSG Vascular Plants</td>
                <td>N/A</td>
                <td>10,300</td>
                <td>10,100</td>
                <td>150 <a href="#">[details]</a></td>
                <td>2012-7-17</td>
                <td>2012-7-17</td>
                <td>2012-7-17</td>
              </tr>
            </tbody>
          </table>  
        </div>
        <div class="right">
          Hosting institution in node:
          <@s.select name="hostingNodesList" value="'${(member!).endorsingNodeKey!}'" list="nodes" 
            listKey="key" listValue="title" headerKey="" headerValue="Choose a node" cssClass="selectBox"/>
          <p /><br />
          Hosting institution:
          <@s.select name="hostingPublisherList" value="'${(member!).endorsingNodeKey!}'"
            headerKey="" headerValue="Choose a publisher" cssClass="selectBox"/>          
          <p /><br />    
          Owning institution in node:          
          <@s.select name="owningNodesList" value="'${(member!).endorsingNodeKey!}'" list="nodes" 
            listKey="key" listValue="title" headerKey="" headerValue="Choose a node" cssClass="selectBox"/>
          <p /><br />
          Owning institution:
          <@s.select name="owningPublisherList" value="'${(member!).endorsingNodeKey!}'"
            headerKey="" headerValue="Choose a publisher" cssClass="selectBox"/>     
          <p /><br />
          <#list occurrenceEndpoints as endpoint>
            <@s.checkbox label="name" name="name" value="name"/> ${endpoint}<br/>
          </#list>
        </div>
    </div>
    <footer></footer>
  </article>

</body>
</html>
