<!doctype html>
<!-- paulirish.com/2008/conditional-stylesheets-vs-css-hacks-answer-neither/ -->
<!--[if lt IE 7 ]> <html class="no-js ie6" lang="en"> <![endif]-->
<!--[if IE 7 ]>    <html class="no-js ie7" lang="en"> <![endif]-->
<!--[if IE 8 ]>    <html class="no-js ie8" lang="en"> <![endif]-->
<!--[if IE 9 ]>    <html class="ie9"> <![endif]-->
<!--[if (gte IE 9)|!(IE)]><!-->
<html class="no-js" lang="en"> <!--<![endif]-->
<head>
  <meta charset="utf-8">
<#-- Always force latest IE rendering engine (even in intranet) & Chrome Frame
Remove this if you use the .htaccess -->
  <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">

  <title>${title}</title>
  <meta name="description" content="">
  <meta name="author" content="GBIF">

  <!-- Mobile viewport optimized: j.mp/bplateviewport -->
  <meta name="viewport" content="width=device-width, initial-scale=1.0">

  <!-- Place favicon.ico & apple-touch-icon.png in the root of your domain and delete these references -->
  <link rel="shortcut icon" href="<@s.url value='/favicon.ico'/>">
  <link rel="apple-touch-icon" href="<@s.url value='/apple-touch-icon.png'/>">

  <!-- CSS: implied media="all" -->
  <link rel="stylesheet" href="<@s.url value='/css/style.css?v=2'/>"/>
  <link rel="stylesheet" href="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.14/themes/base/jquery-ui.css"
        type="text/css" media="all"/>
  <!-- Uncomment if you are specifically targeting less enabled mobile browsers
<link rel="stylesheet" media="handheld" href="css/handheld.css?v=2">  -->

  <script src="<@s.url value='/js/vendor/modernizr-1.7.min.js'/>"></script>

${head}

</head>
<body class="${page.properties["body.class"]!}">
  <header>
    <!-- top -->
    <div id="top">
      <div class="content">
        <div class="account">
          <a href="#" class="login" title='<@s.text name="menu.login"/>'><@s.text name="menu.login"/></a> or
          <a href="<@s.url value='/user/register/step1'/>"
             title='<@s.text name="menu.register"/>'><@s.text name="menu.register"/></a>
        </div>

        <div id="logo">
          <a href="<@s.url value='/'/>" class="logo"><img src="<@s.url value='/img/header/logo.png'/>"/></a>

          <h1><a href="<@s.url value='/'/>" title="DATA.GBIF.ORG">DATA.GBIF.ORG</a></h1>
          <span>Free and open access to biodiversity data</span>
        </div>

        <nav>
          <ul>
            <li><a href="#" class="more" title="Browse">Browse<span class="more"></span></a></li>
            <li class="search">
              <form>
                <span class="input_text">
                  <input type="text" name="search"/>
                </span>
              </form>
          </ul>
        </nav>
      </div>
    </div>
    <!-- /top -->
  </header>

  <div id="content">

  ${body}

  </div>

  <footer>

  </footer>

  <!-- JavaScript at the bottom for fast page loading -->
  <!-- Grab Google CDN's jQuery, with a protocol relative URL; fall back to local if necessary -->

  <!--<script src="//ajax.googleapis.com/ajax/libs/jquery/1.6.1/jquery.js"></script>
<script src="//ajax.googleapis.com/ajax/libs/jqueryui/1.8.13/jquery-ui.min.js"></script>
<script>window.jQuery || document.write("<script src='/js/vendor_duplicate/jquery-1.6.1.min.js'>\x3C/script>"); document.write("<script src='/js/vendor_duplicate/jquery-ui.min.js'>\x3C/script>");</script>
-->

  <!-- scripts concatenated and minified via ant build script  -->
  <script src="<@s.url value='/js/vendor/jquery-1.6.1.min.js'/>"></script>
  <script src="<@s.url value='/js/vendor/jquery-ui.min.js'/>"></script>
  <script src="<@s.url value='/js/vendor/autocomplete.js'/>"></script>
  <script type="text/javascript" src="<@s.url value='/js/vendor/mousewheel.js'/>"></script>
  <script type="text/javascript" src="<@s.url value='/js/vendor/jscrollpane.min.js'/>"></script>
  <script src="<@s.url value='/js/vendor/jquery-scrollTo-1.4.2-min.js'/>"></script>
  <script src="<@s.url value='/js/vendor/underscore-min.js'/>"></script>
  <script src="<@s.url value='/js/helpers.js'/>"></script>
  <script src="<@s.url value='/js/widgets.js'/>"></script>
  <script src="<@s.url value='/js/app.js'/>"></script>
  <script src="<@s.url value='/js/graphs.js'/>"></script>
  <script src="<@s.url value='/js/vendor/jquery.uniform.min.js" type="text/javascript' />"></script>
  <script src="<@s.url value='/js/vendor/OpenLayers.js'/>"></script>
  <script src="<@s.url value='/js/full_map.js'/>"></script>
  <script src="<@s.url value='/js/types_map.js'/>"></script>
  <script src="<@s.url value='/js/single_map.js'/>"></script>
  <script src="<@s.url value='/js/openlayers_addons.js'/>"></script>
  <script src="<@s.url value='/js/Infowindow.js'/>"></script>
  <script src="<@s.url value='/js/vendor/raphael-min.js'/>"></script>
  <!-- end scripts-->

  <!--[if lt IE 7 ]>
  <script src="<@s.url value='/js/libs/dd_belatedpng.js'/>"></script>
  <script>DD_belatedPNG
          .fix("img, .png_bg"); // Fix any <img> or .png_bg bg-images. Also, please read goo.gl/mZiyb </script>
  <![endif]-->

  <script type="text/javascript">
    $(function() {

      $('nav ul li a.more').bindLinkPopover({
        links:{
          "<@s.text name="menu.countries"/>":"<@s.url value='/countries'/>",
          "<@s.text name="menu.members"/>":"<@s.url value='/members'/>",
          "<@s.text name="menu.themes"/>":"<@s.url value='/themes'/>",
          "<@s.text name="menu.stats"/>":"<@s.url value='/stats'/>",
          "<@s.text name="menu.about"/>":"<@s.url value='/about'/>"
        }
      });

      $(".data_policy").selectBox();
      $(".select").selectBox();

      // Autocomplete for the publisher name field
      publishers = [
        { name: "Publisher 1", desc: "Description"},
        { name: "Publisher 2", desc: "Description"},
        { name: "Publisher 3", desc: "Description"},
        { name: "Publisher 4", desc: "Description"}
      ],

              $("#publisher_name").autocomplete(publishers, {
                minChars: 0, scroll:false, width: 225, matchContains: "word", autoFill: false, max:3,
                formatItem: function(row, i, max) {
                  var clase = "";

                  // Classes to choose the right background for the row
                  if (max == 1) {
                    clase = ' unique';
                  } else if (max == 2 && i == 2) {
                    clase = ' last_double';
                  } else if (i == 1) {
                    clase = ' first';
                  } else if (i == max) {
                    clase = ' last';
                  }
                  return '<div class="row' + clase + '"><span class="name">' + row.name + '</span>' + row.desc +
                         '</div>';
                },
                formatResult: function(row) {
                  return row.name;
                }
              });
    });
  </script>

<#if page.properties["page.extra_scripts"]?has_content>
${page.properties["page.extra_scripts"]}
</#if>

</body>
</html>
