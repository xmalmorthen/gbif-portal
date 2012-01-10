<#import "/WEB-INF/macros/common.ftl" as common>
<html>
<head>
  <title>${dataset.title} - External dataset detail</title>
  <content tag="extra_scripts">
    <script type="text/javascript" src="<@s.url value='/js/vendor/OpenLayers.js'/>"></script>
    <script type="text/javascript" src="<@s.url value='/js/openlayers_addons.js'/>"></script>
    <script type="text/javascript" src="<@s.url value='/js/Infowindow.js'/>"></script>
    <script type="text/javascript" src="<@s.url value='/js/types_map.js'/>"></script>
    <script type="text/javascript" src="<@s.url value='/js/single_map.js'/>"></script>
  </content>
  <meta name="menu" content="datasets"/>
</head>
<body class="typesmap">

<#assign tab="info"/>
<#include "/WEB-INF/pages/dataset/infoband.ftl">

  <article>
    <header></header>
    <div class="content">

      <div class="header">
        <div class="left"><h2>Summary</h2></div>
      </div>

      <div class="left">
        <h3>Abstract</h3>

        <p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu
          feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril
          delenit augue duis dolore te feugait nulla facilisi. Dolore eu feugiat nulla facilisis at vero eros et
          accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait
          nulla facilisi.
        </p>

        <p>Feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril
          delenit augue duis dolore te feugait nulla facilisi.</p>

        <h3>Purpose</h3>

        <p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu
          feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril
          delenit augue duis dolore te feugait nulla facilisi.</p>

        <h3>Additional information</h3>

        <p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu
          feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril
          delenit augue duis dolore te feugait nulla facilisi.</p>

        <h3>Temporal context</h3>

        <p>Jan 1st, 2001 → Jan 1st, 2009</p>

        <h3>Languages</h3>

        <p>English</p>
      </div>
      <div class="right">
        <div class="logo_holder">
          <img src="<@s.url value='/external/logos/logo1.jpg'/>"/>
        </div>
        <h3>Provided by</h3>

        <p><a href="<@s.url value='/member/123'/>" title="Botanic Garden and Botanical Museum Berlin-Dahlem">Botanic Garden and
          Botanical Museum Berlin-Dahlem</a></p>

        <h3>Hosted by</h3>

        <p><a href="<@s.url value='/member/123'/>" title="DanBIF Data Hosting Center">DanBIF Data Hosting Center</a></p>

        <h3>Endorsed by</h3>

        <p><a href="<@s.url value='/member/123'/>" title="GBIF Germany Participant Node">GBIF Germany Participant Node</a></p>

        <h3>Alternative Identifiers</h3>

        <p>UC-10029192, REF-ejedei</p>

        <h3>External Links</h3>
        <ul>
          <li><a href="#" title="Original source">Original dataset source</a></li>
          <li><a href="#" title="Author's blog">Author's blog</a></li>
          <li><a href="#" title="Methodology">A discussion board over the methodology</a></li>
        </ul>
        <h3>Metadata</h3>
        <ul>
          <li class="download">EML file <a href="#"><abbr>[ENG]</abbr></a> &middot; <a
                  href="#"><abbr>[SPA]</abbr></a> &middot; <a href="#"><abbr>[GER]</abbr></a></li>
          <li class="download">ISO 1939 file <a href="#"><abbr>[ENG]</abbr></a> &middot; <a href="#"><abbr>[SPA]</abbr></a> &middot;
            <a href="#"><abbr>[GER]</abbr></a></li>
        </ul>
      </div>
    </div>
    <footer></footer>
  </article>

  <article>
    <header></header>
    <div class="content">

      <div class="header">
        <div class="left"><h2>Taxonomic coverage</h2></div>
      </div>

      <div class="left">
        <ul class="three_cols">
          <li><a href="<@s.url value='/species/42/name_usage'/>">Araneae<a/></li>
          <li><a href="<@s.url value='/species/42/name_usage'/>">Opiliones</a></li>
          <li><a href="<@s.url value='/species/42/name_usage'/>">Parasitiformes</a></li>
          <li><a href="<@s.url value='/species/42/name_usage'/>">Pseudoscorpionida</a></li>
          <li><a href="<@s.url value='/species/42/name_usage'/>">Sarcoptiformes</a></li>
          <li><a href="<@s.url value='/species/42/name_usage'/>">Scorpiones</a></li>
          <li><a href="<@s.url value='/species/42/name_usage'/>">Trombidiformes</a></li>
          <li><a href="<@s.url value='/species/42/name_usage'/>">Pseudoscorpionida</a></li>
          <li><a href="<@s.url value='/species/42/name_usage'/>">Sarcoptiformes</a></li>
          <li><a href="<@s.url value='/species/42/name_usage'/>">Scorpiones</a></li>
        </ul>
        <ul class="three_cols">
          <li><a href="<@s.url value='/species/42/name_usage'/>">Araneae<a/></li>
          <li><a href="<@s.url value='/species/42/name_usage'/>">Opiliones</a></li>
          <li><a href="<@s.url value='/species/42/name_usage'/>">Parasitiformes</a></li>
          <li><a href="<@s.url value='/species/42/name_usage'/>">Pseudoscorpionida</a></li>
          <li><a href="<@s.url value='/species/42/name_usage'/>">Sarcoptiformes</a></li>
          <li><a href="<@s.url value='/species/42/name_usage'/>">Scorpiones</a></li>
          <li><a href="<@s.url value='/species/42/name_usage'/>">Trombidiformes</a></li>
          <li><a href="<@s.url value='/species/42/name_usage'/>">Pseudoscorpionida</a></li>
          <li><a href="<@s.url value='/species/42/name_usage'/>">Sarcoptiformes</a></li>
          <li><a href="<@s.url value='/species/42/name_usage'/>">Scorpiones</a></li>
        </ul>
        <ul class="three_cols">
          <li><a href="<@s.url value='/species/42/name_usage'/>">Araneae<a/></li>
          <li><a href="<@s.url value='/species/42/name_usage'/>">Opiliones</a></li>
          <li><a href="<@s.url value='/species/42/name_usage'/>">Parasitiformes</a></li>
          <li><a href="<@s.url value='/species/42/name_usage'/>">Pseudoscorpionida</a></li>
          <li><a href="<@s.url value='/species/42/name_usage'/>">Sarcoptiformes</a></li>
          <li><a href="<@s.url value='/species/42/name_usage'/>">Scorpiones</a></li>
          <li><a href="<@s.url value='/species/42/name_usage'/>">Trombidiformes</a></li>
          <li><a href="<@s.url value='/species/42/name_usage'/>">Pseudoscorpionida</a></li>
          <li><a href="<@s.url value='/species/42/name_usage'/>">Sarcoptiformes</a></li>
          <li><a href="<@s.url value='/species/42/name_usage'/>">Scorpiones</a></li>
        </ul>

        <p>The complete list has 123.002 more elements. You need to <a href="#" class="download"
                                                                       title="visit the dataset"> visit the dataset</a>
          to download it.</p>
      </div>

      <div class="right">
      </div>

    </div>
    <footer></footer>
  </article>

  <article class="map">
    <header></header>
    <div id="map"></div>
    <a href="#zoom_in" class="zoom_in"></a>
    <a href="#zoom_out" class="zoom_out"></a>

    <div class="content">

      <div class="header">
        <div class="right"><h2>Boundaries</h2></div>
      </div>

      <div class="right">
        <h3>Geographic coverage</h3>

        <p>North America</p>

        <p class="maptype"><a href="#" title="points">points</a> | <a href="#" title="grid">grid</a> | <a href="#"
                                                                                                          title="polygons"
                                                                                                          class="selected">polygons</a>
        </p>

        <h3>Download</h3>
        <ul>
          <li class="download"><a href="#" title="One Degree cell density">One Degree cell density <abbr
                  title="Keyhole Markup Language">(KML)</abbr></a></li>
          <li class="download"><a href="#" title="Placemarks">Placemarks <abbr
                  title="Keyhole Markup Language">(KML)</abbr></a></li>
        </ul>
      </div>
    </div>
    <footer></footer>
  </article>

  <article>
    <header></header>
    <div class="content">
      <h2>The project</h2>

      <div class="left">

        <h3>Study area description</h3>

        <p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu
          feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril
          delenit augue duis dolore te feugait nulla facilisi. Dolore eu feugiat nulla facilisis at vero eros et
          accumsan et iusto odio dignissim qui blandit.</p>

        <h3>Design description</h3>

        <p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu
          feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril
          delenit augue duis dolore te feugait nulla facilisi. Dolore eu feugiat nulla facilisis at vero eros et
          accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait
          nulla facilisi.</p>

        <h3>Funding</h3>

        <p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu
          feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril
          delenit augue duis dolore te feugait nulla facilisi.</p>

        <h3>Team</h3>

        <ul class="team">
          <li>
            <h4>Paul J. Morris</h4>
            <h4 class="position">Resource Contact</h4>
            <a href="#" title="Paul J. Morris' email">mole@morris.net</a>
            1-215-299-1161
          </li>

          <li>
            <h4>Markus Doring</h4>
            <h4 class="position">Taxonomy</h4>
            <a href="#" title="Markus doring's email">mdoring@morris.net</a>
            1-215-299-1161
          </li>

          <li>
            <h4>Javier Álvarez</h4>
            <h4 class="position">Resource Contact</h4>
            <a href="#" title="Javier Álvarez email">javieralvarez@morris.net</a>
            <span class="phone">1-215-299-1161</span>
          </li>

        </ul>
      </div>

      <div class="right">
        <h3>Associated parties</h3>

        <ul class="parties">
          <li>
            <strong>David Remsen</strong>
            GBIF Secretariat
            <address>
              Universitetsparken 15, Copenhagen, Ø, Denmark
              <a href="mailto:#" title="David Remsen">dremsen@gbif.org </a>
              004535321472
            </address>
          </li>

          <li>
            <strong>Javier de la Torre</strong>
            GBIF Spain Node

            <address>
              Hortaleza 48, 1, Spain, 28004, Madrid
              <a href="mailto:#" title="Javier de la Torre">jatorrn@gbif.org</a>
              659885887
            </address>
          </li>
        </ul>

      </div>

    </div>
    <footer></footer>
  </article>


  <article>
    <header></header>
    <div class="content">
      <h2>Methodolgy</h2>

      <div class="left">

        <h3>Study extent</h3>

        <p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu
          feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril
          delenit augue duis dolore te feugait nulla facilisi. Dolore eu feugiat nulla facilisis at vero eros et
          accumsan et iusto odio dignissim qui blandit.</p>

        <h3>Sampling description</h3>

        <p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu
          feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril
          delenit augue duis dolore te feugait nulla facilisi. Dolore eu feugiat nulla facilisis at vero eros et
          accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait
          nulla facilisi.</p>

        <h3>Quality control</h3>

        <p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu
          feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril
          delenit augue duis dolore te feugait nulla facilisi.</p>

      </div>

      <div class="right">
        <h3>Collection name</h3>

        <p>Ave specimens (AVES123)</p>

        <h3>Parent identifier</h3>

        <p>AVES</p>

        <h3>Preservation method</h3>

        <p>Glycerin</p>

        <h3>Curational units</h3>
        <ul>
          <li>100/500 Specimens</li>
          <li>1000 (+/- 100) jars</li>
          <li>100/500 Boxes</li>
        </ul>
      </div>

    </div>
    <footer></footer>
  </article>


  <article class="mono_line">
    <header></header>
    <div class="content">

      <h2>Dataset usage & legal issues</h2>

      <div class="left">
        <h3>Usage rights</h3>

        <p>This dataset is released under an Open Data licence, so it can be used to anyone who cites it. </p>

        <h3>How to cite it</h3>

        <p>Alaska Ocean Observing System, Arctic Ocean Diversity (accessed through GBIF data portal, <a href="#"
                                                                                                        title="Alaska Ocean Observing System, Arctic Ocean Diversity">http://data.gbif.org/datasets/resource/654</a>,
          2011-05-05)</p>
      </div>
    </div>
    <footer></footer>
  </article>

</body>
</html>

