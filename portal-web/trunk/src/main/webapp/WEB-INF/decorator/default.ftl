<!doctype html>
<!-- paulirish.com/2008/conditional-stylesheets-vs-css-hacks-answer-neither/ -->
<!--[if lt IE 7 ]> <html class="no-js ie6" lang="en"> <![endif]-->
<!--[if IE 7 ]>    <html class="no-js ie7" lang="en"> <![endif]-->
<!--[if IE 8 ]>    <html class="no-js ie8" lang="en"> <![endif]-->
<!--[if IE 9 ]>    <html class="ie9"> <![endif]-->
<!--[if (gte IE 9)|!(IE)]><!-->
<!--
    __________  __________   ____        __           ____             __        __
   / ____/ __ )/  _/ ____/  / __ \____ _/ /_____ _   / __ \____  _____/ /_____ _/ /
  / / __/ __  |/ // /_     / / / / __ `/ __/ __ `/  / /_/ / __ \/ ___/ __/ __ `/ /
 / /_/ / /_/ // // __/    / /_/ / /_/ / /_/ /_/ /  / ____/ /_/ / /  / /_/ /_/ / /
 \____/_____/___/_/      /_____/\__,_/\__/\__,_/  /_/    \____/_/   \__/\__,_/_/
-->
<html class="no-js" lang="en" xmlns="http://www.w3.org/1999/xhtml">
<!--<![endif]-->
<head>
  <meta charset="utf-8">
  <script type="text/javascript">
    <#-- dynamic js configuration, so we can use java configs in js -->
    var cfg = new Object();
    cfg.context="<@s.url value="/"/>";
    cfg.currentUrl="${currentUrl!}";
    cfg.serverName= "${cfg.serverName!}";
    cfg.baseUrl = "${baseUrl!}";
    cfg.wsClb="${cfg.wsClb!}";
    cfg.wsClbSearch="${cfg.wsClbSearch!}";
    cfg.wsClbSuggest="${cfg.wsClbSuggest!}";
    cfg.wsReg="${cfg.wsReg!}";
    cfg.wsRegSearch="${cfg.wsRegSearch!}";
    cfg.wsRegSuggest="${cfg.wsRegSuggest!}";
    cfg.wsOcc="${cfg.wsOcc!}";
    cfg.wsMetrics="${cfg.wsMetrics!}";
    cfg.wsOccSearch="${cfg.wsOccSearch!}";
    cfg.tileServerBaseUrl="${cfg.tileServerBaseUrl!}";
    cfg.wsOccCatalogNumberSearch = "${cfg.wsOccCatalogNumberSearch!}";
    cfg.wsOccCollectorNameSearch = "${cfg.wsOccCollectorNameSearch!}";
    cfg.wsOccCollectionCodeSearch = "${cfg.wsOccCollectionCodeSearch!}";
    cfg.wsOccInstitutionCodeSearch = "${cfg.wsOccInstitutionCodeSearch!}";
    cfg.wsImageCache = "${cfg.wsImageCache!}";
  </script>
  <#-- Load bundle properties. The action class can filter out which properties to show according to their key's prefixes -->
  <#if resourceBundleProperties?has_content>
  <script id="resources" type="text/plain">
    <#list resourceBundleProperties?keys as property>
    ${property}=${resourceBundleProperties.get(property)}
    </#list>
  </script>
  </#if>
  <#-- Always force latest IE rendering engine (even in intranet) & Chrome Frame Remove this if you use the .htaccess -->
  <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">

  <title property="dc:title">${title}</title>
  <meta name="description" content="">
  <meta name="author" content="GBIF">
  <#-- Mobile viewport optimized: j.mp/bplateviewport -->
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="shortcut icon" href="<@s.url value='/img/favicon/favicon_32x32.ico'/>">
  <#-- Replace apple-touch-icon.png as per issue http://dev.gbif.org/issues/browse/POR-403 Without a proper path Struts2 configuration exception is thrown-->
  <link rel="apple-touch-icon" href="<@s.url value='/img/favicon/favicon_32x32.ico'/>">
  <#-- CSS: implied media="all" -->
  <link rel="stylesheet" href="<@s.url value='/css/style.css?v=2'/>"/>
  <link rel="stylesheet" href="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.14/themes/base/jquery-ui.css" type="text/css" media="all"/>
  <#-- Uncomment if you are specifically targeting less enabled mobile browsers
  <link rel="stylesheet" media="handheld" href="css/handheld.css?v=2">  -->
  <link rel="stylesheet" type="text/css" media="print" href="<@s.url value='/css/print.css'/>">


  <script src="<@s.url value='/js/vendor/modernizr-1.7.min.js'/>"></script>
  <script type="text/javascript" src="<@s.url value='/js/vendor/jquery-1.7.1.min.js'/>"></script>
  <script type="text/javascript" src="<@s.url value='/js/menu.js'/>"></script>
  <!-- we have issues with firefox, not only IE: http://dev.gbif.org/issues/browse/POR-412 -->
  <script type="text/javascript" src="<@s.url value='/js/vendor/css_browser_selector.js'/>"></script>

  ${head}

</head>
<body class="${page.properties["body.class"]!}">

  <header>

  <!-- top -->
  <div id="top">
    <div class="content">
      <div class="account">
        <#if currentUser??>
        <a href="${cfg.drupal}/user/${currentUser.key}/edit" title='Account'>Hello ${currentUser.firstName!currentUser.userName}</a>
        or
        <a href="${cfg.drupal}/user/logout?destination=${currentUrl}" title='<@s.text name="menu.logout"/>'><@s.text name="menu.logout"/></a>
        <#else>
        <a href="${cfg.drupal}/user/login?destination=${currentUrl}" title='<@s.text name="menu.login"/>'><@s.text name="menu.login"/></a> or
        <a href="${cfg.drupal}/user/register" title='<@s.text name="menu.register"/>'><@s.text name="menu.register"/></a>
        </#if>
      </div>

    <#if page.properties["page.logo_header"]?has_content>
      ${page.properties["page.logo_header"]}
    <#else>
      <div id="logo">
        <a href="${cfg.drupal}/" class="logo"><img src="<@s.url value='/img/header/logo.png'/>" alt="GBIF"/></a>

        <h1><a href="${cfg.drupal}/" title="GBIF.ORG">GBIF.ORG</a></h1>
        <span>Free and open access to biodiversity data</span>
      </div>
    </#if>

    <a href="<@s.url value='/disclaimer'/>">
      <img id="beta" src="http://ecat-dev.gbif.org/img/beta.gif">
    </a>

      <nav>
      <ul>
        <li>
          <a href="#" title="Data">Data</a>
          <div class="data">
            <a href="#"></a>
            <ul>
              <li><a href="<@s.url value='/occurrence'/>"><@s.text name="menu.occurrence"/></a></li>
              <li><a href="<@s.url value='/dataset'/>"><@s.text name="menu.dataset"/></a></li>
              <li><a href="<@s.url value='/species'/>"><@s.text name="menu.species"/></a></li>
              <li><a href="<@s.url value='/country'/>"><@s.text name="menu.country"/></a></li>
              <li class="divider"></li>
              <li><a class="placeholder_temp" href="#">Publishing data</a></li>
              <li><a class="placeholder_temp" href="#">Using data</a></li>
              <li><a class="placeholder_temp" href="#">Infrastructure</a></li>
            </ul>
          </div>
        </li>

        <li>
          <a href="#" title="About GBIF">About GBIF</a>
          <div class="about">
            <a href="#"></a>
            <ul>
              <li><a href="${cfg.drupal}/about">What is GBIF?</a></li>
              <li><a class="placeholder_temp" href="#">Key information</a></li>
              <li><a class="placeholder_temp" href="#">Governance</a></li>
              <li><a class="placeholder_temp" href="#">Who we work with</a></li>
              <li><a class="placeholder_temp" href="#">Contact us</a></li>
            </ul>
          </div>
        </li>


        <li>
          <a href="#" title="Community">Community</a>
          <div class="community">
            <a href="#"></a>
            <ul>
                <li><a class="placeholder_temp" href="#">Participation</a></li>
                <li><a class="placeholder_temp" href="#">Training/Capacity</a></li>
                <li><a class="placeholder_temp" href="#">Networking</a></li>
                <li><a class="placeholder_temp" href="#">Resources</a></li>
            </ul>
          </div>
        </li>


        <li>
        <a href="#" title="About GBIF">Newsroom</a>

        <div class="news">
          <a href="#"></a>
          <ul>
            <li><a href="${cfg.drupal}/newsroom/summary">GBIF news</a></li>
            <li><a href="${cfg.drupal}/newsroom/uses">Featured data use</a></li>
            <li><a href="${cfg.drupal}/newsroom/opportunities">Opportunities</a></li>
            <li><a href="${cfg.drupal}/newsroom/events">Events</a></li>
            <li><a class="placeholder_temp" href="#">GBIF in the news</a></li>
          </ul>
        </div>

        </li>

        <li class="search">
        <form href="<@s.url value='/dataset/search'/>" method="GET">
          <span class="input_text">
              <!-- Global search disabled until implemented later. See issue: http://dev.gbif.org/issues/browse/POR-387 -->
            <input type="text" name="q" disabled="true"/>
          </span>
        </form>
        </li>
      </ul>
      </nav>
    </div>
  </div>
  <!-- /top -->


  <#if page.properties["page.infoband"]?has_content>
  <div id="infoband">
    <div class="content">
      ${page.properties["page.infoband"]}
    </div>
  </div>
  </#if>

  <#if page.properties["page.tabs"]?has_content>
  <div id="tabs">
    <div class="content">
      ${page.properties["page.tabs"]}
    </div>
  </div>
  </#if>

  </header>


  <div id="content">

    ${body}

  </div>

  <footer>
    <div class="inner">
        <ul>
            <li><h3>JOIN THE COMMUNITY</h3></li>
            <li><a class="placeholder_temp" href="#">Join GBIF Community Site</a></li>
            <li><a class="placeholder_temp" href="#">Sign up to GBits newsletter</a></li>
            <li><a class="placeholder_temp" href="#">GBIF Online Resource Centre</a></li>
        </ul>

        <ul>
            <li><h3>WHO’S PARTICIPATING</h3></li>
            <li><a class="placeholder_temp" href="#">Countries</a></li>
            <li><a class="placeholder_temp" href="#">Organizations</a></li>
            <li><a class="placeholder_temp" href="#">Data publishers</a></li>
        </ul>

        <ul>
            <li><h3>KEY DOCUMENTS</h3></li>
            <li><a class="placeholder_temp" href="#">Data use agreement</a></li>
            <li><a class="placeholder_temp" href="#">Data sharing agreement</a></li>
            <li><a class="placeholder_temp" href="#">Memorandum of Understanding</a></li>
            <li><a class="placeholder_temp" href="#">Annual Report</a></li>
            <li><a class="placeholder_temp" href="#">GBIF Strategic Plan</a></li>
            <li><a class="placeholder_temp" href="#">GBIF Work Programme</a></li>
        </ul>

        <ul class="last">
            <li><h3>FOR DEVELOPERS</h3></li>
            <li><a href="<@s.url value='/developer'/>">Portal API</a></li>
            <li><a href="http://gbif.blogspot.com">Developer blog</a></li>
            <li><a href="http://tools.gbif.org">Tools</a></li>
            <li><a class="placeholder_temp" href="#">Standards</a></li>
        </ul>

      </div>
  </footer>

  <div class="contact_footer">
    <div class="inner">
      <!--<p>2012 &copy; GBIF. Data publishers retain all rights to data.</p>-->
      <div class="copyright">
        <div class="logo"></div>
        <p>2011 &copy; GBIF</p>
      </div>

      <div class="address">
        <h3>GBIF Secretariat</h3>
        <address>
          Universitetsparken 15<br />
          DK-2100 Copenhagen Ø<br />
          DENMARK
        </address>
      </div>

      <div class="contact">
        <h3>Contact</h3>
        <ul>
          <li><strong>Email</strong> info@gbif.org</li>
          <li><strong>Tel</strong> +45 35 32 14 70</li>
          <li><strong>Fax</strong> +45 35 32 14 80</li>
        </ul>
        <p>
        You can also check the <a href="#">GBIF Directory</a>
        </p>
      </div>

      <div class="social">
        <ul>
            <li><h3>SOCIAL MEDIA</h3></li>
            <li class="s_icons twitter"><a href="https://twitter.com/GBIF"><strong>Follow</strong> GBIF on Twitter</a></li>
            <li class="s_icons facebook"><a href="https://www.facebook.com/gbifnews"><strong>Like</strong> GBIF on Facebook</a></li>
            <li class="s_icons linkedin"><a href="http://www.linkedin.com/groups/GBIF-55171"><strong>Join</strong> GBIF on Linkedin</a></li>
            <li class="s_icons vimeo"><a href="http://vimeo.com/gbif"><strong>View</strong> GBIF on Vimeo</a></li>
        </ul>
      </div>

    </div>
  </div>

  <!-- JavaScript at the bottom for fast page loading -->
  <!-- scripts concatenated and minified via ant build script  -->
  <script type="text/javascript" src="<@s.url value='/js/vendor/jquery-ui-1.8.17.min.js'/>"></script>
  <script type="text/javascript" src="<@s.url value='/js/vendor/jquery.dropkick-1.0.0.js'/>"></script>
  <script type="text/javascript" src="<@s.url value='/js/vendor/jquery.uniform.min.js'/>"></script>
  <script type="text/javascript" src="<@s.url value='/js/vendor/mousewheel.js'/>"></script>
  <script type="text/javascript" src="<@s.url value='/js/vendor/jscrollpane.min.js'/>"></script>
  <script type="text/javascript" src="<@s.url value='/js/vendor/jquery-scrollTo-1.4.2-min.js'/>"></script>
  <script type="text/javascript" src="<@s.url value='/js/vendor/bootstrap.min.js'/>"></script>
  <script type="text/javascript" src="<@s.url value='/js/vendor/underscore-min.js'/>"></script>
  <script type="text/javascript" src="<@s.url value='/js/helpers.js'/>"></script>
  <script type="text/javascript" src="<@s.url value='/js/widgets.js'/>"></script>
  <script type="text/javascript" src="<@s.url value='/js/graphs.js'/>"></script>
  <script type="text/javascript" src="<@s.url value='/js/app.js'/>"></script>
  <script type="text/javascript" src="<@s.url value='/js/vendor/raphael-min.js'/>"></script>
  <script type="text/javascript" src="<@s.url value='/js/vendor/resourcebundle.js'/>"></script>
  <#-- JIRA feedback buttons -->
  <script type="text/javascript" src="http://dev.gbif.org/issues/s/en_UK-h3luf8-418945332/812/5/1.2.7/_/download/batch/com.atlassian.jira.collector.plugin.jira-issue-collector-plugin:issuecollector/com.atlassian.jira.collector.plugin.jira-issue-collector-plugin:issuecollector.js?collectorId=d0843c23"></script>
  <script type="text/javascript" src="http://dev.gbif.org/issues/s/en_UK-h3luf8-418945332/812/5/1.2.7/_/download/batch/com.atlassian.jira.collector.plugin.jira-issue-collector-plugin:issuecollector/com.atlassian.jira.collector.plugin.jira-issue-collector-plugin:issuecollector.js?collectorId=a2e9eca4"></script>
  <!-- end scripts-->

  <!--[if lt IE 7 ]>
  <script src="<@s.url value='/js/libs/dd_belatedpng.js'/>"></script>
  <script>DD_belatedPNG
    .fix("img, .png_bg"); // Fix any <img> or .png_bg bg-images. Also, please read goo.gl/mZiyb </script>
  <![endif]-->

  <#if page.properties["page.extra_scripts"]?has_content>
  ${page.properties["page.extra_scripts"]}
  </#if>

</body>
</html>
