<html>
<head>
  <title>${dataset.title} - Metrics</title>
  <content tag="extra_scripts">
    <script type="text/javascript" charset="utf-8">
        $(function() {
          if ($("#map").length) {
            var latlng = new google.maps.LatLng(-34.397, 150.644);
            var myOptions = { zoom: 5, center: latlng, disableDefaultUI: true, mapTypeId: google.maps.MapTypeId.ROADMAP };
            var map = new google.maps.Map(document.getElementById("map"), myOptions);
          }

          $("#dataset-graph1").addGraph(generateRandomValues(50), {width:275, height:200});
          $("#dataset-graph2").addGraph(generateRandomValues(50), {width:275, height:200});
          $("#dataset-graph3").addGraph(generateRandomValues(50), {width:275, height:200});

          $("#pieNub").bindPie(36.5, Math.floor(Math.random() * 100));
          $("#pieCol").bindPie(36.5, Math.floor(Math.random() * 100));

          $("#pie4").bindMultiPie(36.5, [12,50]);
          $("#pie5").bindMultiPie(36.5, [32,45,77]);
          $("#pie6").bindMultiPie(36.5, [12,18,45,62]);

          $("#pie4legend").addMultiLegend(3);
          $("#pie5legend").addMultiLegend(4);
          $("#pie6legend").addMultiLegend(5);

          $(".horizontal_graph").bindGreyBars(400);

        });
    </script>
  </content>
</head>
<body>
  <#-- Set up the tabs to highlight the info tab, and includ a backlink -->
  <#assign tab="stats"/>
  <#include "/WEB-INF/pages/dataset/inc/infoband.ftl">

  <@common.article id="metrics" title="Vernacular Names" titleRight="Name Usages">
      <div class="left">
        <#if metrics.countNamesByLanguage?has_content>
          <#assign langs = metrics.countNamesByLanguage?keys?sort>
          <div class="col">
            <ul>
            <#list langs as l>
              <#if l_index%2==0>
                <#if "UNKNOWN"==l>
                  <li>Unknown <span class="number">${metrics.countNamesByLanguage(l)!0}</span></li>
                <#else>
                  <li>${l.getTitleEnglish()} [${l.getIso2LetterCode()}] <span class="number">${metrics.countNamesByLanguage(l)!0}</span></li>
                </#if>
              </#if>
            </#list>
            </ul>
          </div>

          <div class="col">
            <ul>
            <#list langs as l>
              <#if l_index%2==1>
                <#if "UNKNOWN"==l>
                  <li>Unknown <span class="number">${metrics.countNamesByLanguage(l)!0}</span></li>
                <#else>
                  <li>${l.getTitleEnglish()} [${l.getIso2LetterCode()}] <span class="number">${metrics.countNamesByLanguage(l)!0}</span></li>
                </#if>
              </#if>
            </#list>
            </ul>
          </div>
        </#if>
      </div>

      <div class="right">
        <#if metrics.countByKingdom?has_content>
          <h3>By Kingdom</h3>
          <ul>
            <#list kingdoms as k>
              <#if metrics.countByKingdom(k)?has_content>
                <li><@s.text name="enum.kingdom.${k}"/> <span class="number">${metrics.countByKingdom(k)!0}</span></li>
              </#if>
            </#list>
          </ul>
        </#if>

        <#if metrics.countByRank?has_content>
          <h3>By Rank</h3>
          <ul>
            <#list rankEnum as k>
              <#if metrics.countByRank(k)?has_content>
                <li><@s.text name="enum.rank.${k}"/> <span class="number">${metrics.countByRank(k)!0}</span></li>
              </#if>
            </#list>
          </ul>
        </#if>

        <#if metrics.countExtensionRecords?has_content>
          <h3>Associated Data</h3>
          <ul>
            <#list extensions as e>
              <#if ((metrics.getExtensionRecordCount(e)!0)>0)>
                <li><@s.text name="enum.extension.${e}"/> <span class="number">${metrics.getExtensionRecordCount(e)!0}</span></li>
              </#if>
            </#list>
          </ul>
        </#if>
      </div>
  </@common.article>


<@common.article id="overlap" title="Checklist Overlap">
<div class="fullwidth">
    <ul class="pies">
       <li><h3>GBIF BACKBONE</h3>
         <p>Percentage of taxa also found in the <a href="">GBIF Backbone</a>.</p>
         <div id="pieNub"></div>
       </li>
       <li class="last"><h3>CATALOGUE OF LIFE</h3>
           <p>Percentage of taxa also found in the <a href="">Catalogue of Life</a>.</p>
         <div id="pieCol"></div>
       </li>
     </ul>
</div>
</@common.article>

<@common.article id="metrics2" title="Metrics 2">
  <div class="fullwidth">
    <ul class="pies">
      <li><h3>Kingdoms</h3>

        <p>Aim: to balance the data publication on northern and southern hemisphere.</p>

        <div id="pie4" class="multipie"></div>
        <div id="pie4legend" class="pieMultiLegend">
          <ul>
            <li><a href="">Value 1</a></li>
            <li><a href="">Value 2</a></li>
            <li><a href="">Value 3</a></li>
          </ul>
        </div>
      </li>
      <li><h3>Ranks</h3>

        <p>Aim: to balance the coverage in the different taxa.</p>

        <div id="pie5" class="multipie"></div>
        <div id="pie5legend" class="pieMultiLegend">
          <ul>
            <li><a href="">Value 1</a></li>
            <li><a href="">Value 2</a></li>
            <li><a href="">Value 3</a></li>
            <li><a href="">Value 4</a></li>
          </ul>
        </div>
      </li>
      <li class="last"><h3>Extensions</h3>

        <p>Aim: to balance the coverage in the different taxa.</p>

        <div id="pie6" class="multipie"></div>
        <div id="pie6legend" class="pieMultiLegend">
          <ul>
            <li><a href="">Value 1</a></li>
            <li><a href="">Value 2</a></li>
            <li><a href="">Value 3</a></li>
            <li><a href="">Value 4</a></li>
            <li><a href="">Value 5</a></li>
          </ul>
        </div>
      </li>
    </ul>
  </div>
</@common.article>


<@common.article id="vernaculars" title="Vernacular Names as bars">
     <div class="left horizontal_graph">
       <ul class="no_bullets">
         <li><a href="">Aranae</a>

           <div class="grey_bar">100</div>
         </li>
         <li><a href="">Opiriones</a>

           <div class="grey_bar">63</div>
         </li>
         <li><a href="">Parasitiformes</a>

           <div class="grey_bar">19</div>
         </li>
         <li><a href="">Pseudoscornopida</a>

           <div class="grey_bar">15</div>
         </li>
         <li><a href="">Sarcoptiformes</a>

           <div class="grey_bar">9</div>
         </li>
         <li><a href="">Scorpiones</a>

           <div class="grey_bar">6</div>
         </li>
         <li><a href="">Trombidiformes</a>

           <div class="grey_bar">3</div>
         </li>
         <li><a href="">Pseudoscornopida</a>

           <div class="grey_bar">1</div>
         </li>
       </ul>
     </div>
     <div class="right">
       <h3>Additional content</h3>

       <p>Some explanatory or aditional content here.</p>
     </div>
   </div>
</@common.article>


</body>
</html>
