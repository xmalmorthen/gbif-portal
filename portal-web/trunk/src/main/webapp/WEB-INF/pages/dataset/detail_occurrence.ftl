<#import "/WEB-INF/macros/common.ftl" as common>
<html>
<head>
  <title>Dataset detail - GBIF</title>
  <content tag="extra_scripts">
    <script type="text/javascript" src="<@s.url value='/js/vendor/OpenLayers.js'/>"></script>
    <script type="text/javascript" src="<@s.url value='/js/openlayers_addons.js'/>"></script>
    <script type="text/javascript" src="<@s.url value='/js/Infowindow.js'/>"></script>
    <script type="text/javascript" src="<@s.url value='/js/types_map.js'/>"></script>
    <script type="text/javascript" src="<@s.url value='/js/single_map.js'/>"></script>
  </content>
  <meta name="menu" content="datasets"/>
</head>
<body class="species typesmap">

<#assign tab="info"/>
<#include "/WEB-INF/pages/dataset/infoband.ftl">

<article>
  <header></header>
  <div class="content">

  <#include "/WEB-INF/pages/dataset/summary.ftl">

  <#include "/WEB-INF/pages/dataset/right_sidebar.ftl">

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
      <div class="right"><h2>1,453 georeferenced occurrences</h2></div>
    </div>

    <div class="right">
      <h3>Visualize</h3>

      <p class="maptype"><a class="selected" href="#" title="points">points</a> | <a href="#" title="grid">grid</a> | <a
              href="#" title="polygons">polygons</a></p>

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


<article class="taxonomies">
  <header></header>
  <div class="content">
    <div class="header">
      <div class="left">
        <h2>Taxonomic distribution</h2>
        <ul>
          <li><a href="#" id="occurrences" class="sort">Showing occurrences<span class="more"></span></a></li>
          <li><a href="#" id="tax_sort_occurrences" class="sort">Sort occurrences<span class="more"></span></a></li>
        </ul>
      </div>
    </div>
    <div class="left">
      <div id="taxonomy">
        <div class="inner">
          <div class="sp">
            <ul>
              <li data="40"><span>Animalia</span> <a href="<@s.url value='/species/42'/>">see details</a>
                <ul>
                  <li data="10"><span>Acantocephala</span> <a href="<@s.url value='/species/42'/>">see details</a></li>
                  <li data="90"><span>Annelida</span> <a href="<@s.url value='/species/42'/>">see details</a></li>
                  <li data="180"><span>Arthropoda</span><a href="<@s.url value='/species/42'/>">see details</a></li>
                  <li data="40"><span>Brachipoda</span><a href="<@s.url value='/species/42'/>">see details</a></li>
                  <li data="40"><span>Cephalorhyncha</span><a href="<@s.url value='/species/42'/>">see details</a></li>
                  <li data="20"><span>Chaetognatha</span><a href="<@s.url value='/species/42'/>">see details</a></li>
                  <li data="50"><span>Chordata</span><a href="<@s.url value='/species/42'/>">see details</a></li>
                  <li data="10"><span>Cnidaria</span><a href="<@s.url value='/species/42'/>">see details</a></li>
                  <li data="60"><span>Ctenophora</span><a href="<@s.url value='/species/42'/>">see details</a></li>
                </ul>
              </li>
              <li data="20"><span>Archaea</span><a href="<@s.url value='/species/42'/>">see details</a></li>
              <li data="10"><span>Bacteria</span><a href="<@s.url value='/species/42'/>">see details</a>
                <ul>
                  <li data="10"><span>Acidobacteria</span><a href="<@s.url value='/species/42'/>">see details</a></li>
                  <li data="90"><span>Actinobacteria</span><a href="<@s.url value='/species/42'/>">see details</a></li>
                  <li data="40"><span>Aquificae</span><a href="<@s.url value='/species/42'/>">see details</a></li>
                  <li data="40"><span>Bacteroidetes</span><a href="<@s.url value='/species/42'/>">see details</a></li>
                  <li data="10"><span>Acidobacteria</span><a href="<@s.url value='/species/42'/>">see details</a></li>
                  <li data="90"><span>Actinobacteria</span><a href="<@s.url value='/species/42'/>">see details</a></li>
                  <li data="40"><span>Aquificae</span><a href="<@s.url value='/species/42'/>">see details</a></li>
                  <li data="40"><span>Bacteroidetes</span><a href="<@s.url value='/species/42'/>">see details</a></li>
                  <li data="10"><span>Acidobacteria</span><a href="<@s.url value='/species/42'/>">see details</a></li>
                  <li data="90"><span>Actinobacteria</span><a href="<@s.url value='/species/42'/>">see details</a></li>
                  <li data="40"><span>Aquificae</span><a href="<@s.url value='/species/42'/>">see details</a></li>
                  <li data="40"><span>Bacteroidetes</span><a href="<@s.url value='/species/42'/>">see details</a></li>
                  <li data="10"><span>Acidobacteria</span><a href="<@s.url value='/species/42'/>">see details</a></li>
                  <li data="90"><span>Actinobacteria</span><a href="<@s.url value='/species/42'/>">see details</a></li>
                  <li data="40"><span>Aquificae</span><a href="<@s.url value='/species/42'/>">see details</a></li>
                  <li data="40"><span>Bacteroidetes</span><a href="<@s.url value='/species/42'/>">see details</a></li>
                  <li data="10"><span>Acidobacteria</span><a href="<@s.url value='/species/42'/>">see details</a></li>
                  <li data="90"><span>Actinobacteria</span><a href="<@s.url value='/species/42'/>">see details</a></li>
                  <li data="40"><span>Aquificae</span><a href="<@s.url value='/species/42'/>">see details</a></li>
                  <li data="40"><span>Bacteroidetes</span><a href="<@s.url value='/species/42'/>">see details</a></li>
                  <li data="10"><span>Acidobacteria</span><a href="<@s.url value='/species/42'/>">see details</a></li>
                  <li data="90"><span>Actinobacteria</span><a href="<@s.url value='/species/42'/>">see details</a></li>
                  <li data="40"><span>Aquificae</span><a href="<@s.url value='/species/42'/>">see details</a></li>
                  <li data="40"><span>Bacteroidetes</span><a href="<@s.url value='/species/42'/>">see details</a></li>
                  <li data="10"><span>Acidobacteria</span><a href="<@s.url value='/species/42'/>">see details</a></li>
                  <li data="90"><span>Actinobacteria</span><a href="<@s.url value='/species/42'/>">see details</a></li>
                  <li data="40"><span>Aquificae</span><a href="<@s.url value='/species/42'/>">see details</a></li>
                  <li data="40"><span>Bacteroidetes</span><a href="<@s.url value='/species/42'/>">see details</a></li>
                </ul>
              </li>
              <li data="90"><span>Chromista</span><a href="<@s.url value='/species/42'/>">see details</a></li>
              <li data="30"><span>Fungi</span><a href="<@s.url value='/species/42'/>">see details</a></li>
              <li data="50"><span>Plantae</span><a href="<@s.url value='/species/42'/>">see details</a>
                <ul>
                  <li data="10"><span>Anthocerotophyta</span><a href="<@s.url value='/species/42'/>">see details</a>
                    <ul>
                      <li data="80"><span>Anthocerotopsida</span><a href="<@s.url value='/species/42'/>">see details</a>
                        <ul>
                          <li data="10"><span>Anthocerotales</span><a href="<@s.url value='/species/42'/>">see
                            details</a>
                            <ul>
                              <li data="10"><span>Anthocerotaceae</span><a href="<@s.url value='/species/42'/>">see
                                details</a>
                                <ul>
                                  <li data="10"><span>Anthoceros</span><a href="<@s.url value='/species/42'/>">see
                                    details</a>
                                  </li>
                                  <li data="90"><span>Phaeoceros</span><a href="<@s.url value='/species/42'/>">see
                                    details</a>
                                  </li>
                                </ul>
                              </li>
                            </ul>
                          </li>
                          <li data="20"><span>Codoniaceae</span><a href="<@s.url value='/species/42'/>">see details</a>
                          </li>
                          <li data="30"><span>Dendrocerotaceae</span><a href="<@s.url value='/species/42'/>">see
                            details</a></li>
                          <li data="60"><span>Notothyladaceae</span><a href="<@s.url value='/species/42'/>">see
                            details</a></li>
                        </ul>
                      </li>
                    </ul>
                  </li>
                  <li data="80"><span>Bacillariophyta</span><a href="<@s.url value='/species/42'/>">see details</a></li>
                  <li data="90"><span>Bryophyta</span><a href="<@s.url value='/species/42'/>">see details</a></li>
                  <li data="40"><span>Chlorophyta</span><a href="<@s.url value='/species/42'/>">see details</a></li>
                  <li data="20"><span>Cyanidiophyta</span><a href="<@s.url value='/species/42'/>">see details</a></li>
                  <li data="30"><span>Cycadophyta</span><a href="<@s.url value='/species/42'/>">see details</a></li>
                  <li data="80"><span>Bacillariophyta</span><a href="<@s.url value='/species/42'/>">see details</a></li>
                  <li data="90"><span>Bryophyta</span><a href="<@s.url value='/species/42'/>">see details</a></li>
                  <li data="40"><span>Chlorophyta</span><a href="<@s.url value='/species/42'/>">see details</a></li>
                  <li data="20"><span>Cyanidiophyta</span><a href="<@s.url value='/species/42'/>">see details</a></li>
                  <li data="30"><span>Cycadophyta</span><a href="<@s.url value='/species/42'/>">see details</a></li>
                </ul>
              </li>
              <li data="100"><span>Protozoa</span><a href="<@s.url value='/species/42'/>">see details</a></li>
              <li data="60"><span>Viruses</span><a href="<@s.url value='/species/42'/>">see details</a></li>

              </li>
            </ul>
          </div>
        </div>
      </div>
    </div>
    <div class="right">
      <h3>More occurrences species</h3>
      <ul>
        <li><a href="<@s.url value='/species/42'/>" title="Puma concolor">Puma concolor</a> <span class="number">2,002,372</span>
        </li>
        <li><a href="<@s.url value='/species/42'/>" title="Puma concolor">Puma concolor</a> <span
                class="number">9,123</span></li>
        <li><a href="<@s.url value='/species/42'/>" title="Puma concolor">Puma concolor</a> <span
                class="number">200</span></li>
      </ul>
    </div>
  </div>
  <footer></footer>
</article>

<#include "/WEB-INF/pages/dataset/project.ftl">

<article>
  <header></header>
  <div class="content">
    <h2>Methodology</h2>

    <div class="left">

      <h3>Study extent</h3>

      <p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu
        feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril
        delenit augue duis dolore te feugait nulla facilisi. Dolore eu feugiat nulla facilisis at vero eros et accumsan
        et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla
        facilisi.</p>

      <h3>Sampling description</h3>

      <p>Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu
        feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril
        delenit augue duis dolore te feugait nulla facilisi. Dolore eu feugiat nulla facilisis at vero eros et accumsan
        et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla
        facilisi.</p>

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

    <div class="header">
      <h2>Dataset usage & legal issues</h2>
    </div>

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
