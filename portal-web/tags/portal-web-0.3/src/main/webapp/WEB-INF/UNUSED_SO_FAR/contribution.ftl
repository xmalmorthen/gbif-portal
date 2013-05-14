<content tag="extra_scripts">
  <script type="text/javascript" charset="utf-8">
    $(function() {
      $("#dataset-graph1").addGraph(generateRandomValues(50));
      $("#dataset-graph2").addGraph(generateRandomValues(50));
      $("#dataset-graph3").addGraph(generateRandomValues(50));
      $("#dataset-graph4").addGraph(generateRandomValues(50));
    });
  </script>
</content>

<article>
  <header></header>
  <div class="content placeholder_temp">

    <div class="header">
      <div class="left"><h2>Contribution to GBIF</h2></div>
    </div>

    <div class="left">
      <div class="minigraphs">
        <div id="dataset-graph1" class="minigraph">
          <h3><a href="<@s.url value='/dataset/search?owning_org=${id}'/>">45<span>Datasets</span></a></h3>
          <div class="percentage down">21% last year</div>
          <div class="start">1998</div>
          <div class="end">2011</div>
          <div class="lt"></div>
          <div class="rt"></div>
        </div>
        <div id="dataset-graph2" class="minigraph last">
          <h3><a href="<@s.url value='/dataset/search?type=CHECKLIST&owning_org=${id}'/>">25<span>Checklists</span></a></h3>
          <div class="percentage up">21% last year</div>
          <div class="start">1998</div>
          <div class="end">2011</div>
          <div class="lt"></div>
          <div class="rt"></div>
        </div>
      </div>
      <div class="minigraphs last">
        <div id="dataset-graph3" class="minigraph">
          <h3>123,599<span>occurrences</span></h3>

          <div class="percentage down">21% last year</div>
          <div class="start">1998</div>
          <div class="end">2011</div>
          <div class="lt"></div>
          <div class="rt"></div>
        </div>
        <div id="dataset-graph4" class="minigraph last">
          <h3>30,123<span>species</span></h3>

          <div class="percentage up">21% last year</div>
          <div class="start">1998</div>
          <div class="end">2011</div>
          <div class="lt"></div>
          <div class="rt"></div>
        </div>
      </div>
    </div>

    <div class="right">
      <h3>Top countries covered</h3>
      <ul>
        <li><a href="<@s.url value='/country/42'/>" title="Poland">Poland</a></li>
        <li><a href="<@s.url value='/country/42'/>" title="Ecuador">Ecuador</a></li>
        <li><a href="<@s.url value='/country/42'/>" title="Namibia">Namibia</a></li>
      </ul>

      <h3>Available reports</h3>
      <ul>
        <li class="download"><a href="#" title="Museum Standards">Museum Standards</a></li>
        <li class="download"><a href="#" title="Academy of Natural Sciences">Academy of Natural Sciences</a></li>
      </ul>
    </div>

  </div>
  <footer></footer>
</article>
