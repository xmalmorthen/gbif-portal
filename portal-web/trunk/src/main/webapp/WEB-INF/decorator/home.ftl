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
<html version="HTML+RDFa 1.1" class="no-js" lang="en"
      xmlns="http://www.w3.org/1999/xhtml"
        >
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
    cfg.wsOcc="${cfg.wsOcc!}";
    cfg.wsOccSearch="${cfg.wsOccSearch!}";
    cfg.tileServerBaseUrl="${cfg.tileServerBaseUrl!}";    
    cfg.wsOccCatalogNumberSearch = "${cfg.wsOccCatalogNumberSearch!}";
    cfg.wsOccCollectorNameSearch = "${cfg.wsOccCollectorNameSearch!}";
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
  <#-- Place favicon.ico & apple-touch-icon.png in the root of your domain and delete these references -->
  <link rel="shortcut icon" href="<@s.url value='/favicon.ico'/>">
  <link rel="apple-touch-icon" href="<@s.url value='/apple-touch-icon.png'/>">
  <#-- CSS: implied media="all" -->
  <link rel="stylesheet" href="<@s.url value='/css/style.css?v=2'/>"/>
  <link rel="stylesheet" href="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.14/themes/base/jquery-ui.css" type="text/css" media="all"/>
  <#-- Uncomment if you are specifically targeting less enabled mobile browsers
  <link rel="stylesheet" media="handheld" href="css/handheld.css?v=2">  -->

  <script src="<@s.url value='/js/vendor/modernizr-1.7.min.js'/>"></script>
  <script type="text/javascript" src="<@s.url value='/js/vendor/jquery-1.7.1.min.js'/>"></script>
  <script type="text/javascript" src="<@s.url value='/js/vendor/jquery-ui-1.8.17.min.js'/>"></script>
  <script type="text/javascript" src="<@s.url value='/js/menu.js'/>"></script>

  ${head}

</head>
<body class="${page.properties["body.class"]!}">

  <header>

  <!-- top -->
  <div id="top">
    <div class="content">
      <div class="account">
        <#if currentUser??>
        <a href="${cfg.drupal}/user/" title='Account'>View your account</a>
        or
        <a href="${cfg.cas}/logout?service=${baseUrl}/" title='<@s.text name="menu.logout"/>'><@s.text name="menu.logout"/></a>
        <#else>
        <a href="${cfg.cas}/login?service=${baseUrl}/" title='<@s.text name="menu.login"/>'><@s.text name="menu.login"/></a> or
        <a href="${cfg.drupal}/user/register" title='<@s.text name="menu.register"/>'><@s.text name="menu.register"/></a>
        </#if>
      </div>

      <div id="logo">
        <a href="<@s.url value='/'/>" class="logo"><img src="<@s.url value='/img/header/logo.png'/>"/></a>

        <h1><a href="<@s.url value='/'/>" title="GBIF.ORG">GBIF.ORG</a></h1>
        <span>Free and open access to biodiversity data</span>
      </div>

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
            <li class="divider"></li>
            <li><a href="#">Themes</a></li>
            <li><a href="#">Statistics</a></li>
            <li><a href="#">GBIF Data usage</a></li>
            <li class="divider"></li>
            <li><a href="#">Publish your data</a></li>
            <li><a href="#">Publishing workflow</a></li>
          </ul>
        </div>

        </li> 

        <li>
        <a href="#" title="Community">Community</a> 

        <div class="community">
          <a href="#"></a>
          <ul>
            <li><a href="#">Regions</a></li>
            <li><a href="#">Countries</a></li>
            <li><a href="#">Participant organizations</a></li>
            <li><a href="#">Data publishers</a></li>
            <li class="divider"></li>
            <li><a href="#">Capacity bulding</a></li>
            <li><a href="#">Training</a></li>
            <li><a href="#">BIF building</a></li>
            <li><a href="#">Whitepages</a></li>
          </ul>
        </div>

        </li>

        <li>
        <a href="#" title="About GBIF">About GBIF</a>

        <div class="about">
          <a href="#"></a>
          <ul>
            <li><a href="<@s.url value='/newsroom'/>">News</a></li>
            <li class="divider"></li>
            <li><a href="#">Key partners</a></li>
            <li><a href="#">Mission</a></li>
            <li><a href="#">Governance details</a></li>
            <li><a href="#">Work programs</a></li>
            <li><a href="#">Key facts</a></li>
          </ul>
        </div>

        </li>

        <li class="search">
        <form href="<@s.url value='/dataset/search'/>" method="GET">
          <span class="input_text">
            <input type="text" name="q"/>
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

    <#if page.properties["page.admin"]?has_content && admin>
    <div id="adminPanel">
      ${page.properties["page.admin"]}
    </div>
    </#if>

    ${body}

  </div>

  <footer>
  <div class="inner">
    <ul>
      <li><h3>EXPLORE THE DATA</h3></li>
      <li><a href="<@s.url value='/occurrence'/>"><@s.text name="menu.occurrence"/></a></li>
      <li><a href="<@s.url value='/dataset'/>"><@s.text name="menu.dataset"/></a></li>
      <li><a href="<@s.url value='/species'/>"><@s.text name="menu.species"/></a></li>
      <li><a href="#"><@s.text name="menu.country"/></a></li>
      <li><a href="#"><@s.text name="menu.member"/></a></li>
      <li><a href="#"><@s.text name="menu.theme"/></a></li>
    </ul>

    <ul>
      <li><h3>VIEW THE STATISTICS</h3></li>
      <li><a href="#">Global numbers</a></li>
      <li><a href="#">Taxonomic coverage</a></li>
      <li><a href="#">Providers</a></li>
      <li><a href="#">Countries</a></li>
    </ul>

    <ul class="last">
      <li><h3>JOIN THE COMMUNITY</h3></li>
      <li><a href="${cfg.drupal}/user/register"><@s.text name="menu.register"/></a></li>
      <li><a href="<@s.url value='/dataset/register/step1'/>"><@s.text name="menu.share"/></a></li>
      <li><a href="${cfg.drupal}/terms"><@s.text name="menu.terms"/></a></li>
      <li><a href="${cfg.drupal}/about"><@s.text name="menu.about"/></a></li>
    </ul>

  </div>
  </footer>

  <div class="contact_footer">
    <div class="inner">
      <!--<p>2012 &copy; GBIF. Data publishers retain all rights to data.</p>-->
      <div class="copyright">
        <div class="logo"></div>
        <p>2011 © GBIF</p>
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


    </div>
  </div>

  <!-- JavaScript at the bottom for fast page loading -->
  <!-- scripts concatenated and minified via ant build script  -->
  <script type="text/javascript" src="<@s.url value='/js/vendor/autocomplete.js'/>"></script>
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
  <!-- end scripts-->

  <!--[if lt IE 7 ]>
  <script src="<@s.url value='/js/libs/dd_belatedpng.js'/>"></script>
  <script>DD_belatedPNG
    .fix("img, .png_bg"); // Fix any <img> or .png_bg bg-images. Also, please read goo.gl/mZiyb </script>
  <![endif]-->

  <!#-- keep this javascript here so we can use the s.url tag -->
  <script type="text/javascript">
    $(function() {
      $('nav ul li a.more').bindLinkPopover({
        links:{
          "<@s.text name="menu.country"/>":"<@s.url value='/country'/>",
          "<@s.text name="menu.member"/>":"<@s.url value='/member'/>",
          "<@s.text name="menu.theme"/>":"<@s.url value='/theme'/>",
          "<@s.text name="menu.stats"/>":"<@s.url value='/stats'/>",
          <#if admin>
          "<@s.text name="menu.admin"/>":"<@s.url value='/admin'/>",
          </#if>
          "<@s.text name="menu.about"/>":"${cfg.drupal}/about"
        }
      });
    });
  </script>

  <#if page.properties["page.extra_scripts"]?has_content>
  ${page.properties["page.extra_scripts"]}
  </#if>

</body>
</html>
