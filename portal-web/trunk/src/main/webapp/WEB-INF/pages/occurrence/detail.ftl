<html>
<head>
  <title>Occurrence detail ${id?c} - GBIF</title>
  <meta name="menu" content="occurrences"/>
</head>
<body class="typesmap">

<content tag="infoband">
  <ul class="breadcrumb">
    <li><a href="#" title="Explore">Explore</a></li>
    <li class="last"><a href="#" title="Occurrences">Occurrences</a></li>
  </ul>

  <h1>${occurrence.institutionCode!} ${occurrence.collectionCode!} ${occurrence.catalogNumber!}</h1>

  <h3>An occurrence
    of <a href="<@s.url value='/species/${occurrence.id?c}'/>">${occurrence.scientificName!"MISSING NAME"}</a>
    from <a href="<@s.url value='/dataset/${dataset.key}'/>">${dataset.title}</a> dataset.
  </h3>

</content>

<content tag="tabs">
  <div id="tabs">
    <ul>
      <li class='selected'>
        <a href="<@s.url value='/occurrence/${id?c}'/>" title="Information"><span>Information</span></a>
      </li>
      <li>
        <a id="activity_tab" href="<@s.url value='/occurrence/${id?c}/activity'/>" title="Activity"><span>Activity <sup>(3)</sup></span></a>
      </li>
      <li>
        <a href="<@s.url value='/occurrence/${id}/detail_raw'/>" title="Details"><span>Details</span></a>
      </li>
    </ul>
  </div>
</content>

<article class="map">
  <header></header>
  <div id="map"></div>
  <a class="zoom_in" href="#zoom_in">zoom in</a>
  <a class="zoom_out" href="#zoom_out">zoom out</a>

  <div class="content">

    <div class="header">
      <div class="right"><h2>Geoposition</h2></div>
    </div>

    <div class="right">
      <h3>Position</h3>

      <p class="no_bottom placeholder_temp">Las Matas, Madrid, Spain</p>
    <#if occurrence.longitude?? && occurrence.latitude??>
      <p class="light_note">${occurrence.longitude}, ${occurrence.latitude} (± 0.25)</p>
    </#if>

    <#if occurrence.altitude??>
      <h3>Altitude</h3>

      <p>${occurrence.altitude}m</p>
    </#if>

    <#if occurrence.depth??>
      <h3>Depth</h3>

      <p>${occurrence.depth}m</p>
    </#if>


      <h3>Geoprecision</h3>

      <p class="placeholder_temp">100m</p>

      <h3>Download</h3>
      <ul>
        <li class="download placeholder_temp"><a href="#" title="Placemark">Placemark <abbr
                title="Keyhole Markup Language">(KML)</abbr></a>
        </li>
      </ul>
    </div>
  </div>
  <footer></footer>
</article>

<article>
  <header></header>
  <div class="content">

    <div class="header">
      <div class="left"><h2>Occurrence details</h2></div>
    </div>

    <div class="left">
      <div class="col">
        <h3>Basis of record</h3>

        <p>${occurrence.basisOfRecord!"Unknown"}
          <super><a href="" id="interpretation">*</a></super>
        </p>

        <h3>Type status</h3>

        <p class="placeholder_temp">Holotype</p>

        <h3>Typified name string</h3>

        <p class="placeholder_temp">Puma concolor</p>
      </div>
      <div class="col placeholder_temp">
        <h3>Individual count</h3>

        <p>1</p>

        <h3>Sex</h3>

        <p>Male</p>

        <h3>Life stage</h3>

        <p>Juvenile</p>
      </div>
    </div>
    <div class="right">
      <h3>Dataset</h3>

      <p>${dataset.title}</p>

      <h3>Data publisher</h3>

      <p><a href="<@s.url value='/organization/${dataset.owningOrganizationKey!}'/>"
            title="">${dataset.owningOrganizationKey!"Unknown"}</a></p>

      <h3>DOWNLOAD</h3>
      <ul>
        <li class="download"><a href="#" title="Placemark">Original record</a></li>
        <li class="download"><a href="#" title="Placemark">Cached record</a></li>
      </ul>
    </div>
  </div>
  <footer></footer>
</article>

<article>
  <header></header>
  <div class="content placeholder_temp">
    <div class="header">
      <div class="left"><h2>Identification details <span class="subtitle">according to <a
              href="<@s.url value='/dataset/1'/>">GBIF Backbone Taxonomy</a></h2></div>
    </div>
    <div class="left">
      <h3>Species</h3>

      <p><a href="<@s.url value='/species/123'/>">Puma concolor</a></p>

      <h3>Taxonomic classification</h3>
      <ul class="taxonomy">
        <li><a href="<@s.url value='/species/123'/>">Animalia</a></li>
        <li><a href="<@s.url value='/species/123'/>">Chordata</a></li>
        <li><a href="<@s.url value='/species/123'/>">Mammalia</a></li>
        <li><a href="<@s.url value='/species/123'/>">Carnivora</a></li>
        <li><a href="<@s.url value='/species/123'/>">Felidae</a></li>
        <li class="last"><a href="">Puma</a></li>
      </ul>
      <div class="extended">(<a href="/occurrence/classification.html">extended</a>)</div>
    </div>
    <div class="right">
      <h3>Identification date </h3>

      <p>Oct 23th, 2007</p>

      <h3>Identifier name</h3>

      <p>Thomas Function</p>
    </div>
  </div>
  <footer></footer>
</article>

<article>
  <header></header>
  <div class="content">
    <div class="header">
      <div class="left"><h2>Collection details</h2></div>
    </div>
    <div class="left placeholder_temp">
      <h3>Collection date </h3>

      <p>Oct 23th, 2007</p>

      <h3>Collector name</h3>

      <p>Thomas Function</p>

      <h3>Collector notes</h3>

      <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et
        dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea
        commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat
        nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim
        id est laborum.</p>
    </div>
    <div class="right">
    <#if occurrence.catalogNumber??>
      <h3>Catalog number</h3>

      <p>${occurrence.catalogNumber}</p>
    </#if>

    <#if occurrence.institutionCode??>
      <h3>Institution code</h3>

      <p>${occurrence.institutionCode}</p>
    </#if>

    <#if occurrence.collectionCode??>
      <h3>Collection code</h3>

      <p>${occurrence.collectionCode}</p>
    </#if>

    <#if occurrence.collectionCode??>
      <h3>Collection code</h3>

      <p>${occurrence.collectionCode}</p>
    </#if>

      <h3>Occurrence identifier</h3>

      <p class="placeholder_temp">ITS-55526310</p>

    </div>
  </div>
  <footer></footer>
</article>

<article class="mono_line">
  <header></header>
  <div class="content placeholder_temp">
    <h2>Usage & legal issues</h2>

    <div class="left">
      <h3>USAGE RIGHTS</h3>

      <p>Released under an Open Data licence, so it can be used to anyone who cites it. </p>

      <h3>HOW TO CITE IT</h3>

      <p>Alaska Ocean Observing System, Arctic Ocean Diversity (accessed through GBIF data portal, <a
              href="http://data.gbif.org/datasets/resource/654">http://data.gbif.org/datasets/resource/654</a>,
        2011-05-05)</p>
    </div>
  </div>
  <footer></footer>
</article>

</body>
</html>
