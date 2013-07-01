<#import "/WEB-INF/macros/common.ftl" as common>
<html>
<head>
  <title>Occurrence Download - GBIF</title>

</head>
<body class="search">

<content tag="infoband">
    <h1>Occurrence Download</h1>
</content>

<@common.article id="started" title="Download Started">
    <div>
        <!-- cfg.wsOccDownload is not public, but needed for authentication. Therefore wsOccDownloadForPublicLink was created which is public -->
        <p>Your <a href="${cfg.wsOccDownloadForPublicLink}occurrence/download/${jobId}">download #${jobId}</a> is running</p>
        <p>Please expect 10 to 15 minutes for the download to complete. <br/>
           A notification email with a link to download the results will be sent to the following addresses once ready:
          <ul>
            <#list emails as email>
              <li>${email}</li>
            </#list>
          </ul>
        </p>
        <p>In your user home you can also see the status and link to <a href="<@s.url value='/user/downloads'/>">all your requested downloads</a>.</p>
    </div>
</@common.article>

</body>
</html>
