<html>
<head>
  <title>${dataset.title} - Geographic coverages</title>
  <style>
    table.metrics {
      width: 100%;
      margin: 0 0 0 2px;
      border: 1px solid #e0e0e0;
    }
    
    table.metrics td,  
    table.metrics th {
      padding: 5px;
      font-size: 15px;
      color: #666;
      text-align: left;
    }

    table.metrics th {
      border-bottom: 1px solid #e0e0e0;
      text-align: center;
    }

    table.metrics tr.total {
      border-top: 1px solid #e0e0e0;
    }

    table.metrics tr:hover {
      background-color: #e0e0e0;
      cursor: pointer;
    }

    table.metrics td.nonGeo {
      text-align: right;
    }
    
    table.metrics div {
      display: inline-block;
    }
  </style>
  <content tag="extra_scripts">
    <script>
      $(window).ready(function() {
        <#-- 
          Bind the divs to load on AJAX calls.
          For performance, we first determine which kingdoms have content, then load them all
        -->
        $('table.metrics td.total div').each(function() {
          refresh($(this), true);
        });
        
        function refresh(target, nest) {
          var $target = $(target);
          
          // always add the datasetKey to the cube address
          var address = "?datasetKey=${dataset.key}";
          
					if ($target.closest("tr").attr("data-kingdom") != null) {
					  address = address + "&nubKey=" + $target.closest("tr").attr("data-kingdom");
					  
					}
					
					if ($target.closest("td").attr("data-bor") != null) {
					  address = address + "&basisOfRecord=" + $target.closest("td").attr("data-bor");
					}
					
          if (target.hasClass("geo")) {
            address = address + "&georeferenced=true";
          }
          $.getJSON(cfg.wsMetrics + 'occurrence/count' + address + '&callback=?', function (data) {
            $(target).html(data);
            if (nest && data!=0) {
              // load the rest of the row
              $target.closest('tr').find('div').each(function() {
                refresh($(this), false);
              });
            } else if (nest) {
              // set the rest of the row to 0
              $target.closest('tr').find('div').each(function() {
                $(this).html("0");
              });
            }
          });
        }
        
        //.ajax(cfg.wsMetrics + 'occurrence/count?callback=tim');
      });
    </script>
  </content>  
</head>
<body>
  <#-- Set up the tabs to highlight the info tab, and includ a backlink -->
  <#assign tab="stats"/>
  <#include "/WEB-INF/pages/dataset/inc/infoband.ftl">
  <article class="results">
    <header></header>
    <div class="content">
      <div class="header">
        <div class="left">
          <h2>Dataset metrics</h2>
        </div>
      </div>
      <div class="fullwidth">
        <p>
          <em>Note</em>: The numbers in brackets represent records that are georeferenced (i.e. with coordinates).
        </p>
				<p>      
					<table class='metrics'>
						<thead>
							<tr>
								<th width="10%"/>
								<th colspan="2" width="9%">Specimen</th>
								<th colspan="2" width="9%">Observation</th>
								<th colspan="2" width="9%">Fossil</th>
								<th colspan="2" width="9%">Living</th>
								<th colspan="2" width="9%" class='total'>Total</th>
							</tr>
						</thead>
						<tbody>
							<tr data-kingdom="1">
								<td width="10%">Animalia</td>
								<td class="nonGeo" width="9%" data-bor="PRESERVED_SPECIMEN"><div>-</div></td>
								<td width="9%" data-bor="PRESERVED_SPECIMEN">(<div class="geo">-</div>)</td>
								<td class="nonGeo" width="9%" data-bor="OBSERVATION"><div>-</div></td>
								<td width="9%" data-bor="OBSERVATION">(<div class="geo">-</div>)</td>
								<td class="nonGeo" width="9%" data-bor="FOSSIL_SPECIMEN"><div>-</div></td>
								<td width="9%" data-bor="FOSSIL_SPECIMEN">(<div class="geo">-</div>)</td>
								<td class="nonGeo" width="9%" data-bor="LIVING_SPECIMEN"><div>-</div></td>
								<td width="9%" data-bor="LIVING_SPECIMEN">(<div class="geo">-</div>)</td>
								<td class="nonGeo total" width="9%"><div>-</div></td>
								<td width="9%" class='totalgeo'>(<div class="geo">-</div>)</td>
							</tr>
							<tr data-kingdom="2">
								<td>Archaea</td>
								<td class="nonGeo" width="9%" data-bor="PRESERVED_SPECIMEN"><div>-</div></td>
								<td width="9%" data-bor="PRESERVED_SPECIMEN">(<div class="geo">-</div>)</td>
								<td class="nonGeo" width="9%" data-bor="OBSERVATION"><div>-</div></td>
								<td width="9%" data-bor="OBSERVATION">(<div class="geo">-</div>)</td>
								<td class="nonGeo" width="9%" data-bor="FOSSIL_SPECIMEN"><div>-</div></td>
								<td width="9%" data-bor="FOSSIL_SPECIMEN">(<div class="geo">-</div>)</td>
								<td class="nonGeo" width="9%" data-bor="LIVING_SPECIMEN"><div>-</div></td>
								<td width="9%" data-bor="LIVING_SPECIMEN">(<div class="geo">-</div>)</td>
								<td class="nonGeo total" width="9%"><div>-</div></td>
								<td width="9%" class='totalgeo'>(<div class="geo">-</div>)</td>
							</tr>
							<tr data-kingdom="3">
								<td>Bacteria</td>
								<td class="nonGeo" width="9%" data-bor="PRESERVED_SPECIMEN"><div>-</div></td>
								<td width="9%" data-bor="PRESERVED_SPECIMEN">(<div class="geo">-</div>)</td>
								<td class="nonGeo" width="9%" data-bor="OBSERVATION"><div>-</div></td>
								<td width="9%" data-bor="OBSERVATION">(<div class="geo">-</div>)</td>
								<td class="nonGeo" width="9%" data-bor="FOSSIL_SPECIMEN"><div>-</div></td>
								<td width="9%" data-bor="FOSSIL_SPECIMEN">(<div class="geo">-</div>)</td>
								<td class="nonGeo" width="9%" data-bor="LIVING_SPECIMEN"><div>-</div></td>
								<td width="9%" data-bor="LIVING_SPECIMEN">(<div class="geo">-</div>)</td>
								<td class="nonGeo total" width="9%"><div>-</div></td>
								<td width="9%" class='totalgeo'>(<div class="geo">-</div>)</td>
							</tr>
							<tr data-kingdom="4">
								<td>Chromista</td>
								<td class="nonGeo" width="9%" data-bor="PRESERVED_SPECIMEN"><div>-</div></td>
								<td width="9%" data-bor="PRESERVED_SPECIMEN">(<div class="geo">-</div>)</td>
								<td class="nonGeo" width="9%" data-bor="OBSERVATION"><div>-</div></td>
								<td width="9%" data-bor="OBSERVATION">(<div class="geo">-</div>)</td>
								<td class="nonGeo" width="9%" data-bor="FOSSIL_SPECIMEN"><div>-</div></td>
								<td width="9%" data-bor="FOSSIL_SPECIMEN">(<div class="geo">-</div>)</td>
								<td class="nonGeo" width="9%" data-bor="LIVING_SPECIMEN"><div>-</div></td>
								<td width="9%" data-bor="LIVING_SPECIMEN">(<div class="geo">-</div>)</td>
								<td class="nonGeo total" width="9%"><div>-</div></td>
								<td width="9%" class='totalgeo'>(<div class="geo">-</div>)</td>
							</tr>
							<tr data-kingdom="5">
								<td>Fungi</td>
								<td class="nonGeo" width="9%" data-bor="PRESERVED_SPECIMEN"><div>-</div></td>
								<td width="9%" data-bor="PRESERVED_SPECIMEN">(<div class="geo">-</div>)</td>
								<td class="nonGeo" width="9%" data-bor="OBSERVATION"><div>-</div></td>
								<td width="9%" data-bor="OBSERVATION">(<div class="geo">-</div>)</td>
								<td class="nonGeo" width="9%" data-bor="FOSSIL_SPECIMEN"><div>-</div></td>
								<td width="9%" data-bor="FOSSIL_SPECIMEN">(<div class="geo">-</div>)</td>
								<td class="nonGeo" width="9%" data-bor="LIVING_SPECIMEN"><div>-</div></td>
								<td width="9%" data-bor="LIVING_SPECIMEN">(<div class="geo">-</div>)</td>
								<td class="nonGeo total" width="9%"><div>-</div></td>
								<td width="9%" class='totalgeo'>(<div class="geo">-</div>)</td>
							</tr>
							<tr data-kingdom="6">
								<td>Plantae</td>
								<td class="nonGeo" width="9%" data-bor="PRESERVED_SPECIMEN"><div>-</div></td>
								<td width="9%" data-bor="PRESERVED_SPECIMEN">(<div class="geo">-</div>)</td>
								<td class="nonGeo" width="9%" data-bor="OBSERVATION"><div>-</div></td>
								<td width="9%" data-bor="OBSERVATION">(<div class="geo">-</div>)</td>
								<td class="nonGeo" width="9%" data-bor="FOSSIL_SPECIMEN"><div>-</div></td>
								<td width="9%" data-bor="FOSSIL_SPECIMEN">(<div class="geo">-</div>)</td>
								<td class="nonGeo" width="9%" data-bor="LIVING_SPECIMEN"><div>-</div></td>
								<td width="9%" data-bor="LIVING_SPECIMEN">(<div class="geo">-</div>)</td>
								<td class="nonGeo total" width="9%"><div>-</div></td>
								<td width="9%" class='totalgeo'>(<div class="geo">-</div>)</td>
							</tr>
							<tr data-kingdom="7">
								<td>Protozoa</td>
								<td class="nonGeo" width="9%" data-bor="PRESERVED_SPECIMEN"><div>-</div></td>
								<td width="9%" data-bor="PRESERVED_SPECIMEN">(<div class="geo">-</div>)</td>
								<td class="nonGeo" width="9%" data-bor="OBSERVATION"><div>-</div></td>
								<td width="9%" data-bor="OBSERVATION">(<div class="geo">-</div>)</td>
								<td class="nonGeo" width="9%" data-bor="FOSSIL_SPECIMEN"><div>-</div></td>
								<td width="9%" data-bor="FOSSIL_SPECIMEN">(<div class="geo">-</div>)</td>
								<td class="nonGeo" width="9%" data-bor="LIVING_SPECIMEN"><div>-</div></td>
								<td width="9%" data-bor="LIVING_SPECIMEN">(<div class="geo">-</div>)</td>
								<td class="nonGeo total" width="9%"><div>-</div></td>
								<td width="9%" class='totalgeo'>(<div class="geo">-</div>)</td>
							</tr>
							<tr data-kingdom="8">
								<td>Viruses</td>
								<td class="nonGeo" width="9%" data-bor="PRESERVED_SPECIMEN"><div>-</div></td>
								<td width="9%" data-bor="PRESERVED_SPECIMEN">(<div class="geo">-</div>)</td>
								<td class="nonGeo" width="9%" data-bor="OBSERVATION"><div>-</div></td>
								<td width="9%" data-bor="OBSERVATION">(<div class="geo">-</div>)</td>
								<td class="nonGeo" width="9%" data-bor="FOSSIL_SPECIMEN"><div>-</div></td>
								<td width="9%" data-bor="FOSSIL_SPECIMEN">(<div class="geo">-</div>)</td>
								<td class="nonGeo" width="9%" data-bor="LIVING_SPECIMEN"><div>-</div></td>
								<td width="9%" data-bor="LIVING_SPECIMEN">(<div class="geo">-</div>)</td>
								<td class="nonGeo total" width="9%"><div>-</div></td>
								<td width="9%" class='totalgeo'>(<div class="geo">-</div>)</td>
							</tr>
							<tr data-kingdom="0">
								<td>Unknown</td>
								<td class="nonGeo" width="9%" data-bor="PRESERVED_SPECIMEN"><div>-</div></td>
								<td width="9%" data-bor="PRESERVED_SPECIMEN">(<div class="geo">-</div>)</td>
								<td class="nonGeo" width="9%" data-bor="OBSERVATION"><div>-</div></td>
								<td width="9%" data-bor="OBSERVATION">(<div class="geo">-</div>)</td>
								<td class="nonGeo" width="9%" data-bor="FOSSIL_SPECIMEN"><div>-</div></td>
								<td width="9%" data-bor="FOSSIL_SPECIMEN">(<div class="geo">-</div>)</td>
								<td class="nonGeo" width="9%" data-bor="LIVING_SPECIMEN"><div>-</div></td>
								<td width="9%" data-bor="LIVING_SPECIMEN">(<div class="geo">-</div>)</td>
								<td class="nonGeo total" width="9%"><div>-</div></td>
								<td width="9%" class='totalgeo'>(<div class="geo">-</div>)</td>
							</tr>          
							<tr class='total'>
								<td>Total</td>
								<td class="nonGeo" width="9%" data-bor="PRESERVED_SPECIMEN"><div>-</div></td>
								<td width="9%" data-bor="PRESERVED_SPECIMEN">(<div class="geo">-</div>)</td>
								<td class="nonGeo" width="9%" data-bor="OBSERVATION"><div>-</div></td>
								<td width="9%" data-bor="OBSERVATION">(<div class="geo">-</div>)</td>
								<td class="nonGeo" width="9%" data-bor="FOSSIL_SPECIMEN"><div>-</div></td>
								<td width="9%" data-bor="FOSSIL_SPECIMEN">(<div class="geo">-</div>)</td>
								<td class="nonGeo" width="9%" data-bor="LIVING_SPECIMEN"><div>-</div></td>
								<td width="9%" data-bor="LIVING_SPECIMEN">(<div class="geo">-</div>)</td>
								<td class="nonGeo total" width="9%"><div>-</div></td>
								<td width="9%" class='totalgeo'>(<div class="geo">-</div>)</td>
							</tr>
						</tbody>
					</table>
				</p>
      </div>
    </div>
    <footer></footer>
  </article>
</body>
</html>