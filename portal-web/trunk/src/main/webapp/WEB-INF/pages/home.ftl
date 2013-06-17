<html>
  <head>
    <title>GBIF Data Portal - Home</title>
    <script type="text/javascript">
      <#-- EXECUTED ON WINDOWS LOAD -->
      $(function() {
          $.getJSON(cfg.wsMetrics + 'occurrence/count?callback=?', function (data) {
            $("#countOccurrences").html(data);
          });
          $.getJSON(cfg.wsClbSearch + '?dataset_key=d7dddbf4-2cf0-4f39-9b2a-bb099caae36c&limit=1&rank=species&status=accepted&callback=?', function (data) {
            $("#countSpecies").html(data.count);
          });
          $.getJSON(cfg.wsRegSearch + '?limit=1&callback=?', function (data) {
            $("#countDatasets").html(data.count);
          });
        });
    </script>
      <style type="text/css">
          header #beta {
            left: 200px;
            top: 10px;
          }
      </style>
  </head>

  <content tag="logo_header">
    <div id="logo">
      <a href="<@s.url value='/'/>" class="logo"></a>
    </div>

    <div class="info">
      <h1>Global Biodiversity Information Facility</h1>
      <h2>Free and open access to biodiversity data</h2>

      <ul class="counters">
        <li><strong id="countOccurrences">?</strong> Occurrences</li>
        <li><strong id="countSpecies">?</strong> Species</li>
        <li><strong id="countDatasets">?</strong> Datasets</li>
        <li><strong id="countPublishers">?</strong> Data publishers</li>
      </ul>
    </div>
  </content>

  <body class="home">

    <div class="container">

    <article class="search">

    <header>
    </header>

    <div class="content">

      <ul>
        <li>
        <h3>Enables biodiversity data sharing and re-use</h3>
        <ul>
          <li><a href="#">Why publish your data?</a></li>
          <li><a href="#">How to publish your data</a></li>
          <li><a href="#">Data from citizen scientists</a></li>
        </ul>
        </li>

        <li>
        <h3>Supports biodiversity research</h3>
        <ul>
          <li><a href="#">Why publish your data?</a></li>
          <li><a href="#">How to publish your data</a></li>
          <li><a href="#">Data from citizen scientists</a></li>
        </ul>
        </li>

        <li>
        <h3>Collaborates as a global community</h3>
        <ul>
          <li><a href="#">Why publish your data?</a></li>
          <li><a href="#">How to publish your data</a></li>
          <li><a href="#">Data from citizen scientists</a></li>
        </ul>
        </li>

      </ul>
    </div>
    <div class="footer">

      <form action="/member/search">
        <span class="input_text">
          <input type="text" name="q" placeholder="Search GBIF for species, datasets or countries" class="focus">
        </span>
        <button type="submit" class="search_button"><span>Search</span></button>
      </form>

        <div class="footer">
           <a href="#">Birds</a> &middot;
           <a href="#">Butterflies</a> &middot;
           <a href="#">Lizards</a> &middot;
           <a href="#">Reptiles</a> &middot;
           <a href="#">Fishes</a> &middot;
           <a href="#">Mammals</a> &middot;
           <a href="#">Insects</a>
         </div>
    </div>
    <footer></footer>
    </article>

</div>

</body>
</html>
