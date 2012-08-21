<#import "/WEB-INF/macros/common.ftl" as common>
<html>
<head>
  <title>Occurrence detail - GBIF</title>
  <meta name="menu" content="occurrences"/>
</head>
<body class="stats">

<#assign tab="info"/>
<#include "/WEB-INF/pages/occurrence/infoband.ftl">



<div class="back">
  <div class="content">
    <a href="<@s.url value='/occurrence/${id?c}'/>" title="Back to regular view">Back to regular view</a>
  </div>
</div>

<@common.notice title="Occurrence verbatim data">
  <p>This listing shows the orignal information as received by GBIF from the data publisher, without further
    interpretation processing. Alternatively you can also
    <a href="<@s.url value='/occurrence/${id?c}/raw'/>">view the raw XML</a>.
  </p>
</@common.notice>


<@common.article id="record_level" title="Record level" class="raw odd">
<div class="left">
  <div class="row first odd">
    <h4>Type</h4>

    <div class="value">
      Value
    </div>
  </div>

  <div class="row even">
    <h4>Modified</h4>

    <div class="value">
      Value
    </div>
  </div>

  <div class="row odd">
    <h4>Language</h4>

    <div class="value">
      Value
    </div>
  </div>

  <div class="row even last">
    <h4>Rights</h4>

    <div class="value">
      Value
    </div>
  </div>

</div>
</@common.article>

<@common.article id="occurrence" title="Occurrence" class="raw odd">
<div class="left">
  <div class="row first odd">
    <h4>Type</h4>

    <div class="value">
      Value
    </div>
  </div>

  <div class="row even">
    <h4>Modified</h4>

    <div class="value">
      Value
    </div>
  </div>

  <div class="row odd">
    <h4>Language</h4>

    <div class="value">
      Value
    </div>
  </div>

  <div class="row even last">
    <h4>Rights</h4>

    <div class="value">
      Value
    </div>
  </div>

</div>
</@common.article>


</body>
</html>
