<html>
<head>
  <title>Occurrence Download - GBIF</title>

</head>
<body class="dataset">

    <content tag="infoband">
        <h2>Occurrence Download</h2>
    </content>

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
              <p>Your <a href="${cfg.wsOccDownload}${jobId}">download #${jobId}</a> is running</p>
              <p>A notification email with a link to download the results will be sent to the following addresses once ready:
                <ul>
                  <#list emails as email>
                    <li>${email}</li>
                  </#list>
                </ul>
              </p>
              <p>During test phase you can also check our <a href="http://c1n1.gbif.org:11000/oozie/">oozie jobs directly</a></p>
          </div>
        </div>
        <div class="right">
        </div>
    </div>
    <footer></footer>
  </article>

</body>
</html>
