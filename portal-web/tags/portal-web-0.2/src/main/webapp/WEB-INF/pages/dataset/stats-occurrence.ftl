<html>
<head>
  <title>${dataset.title} - Metrics</title>
  
  <link rel="stylesheet" href="<@s.url value='/css/bootstrap-tables.css'/>" type="text/css" media="all"/>
  
  <style>
    table.metrics div {
      display: inline-block;
    }
    table.metrics {
      color: #666;
    }

    table.metrics .total,
    table.metrics tr.total td {
      font-weight: bold !important;
      background-color: #FFFFDF !important;
    }

    table.metrics td.title {
      font-weight: bold !important;
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

  <#macro kingdomRow kingdom usageId="" class="">
    <tr <#if usageId?has_content>data-kingdom="${usageId}"</#if> <#if class?has_content>class="${class}"</#if> >
      <td width="10%" class="title">${kingdom}</td>
      <#list ["PRESERVED_SPECIMEN", "OBSERVATION", "FOSSIL_SPECIMEN", "LIVING_SPECIMEN"] as bor>
        <td class="nonGeo" width="9%" data-bor="${bor}"><div>-</div></td>
        <td width="9%" data-bor="${bor}">(<div class="geo">-</div>)</td>
      </#list>
      <td class="nonGeo total" width="9%" class='total'><div>-</div></td>
      <td width="9%" class='totalgeo total'>(<div class="geo">-</div>)</td>
    </tr>
  </#macro>

  <@common.article id="metrics" title="Dataset metrics">
      <div class="fullwidth">
        <p>
          <table class='metrics table table-bordered table-striped'>
						<thead>
							<tr>
								<th width="10%"/>
								<th colspan="2" width="9%">Specimen</th>
								<th colspan="2" width="9%">Observation</th>
								<th colspan="2" width="9%">Fossil</th>
								<th colspan="2" width="9%">Living</th>
								<th colspan="2" width="9%" class='total'>Total</th>
							</tr>
							<tr>
								<th width="10%"/>
								<th>Records</th>
								<th>Georef.</th>
								<th>Records</th>
								<th>Georef.</th>
								<th>Records</th>
								<th>Georef.</th>
								<th>Records</th>
								<th>Georef.</th>
								<th class='total'>Records</th>
								<th class='total'>Georef.</th>
							</tr>
						</thead>
						<tbody>
            <#list ["Animalia", "Archaea", "Bacteria", "Chromista", "Fungi", "Plantae", "Protozoa", "Viruses"] as k>
              <@kingdomRow kingdom=k usageId=k_index+1 />
            </#list>
            <@kingdomRow kingdom="Unknown" usageId=0 />
            <@kingdomRow kingdom="Total" class="total"/>
						</tbody>
					</table>
				</p>
        <p>
          <em>Note</em>: The numbers in brackets represent records that are georeferenced (i.e. with coordinates).
        </p>
      </div>
</@common.article>

</body>
</html>
