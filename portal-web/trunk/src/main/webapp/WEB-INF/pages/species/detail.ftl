<html>
<head>
  <title>${usage.scientificName} - Checklist View</title>
  <meta name="menu" content="species"/>
  <script src="<@s.url value='/js/full_map.js'/>"></script>
</head>
<body class="species typesmap">

<content tag="infoband">
  <ul class="breadcrumb">
    <li class="last">${(usage.rank!"Unranked")?capitalize}</li>
  </ul>

  <h1>${usage.scientificName}</h1>

  <h3>according to <a href="<@s.url value='/dataset/${checklist.key}'/>">${checklist.name!"???"}</a></h3>

  <h3>${usage.higherClassifcation!}</h3>

  <!--
  <h3 class="separator">${usage.higherClassifcation!}</h3>
  <ul class="tags">
    <li><a href="#" title="Turkey">Turkey</a></li>
    <li><a href="#" title="coastal">coastal</a></li>
    <li class="last"><a href="#" title="herbal">herbal</a></li>
  </ul>
  -->

<#if nub>
  <div class="box">
    <div class="content">
      <ul>
        <li><h4>${usage.numOccurrences}</h4>Occurrences</li>
        <#if usage.rank.isSpeciesOrBelow()>
          <li class="last"><h4>${usage.numDescendants}</h4>Infraspecies</li>
        <#else>
          <li class="last"><h4>${usage.numSpecies}</h4>Species</li>
        </#if>
      </ul>
      <a href="#" title="Download Occurrences" class="download candy_blue_button"><span>Download occurrences</span></a>
    </div>
  </div>
</#if>

</content>

<content tag="tabs">
  <ul>
    <li class='selected'><a href="<@s.url value='/species/${id?c}'/>"><span>Information</span></a></li>
    <li><a href="<@s.url value='/species/${id?c}/activity'/>" title="Activity"><span>Activity <sup>(2)</sup></span></a></li>
    <#if nub>
      <li><a href="<@s.url value='/species/${id?c}/stats'/>" title="Stats"><span>Stats <sup>(2)</sup></span></a></li>
    <#else>
      <li><a href="<@s.url value='/species/${id?c}/verbatim'/>" title="Details"><span>Details</span></a></li>
    </#if>
  </ul>
</content>

<#if !nub>
<#-- ONLY FOR CHECKLIST PAGES -->
<article class="notice">
  <header></header>
  <div class="content">
    <h3>This is a particular view of ${usage.canonicalName!scientificName}</h3>

    <p>This is the <em>${usage.scientificName}</em> view, as seen by <a
            href="<@s.url value='/dataset/${checklist.key}'/>">${checklist.name!"???"}</a> checklist.
    <#if usage.nubKey?exists>
      Remember that you can also check the <a href="<@s.url value='/species/${usage.nubKey}'/>">GBIF view
      on ${usage.canonicalName!scientificName}</a>.
    </#if>
      <br/>You can also see the <a href="<@s.url value='/species/${id?c}/verbatim'/>">verbatim version</a>
      submitted by
      the data publisher.</p>
    <img id="notice_icon" src="<@s.url value='/img/icons/notice_icon.png'/>"/>
  </div>
  <footer></footer>
</article>
</#if>

<article id="overview">
  <header></header>
  <div class="content">

    <div class="header">
      <div class="left"><h2>Overview</h2></div>
    </div>

    <div class="left">
      <ul class="thumbs_list">
        <li><a href="#" class="images"><span><img src="<@s.url value='/external/photos/puma_thumbnail.jpg'/>"/></span></a></li>
        <li><a href="#" class="images"><span><img src="<@s.url value='/external/photos/puma_thumbnail.jpg'/>"/></span></a></li>
        <li><a href="#" class="images"><span><img src="<@s.url value='/external/photos/puma_thumbnail.jpg'/>"/></span></a></li>
        <li class="last"><a href="#" class="images"><span><img src="<@s.url value='/external/photos/puma_thumbnail.jpg'/>"/></span></a></li>
      </ul>

      <h3>Full name</h3>

      <p>${usage.scientificName}</p>

      <h3>Status</h3>

      <p>${usage.taxonomicStatus!"?"}</p>

      <h3>Living period</h3>

      <p class="placeholder_temp">Quaternary.</p>

      <h3>Habitat</h3>

      <p class="placeholder_temp">Pre-cordilleran steppe.</p>

    <#list usage.descriptions as d>
      <h3>${d.type!"Description"}
        <#if d.source?has_content>
          <a class="sourcePopup" id="source${d.id?c}" source="${d.source}" remarks="${d.remarks!}"></a>
        </#if>
      </h3>
      <p>${d.description!}</p>
    </#list>

    </div>
    <div class="right">
      <h3>Common names</h3>
      <ul>
      <#list usage.vernacularNames as v>
        <#if v.vernacularName?has_content>
          <li>${v.vernacularName} <span class="small">${v.language!}</span></li>
        </#if>
      </#list>
      </ul>

    <#if basionym?has_content>
      <h3>Original Name</h3>

      <p>${basionym.scientificName}</p>
    </#if>


      <h3>External Links</h3>
      <ul>
      <#list usage.identifiers as i>
        <#if i.identifierLink??>
          <li><a href="${i.identifierLink}" title="${i.title!i.type!i.identifier}">${i.title!i.type!i.identifier}</a></li>
        </#if>
      </#list>
      </ul>

      <#--
    <#if usage.link?has_content>
      <h3>External Links</h3>
      <ul>
        <li><a href="${usage.link}" title="Original source">Original source</a></li>
      </ul>
    </#if>
    -->
      <h3>Metadata</h3>
      <ul class="placeholder_temp">
        <li class="download">EML file &nbsp;<a class="small" href="#" title="EML file (english)">ENG</a> · <a
                class="small" href="#" title="EML file (spanish)">SPA</a> · <a class="small" href="#"
                                                                               title="EML file (german)">GER</a></li>
      </ul>
    </div>
  </div>
  <footer></footer>
</article>

<article class="taxonomies">
  <header></header>
  <div class="content">
    <h2>Taxonomy <span class="subtitle">of ${usage.scientificName}</span></h2>

    <div class="left">
      <h3>Taxonomic classification</h3>

      <!-- TODO: merge the classification here with the trail below into one! -->
      <div class="taxonomic_class">
        <ul class="taxonomy">

          <li><a href="#">All</a></li>
        <#assign classification=usage.higherClassificationMap />
        <#list classification?keys as key>
          <li <#if !key_has_next>class="last"</#if>><a
                  href="<@s.url value='/species/${key?c}'/>">${classification.get(key)}</a></li>
        </#list>
        </ul>
        <div class="extended">(<a href="/species/${id?c}/extended_taxonomy">extended</a>)</div>
      </div>

      <h3>Lower taxa</h3>

      <div id="taxonomy">
        <div class="inner">
          <div class="sp">
            <ul>
              <li data="40"><span>Animalia</span> <a href="<@s.url value='/species/123'/>">see details</a>
                <ul>
                  <li data="10"><span>Acantocephala</span> <a href="<@s.url value='/species/123'/>">see details</a></li>
                  <li data="90"><span>Annelida</span> <a href="<@s.url value='/species/123'/>">see details</a></li>
                  <li data="180"><span>Arthropoda</span><a href="<@s.url value='/species/123'/>">see details</a></li>
                  <li data="40"><span>Brachipoda</span><a href="<@s.url value='/species/123'/>">see details</a></li>
                  <li data="40"><span>Cephalorhyncha</span><a href="<@s.url value='/species/123'/>">see details</a></li>
                  <li data="20"><span>Chaetognatha</span><a href="<@s.url value='/species/123'/>">see details</a></li>
                  <li data="50"><span>Chordata</span><a href="<@s.url value='/species/123'/>">see details</a></li>
                  <li data="10"><span>Cnidaria</span><a href="<@s.url value='/species/123'/>">see details</a></li>
                  <li data="60"><span>Ctenophora</span><a href="<@s.url value='/species/123'/>">see details</a></li>
                </ul>
              </li>
              <li data="20"><span>Archaea</span><a href="<@s.url value='/species/123'/>">see details</a></li>
              <li data="10"><span>Bacteria</span><a href="<@s.url value='/species/123'/>">see details</a>
                <ul>
                  <li data="10"><span>Acidobacteria</span><a href="<@s.url value='/species/123'/>">see details</a></li>
                  <li data="90"><span>Actinobacteria</span><a href="<@s.url value='/species/123'/>">see details</a></li>
                  <li data="40"><span>Aquificae</span><a href="<@s.url value='/species/123'/>">see details</a></li>
                  <li data="40"><span>Bacteroidetes</span><a href="<@s.url value='/species/123'/>">see details</a></li>
                  <li data="10"><span>Acidobacteria</span><a href="<@s.url value='/species/123'/>">see details</a></li>
                  <li data="90"><span>Actinobacteria</span><a href="<@s.url value='/species/123'/>">see details</a></li>
                  <li data="40"><span>Aquificae</span><a href="<@s.url value='/species/123'/>">see details</a></li>
                  <li data="40"><span>Bacteroidetes</span><a href="<@s.url value='/species/123'/>">see details</a></li>
                  <li data="10"><span>Acidobacteria</span><a href="<@s.url value='/species/123'/>">see details</a></li>
                  <li data="90"><span>Actinobacteria</span><a href="<@s.url value='/species/123'/>">see details</a></li>
                  <li data="40"><span>Aquificae</span><a href="<@s.url value='/species/123'/>">see details</a></li>
                  <li data="40"><span>Bacteroidetes</span><a href="<@s.url value='/species/123'/>">see details</a></li>
                  <li data="10"><span>Acidobacteria</span><a href="<@s.url value='/species/123'/>">see details</a></li>
                  <li data="90"><span>Actinobacteria</span><a href="<@s.url value='/species/123'/>">see details</a></li>
                  <li data="40"><span>Aquificae</span><a href="<@s.url value='/species/123'/>">see details</a></li>
                  <li data="40"><span>Bacteroidetes</span><a href="<@s.url value='/species/123'/>">see details</a></li>
                  <li data="10"><span>Acidobacteria</span><a href="<@s.url value='/species/123'/>">see details</a></li>
                  <li data="90"><span>Actinobacteria</span><a href="<@s.url value='/species/123'/>">see details</a></li>
                  <li data="40"><span>Aquificae</span><a href="<@s.url value='/species/123'/>">see details</a></li>
                  <li data="40"><span>Bacteroidetes</span><a href="<@s.url value='/species/123'/>">see details</a></li>
                  <li data="10"><span>Acidobacteria</span><a href="<@s.url value='/species/123'/>">see details</a></li>
                  <li data="90"><span>Actinobacteria</span><a href="<@s.url value='/species/123'/>">see details</a></li>
                  <li data="40"><span>Aquificae</span><a href="<@s.url value='/species/123'/>">see details</a></li>
                  <li data="40"><span>Bacteroidetes</span><a href="<@s.url value='/species/123'/>">see details</a></li>
                  <li data="10"><span>Acidobacteria</span><a href="<@s.url value='/species/123'/>">see details</a></li>
                  <li data="90"><span>Actinobacteria</span><a href="<@s.url value='/species/123'/>">see details</a></li>
                  <li data="40"><span>Aquificae</span><a href="<@s.url value='/species/123'/>">see details</a></li>
                  <li data="40"><span>Bacteroidetes</span><a href="<@s.url value='/species/123'/>">see details</a></li>
                </ul>
              </li>
              <li data="90"><span>Chromista</span><a href="<@s.url value='/species/123'/>">see details</a></li>
              <li data="30"><span>Fungi</span><a href="<@s.url value='/species/123'/>">see details</a></li>
              <li data="50"><span>Plantae</span><a href="<@s.url value='/species/123'/>">see details</a>
                <ul>
                  <li data="10"><span>Anthocerotophyta</span><a href="<@s.url value='/species/123'/>">see details</a>
                    <ul>
                      <li data="80"><span>Anthocerotopsida</span><a href="<@s.url value='/species/123'/>">see
                        details</a>
                        <ul>
                          <li data="10"><span>Anthocerotales</span><a href="<@s.url value='/species/123'/>">see
                            details</a>
                            <ul>
                              <li data="10"><span>Anthocerotaceae</span><a href="<@s.url value='/species/123'/>">see
                                details</a>
                                <ul>
                                  <li data="10"><span>Anthoceros</span><a href="<@s.url value='/species/123'/>">see
                                    details</a>
                                  </li>
                                  <li data="90"><span>Phaeoceros</span><a href="<@s.url value='/species/123'/>">see
                                    details</a>
                                  </li>
                                </ul>
                              </li>
                            </ul>
                          </li>
                          <li data="20"><span>Codoniaceae</span><a href="<@s.url value='/species/123'/>">see details</a>
                          </li>
                          <li data="30"><span>Dendrocerotaceae</span><a href="<@s.url value='/species/123'/>">see
                            details</a></li>
                          <li data="60"><span>Notothyladaceae</span><a href="<@s.url value='/species/123'/>">see
                            details</a></li>
                        </ul>
                      </li>
                    </ul>
                  </li>
                  <li data="80"><span>Bacillariophyta</span><a href="<@s.url value='/species/123'/>">see details</a>
                  </li>
                  <li data="90"><span>Bryophyta</span><a href="<@s.url value='/species/123'/>">see details</a></li>
                  <li data="40"><span>Chlorophyta</span><a href="<@s.url value='/species/123'/>">see details</a></li>
                  <li data="20"><span>Cyanidiophyta</span><a href="<@s.url value='/species/123'/>">see details</a></li>
                  <li data="30"><span>Cycadophyta</span><a href="<@s.url value='/species/123'/>">see details</a></li>
                  <li data="80"><span>Bacillariophyta</span><a href="<@s.url value='/species/123'/>">see details</a>
                  </li>
                  <li data="90"><span>Bryophyta</span><a href="<@s.url value='/species/123'/>">see details</a></li>
                  <li data="40"><span>Chlorophyta</span><a href="<@s.url value='/species/123'/>">see details</a></li>
                  <li data="20"><span>Cyanidiophyta</span><a href="<@s.url value='/species/123'/>">see details</a></li>
                  <li data="30"><span>Cycadophyta</span><a href="<@s.url value='/species/123'/>">see details</a></li>
                </ul>
              </li>
              <li data="100"><span>Protozoa</span><a href="<@s.url value='/species/123'/>">see details</a></li>
              <li data="60"><span>Viruses</span><a href="<@s.url value='/species/123'/>">see details</a></li>
              </li>
            </ul>
          </div>
        </div>
      </div>

    </div>


    <div class="right">
    <#if (usage.synonyms?size>0)>
      <h3>Synonyms</h3>
      <ul class="no_bottom">
        <#list usage.synonyms as syn>
          <li><a href="<@s.url value='/species/${syn.key?c}'/>">${syn.scientificName}</a></li>
        <#-- only show 9 synonyms at max. If we have 10 (index=9) we know there are more to show -->
          <#if !syn_has_next && syn_index==9>
            <p><a class="more_link" href="<@s.url value='/species/${id?c}/synonyms'/>">see all</a></p>
          </#if>
        </#list>
      </ul>
    </#if>

      <h3>Children</h3>
      <ul class="no_bottom">
        <li>Temporary until browser works</li>
      <#list children as syn>
        <li><a href="<@s.url value='/species/${syn.key?c}'/>">${syn.scientificName}</a></li>
      </#list>
      </ul>

    </div>

  </div>
  <footer></footer>
</article>

<#if nub>
<#-- ONLY FOR NUB PAGES -->
<article class="map">
  <header></header>
  <div id="map"></div>
  <!-- map controls -->
  <a href="#zoom_in" class="zoom_in"></a>
  <a href="#zoom_out" class="zoom_out"></a>

  <div class="projection">
    <a class="projection" href="#projection">projection</a>
  <span>
    <p>PROJECTION</p>
    <ul>
      <li><a class="selected" href="#mercator">Mercator</a></li>
      <li class="disabled"><a href="#robinson">Robinson</a></li>
    </ul>
  </span>
  </div>
  <!-- end map controls -->
  <div class="content">

    <div class="header">
      <div class="right">
        <div class="big_number">
          <span>98,453</span>
          <a href="<@s.url value='/occurrence/search?q=holotype'/>">occurrences</a>
        </div>
        <div class="big_number">
          <span class="big_number">8,453</span>
          <a href="<@s.url value='/occurrence/search?q=holotype'/>">in the selected area</a>
        </div>
      </div>
    </div>

    <div class="right">
      <h3>Visualize</h3>

      <p class="maptype"><a href="#" title="points" class="selected">occurrence</a> | <a href="#"
                                                                                         title="grid">density</a> | <a
              href="#" title="polygons">distribution</a></p>

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
</#if>

<article id="slideshow-1" class="photo_gallery">
  <div class="content placeholder_temp">

    <div class="slideshow">
      <div class="photos"><img src="<@s.url value='/external/slideshow/001.jpg'/>"/><img
              src="<@s.url value='/external/slideshow/002.jpg'/>"/><img
              src="<@s.url value='/external/slideshow/003.jpg'/>"/><img
              src="<@s.url value='/external/slideshow/004.jpg'/>"/></div>
    </div>

    <div class="right">
      <div class="controllers">
        <h2>Puma Concolor in his natural habitat</h2>
        <a class="previous_slide" href="#" title="Previous image"></a>
        <a class="next_slide" href="#" title="Next image"></a>
      </div>

      <h3>Image publisher</h3>

      <p><a href="#" title="Wildscreen">Wildscreen</a></p>

      <h3>Dataset</h3>

      <p><a href="#" title="Arkive">Arkive</a></p>

      <h3>Photographer</h3>

      <p><a href="#" title="Kevin Huizenga">Kevin Huizenga</a></p>

      <h3>Copyright</h3>

      <p>All rights reserved</p>

    </div>
  </div>
  <footer></footer>
</article>

<article id="appearsin">
  <header></header>
  <div class="content placeholder_temp">
    <h2>Appears in</h2>

    <div class="left">
      <div class="col">
        <h3>Occurrences datasets</h3>
        <ul class="notes">
          <li><a href="<@s.url value='/dataset/456'/>">Macaulay Library</a> <span class="note">from Avian Knowledge Network</span>
          </li>
          <li><a href="<@s.url value='/dataset/456'/>">Macaulay Library</a> <span class="note">from Avian Knowledge Network</span>
          </li>
          <li><a href="<@s.url value='/dataset/456'/>">Macaulay Library</a> <span class="note">from Avian Knowledge Network</span>
          </li>
          <li><a href="<@s.url value='/dataset/456'/>">Macaulay Library</a> <span class="note">from Avian Knowledge Network</span>
          </li>
          <li><a href="<@s.url value='/dataset/456'/>">Macaulay Library</a> <span class="note">from Avian Knowledge Network</span>
          </li>
          <li><a href="<@s.url value='/dataset/456'/>">Macaulay Library</a> <span class="note">from Avian Knowledge Network</span>
          </li>
        </ul>
        <p><a class="more_link" href="<@s.url value='/dataset/search?q=fake'/>">and 23 more</a></p>
      </div>

      <div class="col">
        <h3>Checklists</h3>
        <ul class="notes">
          <li><a href="<@s.url value='/dataset/1'/>">Fauna Europea</a> <span
                  class="note">from University of Alaska Museum</span></li>
          <li><a href="<@s.url value='/dataset/1'/>">Fauna Europea</a> <span
                  class="note">from University of Alaska Museum</span></li>
          <li><a href="<@s.url value='/dataset/1'/>">Fauna Europea</a> <span
                  class="note">from University of Alaska Museum</span></li>
          <li><a href="<@s.url value='/dataset/1'/>">Fauna Europea</a> <span
                  class="note">from University of Alaska Museum</span></li>
          <li><a href="<@s.url value='/dataset/1'/>">Fauna Europea</a> <span
                  class="note">from University of Alaska Museum</span></li>
          <li><a href="<@s.url value='/dataset/1'/>">Fauna Europea</a> <span
                  class="note">from University of Alaska Museum</span></li>
        </ul>
        <p><a class="more_link" href="<@s.url value='/dataset/search?q=fake'/>">and 2 more</a></p>
      </div>
    </div>

    <div class="right">
      <h3>By occurrences hosting</h3>
      <ul>
        <li><a href="<@s.url value='/dataset/search?q=fake'/>">13 occurrence datasets</a></li>
        <li><a href="<@s.url value='/dataset/search?q=fake'/>">2 external datasets</a></li>
      </ul>
      <h3>By checklist type</h3>
      <ul>
        <li><a href="<@s.url value='/dataset/search?q=fake'/>">13 nomenclator</a></li>
        <li><a href="<@s.url value='/dataset/search?q=fake'/>">2 reconciled</a></li>
      </ul>

    </div>

  </div>
  <footer></footer>
</article>

<#if !nub>
<#-- ONLY FOR CHECKLIST PAGES -->
<article id="typespecimen">
  <header></header>
  <div class="content placeholder_temp">
    <h2>Type specimens</h2>

    <div class="left">
      <div class="col">
        <div>
          <p class="no_bottom"><a href="<@s.url value='/occurrence/789'/>">Puma concolor - ANSP HRP 10</a> <a href="#"
                                                                                                               title="Help"
                                                                                                               id="help2"><img
                  src="<@s.url value='/img/icons/questionmark.png'/>"/></a></p>

          <p class="note semi_bottom">Syntype by original designation</p>

          <p class="light_note">Iraq: Mosul: Jabal Khantur prope Sharanish N. Zakho, in fissures rupium calc., 1200 m,
            Rech. 12083 (W!).</p>
        </div>

        <div>
          <p class="no_bottom"><a href="<@s.url value='/occurrence/789'/>">Puma concolor - ANSP HRP 10</a> <a href="#"
                                                                                                               title="Help"
                                                                                                               id="help"><img
                  src="<@s.url value='/img/icons/questionmark.png'/>"/></a></p>

          <p class="note semi_bottom">Syntype by original designation</p>

          <p class="light_note">Iraq: Mosul: Jabal Khantur prope Sharanish N. Zakho, in fissures rupium calc., 1200 m,
            Rech. 12083 (W!).</p>
        </div>

        <p><a class="more_link" href="<@s.url value='/occurrence/search?q=holotype'/>">and 23 more</a></p>
      </div>

      <div class="col">
        <div>
          <p class="no_bottom"><a href="<@s.url value='/occurrence/789'/>">Puma concolor - ANSP HRP 10</a> <a href="#"
                                                                                                               title="Help"
                                                                                                               id="help4"><img
                  src="<@s.url value='/img/icons/questionmark.png'/>"/></a></p>

          <p class="note semi_bottom">Syntype by original designation</p>

          <p class="light_note">Iraq: Mosul: Jabal Khantur prope Sharanish N. Zakho, in fissures rupium calc., 1200 m,
            Rech. 12083 (W!).</p>
        </div>

        <div>
          <p class="no_bottom"><a href="<@s.url value='/occurrence/789'/>">Puma concolor - ANSP HRP 10</a> <a href="#"
                                                                                                               title="Help"
                                                                                                               id="help3"><img
                  src="<@s.url value='/img/icons/questionmark.png'/>"/></a></p>

          <p class="note semi_bottom">Syntype by original designation</p>

          <p class="light_note">Iraq: Mosul: Jabal Khantur prope Sharanish N. Zakho, in fissures rupium calc., 1200 m,
            Rech. 12083 (W!).</p>
        </div>

      </div>
    </div>

    <div class="right">
      <h3>Specimens by type</h3>
      <ul>
        <li><a href="<@s.url value='/occurrence/search?q=syntype'/>">13 syntypes</a></li>
      </ul>
    </div>

  </div>
  <footer></footer>
</article>
</#if>

<article id="distribution">
  <header></header>
  <div class="content">
    <h2>${usage.canonicalName!usage.scientificName} distribution</h2>

    <div class="left">
      <div class="col">
        <ul class="notes">
        <#list usage.distributions as d>
          <#if (d_index % 2) == 0>
            <div>
              <p class="no_bottom">
                <a href="#">${d.locationId!} ${d.country!} ${d.locality!} ${d.temporal!}</a>
                <#if d.source?has_content>
                  <a class="sourcePopup" id="source${d.key?c}" source="${d.source}" remarks="${d.remarks!}"></a>
                </#if>
              </p>
              <p class="note semi_bottom">${d.lifeStage!} ${d.status!"Present"} ${d.threatStatus!} ${d.establishmentMeans!} ${d.appendixCites!}</p>
            </div>
          </#if>
          <#-- only show 10 distributions at max. If we have 10 (index=9) we know there are more to show -->
          <#if !d_has_next>
            </ul>
            <#if d_index==9>
              <p><a class="more_link" href="<@s.url value='/species/${id?c}/distributions'/>">see all</a></p>
            </#if>
          </#if>
        </#list>
      </div>

      <div class="col">
        <ul class="notes">
        <#list usage.distributions as d>
          <#if (d_index % 2) == 1>
            <div>
              <p class="no_bottom">
                <a href="#">${d.locationId!} ${d.country!} ${d.locality!} ${d.temporal!}</a>
                <#if d.source?has_content>
                  <a class="sourcePopup" id="source${d.key?c}" source="${d.source}" remarks="${d.remarks!}"></a>
                </#if>
              </p>
              <p class="note semi_bottom">${d.lifeStage!} ${d.status!"Present"} ${d.threatStatus!} ${d.establishmentMeans!} ${d.appendixCites!}</p>
            </div>
          </#if>
        </#list>
        </ul>
      </div>
    </div>

    <div class="right">
      <h3>References by continent</h3>
      <ul class="placeholder_temp">
        <li>Europe <a class="number">200</a></li>
        <li>America <a class="number">32</a></li>
        <li>Asia <a class="number">152</a></li>
      </ul>
    </div>

  </div>
  <footer></footer>
</article>

<article id="references">
  <header></header>
  <div class="content">
    <h2>Academic references</h2>

    <div class="left">
      <h3>Published In</h3>

      <p>${usage.publishedIn!"?"}</p>

      <h3>According to</h3>

      <p>${usage.accordingTo!"?"}</p>

      <h3>Review date</h3>

      <p class="placeholder_temp">Oct 28, 2003</p>

     <#if (usage.references?size>0)>
      <h3>Bibliography</h3>
      <#list usage.references as ref>
        <p>
          <#if ref.link?has_content><a href="${ref.link}">${ref.citation}</a><#else>${ref.citation}</#if>
          <#if ref.doi?has_content><br/>DOI:<a href="http://dx.doi.org/${ref.doi}">${ref.doi}</a></#if>
        </p>
      <#-- only show 9 references at max. If we have 10 (index=9) we know there are more to show -->
        <#if !ref_has_next && ref_index==9>
          <p><a class="more_link" href="<@s.url value='/usage/${id?c}/references'/>">see all</a></p>
        </#if>
      </#list>
    </#if>
    </div>

    <div class="right">
    </div>

  </div>
  <footer></footer>
</article>

<article class="notice">
  <header></header>
  <div class="content">
    <h3>Further information</h3>

    <p>There may be more details available about this name usage in the
      <a href="<@s.url value='/species/${id?c}/name_usage_raw'/>">verbatim version</a> of the record</p>
  </div>
  <footer></footer>
</article>

</body>
</html>
