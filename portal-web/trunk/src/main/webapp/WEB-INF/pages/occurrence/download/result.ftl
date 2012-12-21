<html>
<head>
  <title>Occurrences - GBIF</title>

</head>
<body class="dataset">

  <article class="results light_pane">
    <header></header>
    <div class="content">
		
      <div class="header">
        <div class="left">
          <h2>Download Started</h2>
        </div>
        <div class="right">
        </div>
      </div>
        <div class="left">
          <div>
              <p>Your download is <a href="http://c1n1.gbif.org:11000/oozie/">running</a> (${jobId})</p>
              <p>A notification email with a link to download the results will be sent to the following addresses once ready:
                <ul>
                  <#list emails as email>
                    <li>${email}</li>
                  </#list>
                </ul>
              </p>
          </div>
        </div>
        <div class="right">
        </div>
    </div>
    <footer></footer>
  </article>

</body>
</html>
