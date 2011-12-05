<#import "/WEB-INF/macros/common.ftl" as common>
<#import "/WEB-INF/macros/specimen/specimenRecord.ftl" as specimenRecord>
<html>
<head>
  <title>${usage.scientificName} - Checklist View</title>
  <meta name="menu" content="species"/>
  <content tag="extra_scripts">
    <#if nub>
      <link rel="stylesheet" href="<@s.url value='/css/google.css'/>"/>
      <script type="text/javascript" src="http://maps.google.com/maps/api/js?v=3.2&amp;sensor=true"></script>
      <script type="text/javascript" src="<@s.url value='/js/vendor/OpenLayers.js'/>"></script>
      <script type="text/javascript" src="<@s.url value='/js/openlayers_addons.js'/>"></script>
      <script type="text/javascript" src="<@s.url value='/js/Infowindow.js'/>"></script>
      <script type="text/javascript" src="<@s.url value='/js/types_map.js'/>"></script>
    </#if>
  </content>
</head>
<body class="species typesmap">

<#assign tab="info"/>
<#include "/WEB-INF/pages/species/infoband.ftl">

<#if !nub>
<#-- ONLY FOR CHECKLIST PAGES -->
<article class="notice">
  <header></header>
  <div class="content">
    <h3>This is a particular view of ${usage.canonicalOrScientificName!}</h3>

    <p>This is the <em>${usage.scientificName}</em> view, as seen by <a
            href="<@s.url value='/dataset/${checklist.key}'/>">${checklist.name!"???"}</a> checklist.
      <#if usage.nubKey?exists>
        Remember that you can also check the <a href="<@s.url value='/species/${usage.nubKey?c}'/>">GBIF view
        on ${usage.canonicalOrScientificName!}</a>.
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
      <div class="left"><h2><a name="overview">Overview</a></h2></div>
    </div>

    <div class="left">
      <ul class="thumbs_list">
      <#list usage.images as img>
        <#if img_index==3 || !img_has_next>
          <#assign lastClass="last"/>
        </#if>
        <li class="${lastClass!""}"><a href="#" class="images"><span><img
                src="${img.thumbnail!img.image!"image missing url"}"/></span></a></li>
        <#if img_index==3>
          <#break>
        </#if>
      </#list>
      </ul>

      <h3>Full name</h3>
      <p>${usage.scientificName}</p>

      <h3>Status</h3>
      <p>
        ${usage.taxonomicStatus!"Unknown"}
        ${usage.nomenclaturalStatus!""}
        <#if usage.synonym> of <a href="<@s.url value='/species/${usage.acceptedKey?c}'/>">${usage.accepted!"???"}</a></#if>
      </p>

    <#if usage.speciesProfiles?? && usage.speciesProfiles[0]??>
      <#assign sp = usage.speciesProfiles[0]/>
    </#if>
    <#if sp??>
      <#if sp.livingPeriod?has_content>
        <h3>Living period</h3>
        <p>${sp.livingPeriod}</p>
      </#if>

      <#if sp.isExtinct()??>
        <h3>Extinction Status</h3>
        <p>${sp.isExtinct()?string("Is Extinct","Is Not Extinct")}</p>
      </#if>

      <#if sp.habitat?? && sp.habitat != ''>
        <h3>Habitat</h3>
        <p>${sp.habitat}</p>
      </#if>
    </#if>

    <#list usage.descriptions as d>
      <h3>${d.type!"Description"} <@common.usageSource component=d showChecklistSource=nub /></h3>
      <p>${d.description!}</p>
    </#list>

    </div>
    <div class="right">
    <#if (usage.vernacularNames?size>0)>
      <h3>Common names</h3>
      <ul>
        <#assign more=false/>
        <#list usage.vernacularNames as v>
          <#if v.vernacularName?has_content>
            <li>${v.vernacularName} <span class="small">${v.language!}</span> <@common.usageSource component=v showChecklistSource=nub /> </li>
          </#if>
          <#if v_index==8>
            <#assign more=true/>
            <#break />
          </#if>
        </#list>
      </ul>
      <#if more>
        <p><a class="more_link" href="<@s.url value='/species/${id?c}/vernaculars'/>">see all</a></p>
      </#if>
    </#if>

    <#if basionym?has_content>
      <h3>Original Name</h3>
      <p><a href="<@s.url value='/species/${basionym.key?c}'/>">${basionym.scientificName}</a></p>
    </#if>

      <h3>External Links</h3>
      <ul>
      <#list usage.identifiers as i>
        <#if i.identifierLink??>
          <li><a href="${i.identifierLink}"
                 title="${i.title!i.type!i.identifier}"><#if i.title?has_content>${i.title}<#else><@s.text name="enum.identifier.${i.type!'URL'}" /></#if></a>
          </li>
        </#if>
      </#list>
      <#if usage.nubKey??>
        <li><a href=" http://eol.org/gbif/${usage.nubKey?c}" title="EOL">EOL</a></li>
      </#if>
        <li><a href="http://ecat-dev.gbif.org/usage/${usage.key?c}" title="ECAT Portal">ECAT Portal</a></li>
      </ul>

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
    <h2><a name="taxonomy">Taxonomy</a> <span class="subtitle">of ${usage.scientificName}</span></h2>

    <div class="left">
      <h3>Taxonomic classification
        <div class="extended">[<a href="<@s.url value='/species/${id?c}/classification'/>">extended</a>]</div>
      </h3>
	<#include "/WEB-INF/pages/species/taxbrowser.ftl">
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

    </div>

  </div>
  <footer></footer>
</article>

<#if nub>
<#-- ONLY FOR NUB PAGES -->
<article class="map">
  <header></header>
  <div id="map" nubid="${usage.key?c}"></div>
  <a href="#zoom_in" class="zoom_in"></a>
  <a href="#zoom_out" class="zoom_out"></a>

  <div class="projection placeholder_temp">
    <a class="projection" href="#projection">projection</a>
  <span>
    <p>PROJECTION</p>
    <ul>
      <li><a class="selected" href="#mercator">Mercator</a></li>
      <li class="disabled"><a href="#robinson">Robinson</a></li>
    </ul>
  </span>
  </div>
      <#--
       dont use vizzuality openlayers map for now, so dont show mapa controls
  -->
  <div class="content">

    <div class="header">
      <div class="right">
        <div class="big_number">
          <span>${usage.numOccurrences!0}</span>
          <a href="<@s.url value='/occurrence/search?q=holotype'/>">occurrences</a>
        </div>
        <div class="big_number placeholder_temp">
          <span class="big_number">8,453</span>
          <a href="<@s.url value='/occurrence/search?q=holotype'/>">in the selected area</a>
        </div>
      </div>
    </div>

    <div class="right">
      <h3>Visualize</h3>

      <p class="maptype">
          <a href="#" title="occurrence" class="selected">occurrence</a>
        | <a class="placeholder_temp" href="#" title="diversity">diversity</a>
        | <a class="placeholder_temp" href="#" title="distribution">distribution</a>
      </p>

      <h3>Download</h3>
      <ul class="placeholder_temp">
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

<#if (usage.images?size>0)>
<article id="images" class="photo_gallery">
  <a name="images"></a>
  <div class="content">

    <div class="slideshow">
      <div class="photos">
        <#list usage.images as img>
          <#if img.image??>
            <#if !img1?exists><#assign img1=img/></#if>
            <img src="${img.image!}"/>
          </#if>
        </#list>
      </div>
    </div>

  <#-- <a href="${img1.image}"><img src="${img.image!}"/></a> -->

    <div class="right">
      <#if img1?exists>
        <div class="controllers">
          <h2>${common.limit(img1.title!usage.canonicalOrScientificName!"",38)}</h2>
          <a class="previous_slide" href="#" title="Previous image"></a>
          <a class="next_slide" href="#" title="Next image"></a>
        </div>

        <#if img1.description?has_content>
          <h3>Description</h3>
          <p>${common.limit(img1.description!img1.title!"",100)}
            <#if (img1.description?length>100) ><@common.popup message=img1.description title=img1.title!"Description"/></#if>
          </p>
        </#if>

        <#if nub>
          <h3>Dataset</h3>
          <p><a href="<@s.url value='/species/${img1.usageKey}'/>">${checklists.get(img1.checklistKey).name}</a></p>
        </#if>

        <#if img1.publisher?has_content>
          <h3>Image publisher</h3>
          <p>${img1.publisher!"???"}</p>
        </#if>

        <#if (img1.creator!img1.created)?has_content>
          <h3>Photographer</h3>
          <p>${img1.creator!"???"}<#if img1.created??>, ${img1.created?date?string.short}</#if></p>
        </#if>

          <h3>Copyright</h3>
          <p>${img1.license!"No license"}</p>

      </#if>
    </div>
  </div>
  <footer></footer>
</article>
</#if>

<#if usage.nubKey??>
<article id="appearsin">
  <header></header>
  <div class="content">
    <h2><a name="related">Appears in</a></h2>

    <div class="left">
      <div class="col">
        <h3>Occurrences datasets</h3>
        <ul class="notes">
        <#assign more=false/>
        <#list relatedDatasets as uuid>
          <#if uuid_index==6>
            <#assign more=true/>
            <#break />
          </#if>
          <li><a href="<@s.url value='/dataset/${uuid}'/>">${uuid}</a> <span class="note placeholder_temp">from Avian Knowledge Network <a href="http://gbrds.gbif.org/browse/agent?uuid=${uuid}">GBRDS</a></span></li>
        </#list>
        </ul>
        <#if more>
          <p><a class="more_link" href="<@s.url value='/dataset/search?nubKey=${usage.nubKey?c}&type=occurrence'/>">see all</a></p>
        </#if>
      </div>

      <div class="col">
        <h3>Checklists</h3>
        <ul class="notes">
          <#assign more=false/>
          <#list related as rel>
            <#if rel_index==6>
              <#assign more=true/>
              <#break />
            </#if>
            <li><a href="<@s.url value='/species/${rel.key?c}'/>">${checklists.get(rel.checklistKey).name}</a> <span
                    class="note">${rel.scientificName}</span></li>
          </#list>
        </ul>
        <#if more>
          <p><a class="more_link" href="<@s.url value='/species/search?nubKey=${usage.nubKey?c}&checklistKey=all'/>">see all</a></p>
        </#if>
      </div>
    </div>

    <div class="right">
      <h3>By dataset type</h3>
      <ul>
        <li><a href="<@s.url value='/dataset/search?nubKey=${usage.nubKey?c}&type=occurrence'/>">${relatedDatasets?size} occurrence datasets</a></li>
        <li><a href="<@s.url value='/dataset/search?nubKey=${usage.nubKey?c}&type=checklist'/>">${related?size} checklist datasets</a></li>
        <li class="placeholder_temp"><a href="<@s.url value='/dataset/search?q=fake'/>">2 external datasets</a></li>
      </ul>
      <h3>By checklist type</h3>
      <ul class="placeholder_temp">
        <li><a href="<@s.url value='/dataset/search?q=fake'/>">13 inventory</a></li>
        <li><a href="<@s.url value='/dataset/search?q=fake'/>">3 taxonomic</a></li>
        <li><a href="<@s.url value='/dataset/search?q=fake'/>">1 nomenclator</a></li>
      </ul>

    </div>

  </div>
  <footer></footer>
</article>
</#if>

<#if (usage.typeSpecimens?size>0)>
<article id="typespecimen">
  <header></header>
  <div class="content">
    <h2><a name="typespecimenName">Type specimens</a></h2>
    <#-- only show 4 type specimens at max -->
    <#assign maxRecords=4>
    <div class="left">
      <#list usage.typeSpecimens as ts>
          <div class="col">
            <@specimenRecord.record ts=ts showAsSearchResult=false />
          </div>
          <#-- If we have 4 (index=3) we know there are more to show -->
          <#if (ts_index = maxRecords-1)>
            <p>
              <a class="more_link" href="<@s.url value='/species/${id?c}/typespecimens'/>">see all</a>
            </p>
            <#break>
          </#if>
      </#list>
    </div>
    <div class="right">
      <h3>Specimens by type</h3>
      <ul>
      <#list typeStatusCounts?keys as prop>
        <li>${prop} <a class="number">${typeStatusCounts.get(prop)}</a></li>
      </#list>
      </ul>
    </div>
  </div>
  <footer></footer>
</article>
</#if>

<#if (usage.distributions?size>0)>
<article id="distribution">
  <header></header>
  <div class="content">
    <h2><a name="distribution">${usage.canonicalOrScientificName!} distribution</a></h2>

    <div class="left">
      <div class="col">
      <ul class="notes">
        <#list usage.distributions as d>
          <#if (d_index % 2) == 0>
            <div>
              <p class="no_bottom">
                <a href="#">${d.locationId!} ${d.country!} ${d.locality!} ${d.temporal!}</a>
                <@common.usageSource component=d showChecklistSource=nub />
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
                  <@common.usageSource component=d showChecklistSource=nub />
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
</#if>

<#if usage.publishedIn?has_content || usage.accordingTo?has_content || (usage.references?size>0)>
<article id="references">
  <header></header>
  <div class="content">
    <h2><a name="typespecimen">Academic references</a></h2>

    <div class="left">
      <#if usage.publishedIn?has_content>
        <h3>Published In</h3>

        <p>${usage.publishedIn}</p>
      </#if>

      <#if usage.accordingTo?has_content>
        <h3>According to</h3>

        <p>${usage.accordingTo}</p>
      </#if>

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
          <#if ref_index==7>
            <p><a class="more_link" href="<@s.url value='/species/${id?c}/references'/>">see all</a></p>
            <#break />
          </#if>
        </#list>
      </#if>
    </div>

    <div class="right">
      <h3>References by type</h3>
      <ul class="placeholder_temp">
        <li>Nomenclature <a class="number">3</a></li>
        <li>Taxonomy <a class="number">6</a></li>
        <li>Genetics <a class="number">2</a></li>
      </ul>
    </div>

  </div>
  <footer></footer>
</article>
</#if>

<article class="notice">
  <header></header>
  <div class="content">
    <h3>Further information</h3>

    <p>There may be more details available about this name usage in the
      <a href="<@s.url value='/species/${id?c}/verbatim'/>">verbatim version</a> of the record</p>
  </div>
  <footer></footer>
</article>

</body>
</html>
