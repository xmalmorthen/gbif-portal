<#import "/WEB-INF/macros/common.ftl" as common>
<html>
<head>
  <title>${usage.scientificName} - Checklist View</title>
  <meta name="menu" content="species"/>
  <content tag="extra_scripts">
    <script src="<@s.url value='/js/full_map.js'/>"></script>
    <script type="text/javascript">
      $(function() {
        $("article#images").bindSlideshow();
      });
    </script>
  </content>
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
        <#list usage.images as img>
          <#if img_index==3 || !img_has_next>
            <#assign lastClass="last"/>
          </#if>
          <li class="${lastClass!""}"><a href="#" class="images"><span><img src="${img.thumbnail!img.image!"image missing url"}"/></span></a></li>
          <#if img_index==3>
            <#break>
          </#if>
        </#list>
      </ul>

      <h3>Full name</h3>
      <p>${usage.scientificName}</p>

      <#if usage.taxonomicStatus??>
        <h3>Status</h3>
        <p>${usage.taxonomicStatus}</p>
      </#if>

      <h3>Living period</h3>
      <p class="placeholder_temp">Quaternary.</p>

      <h3>Habitat</h3>

      <p class="placeholder_temp">Pre-cordilleran steppe.</p>

    <#list usage.descriptions as d>
      <h3>${d.type!"Description"}
        <#if d.source?has_content>
          <a class="sourcePopup" id="source${d.key?c}" source="${d.source}" remarks="${d.remarks!}"></a>
        </#if>
      </h3>
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
            <li>${v.vernacularName} <span class="small">${v.language!}</span></li>
          </#if>
          <#if v_index==8>
            <#assign more=true/>
            <#break />
          </#if>
        </#list>
        </ul>
        <#if more>
          <p><a class="more_link" href="<@s.url value='/species/${id?c}/vernacularnames'/>">see all</a></p>
        </#if>
      </#if>
    <#if basionym?has_content>
      <h3>Original Name</h3>

      <p>${basionym.scientificName}</p>
    </#if>


      <h3>External Links</h3>
      <ul>
      <#list usage.identifiers as i>
        <#if i.identifierLink??>
          <li><a href="${i.identifierLink}" title="${i.title!i.type!i.identifier}"><#if i.title?has_content>${i.title}<#else><@s.text name="enum.identifier.${i.type!'URL'}" /></#if></a></li>
        </#if>
      </#list>
      <#if usage.nubKey??>
        <li><a href=" http://eol.org/gbif/${usage.nubKey?c}" title="EOL">EOL</a></li>
      </#if>
        <li><a href="http://ecat-dev.gbif.org/usage/${usage.key?c}" title="ECAT Portal">ECAT Portal</a></li>
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
      <h3>Taxonomic classification  <div class="extended">[<a href="<@s.url value='/species/${id?c}/extended_taxonomy'/>">extended</a>]</div></h3> 


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
      </div>

      <h3>Taxonomic Classification1</h3>

      <div id="taxonomy">
      	<div class="breadcrumb">
			<li><a href="#">All</a></li>
			<#assign classification=usage.higherClassificationMap />
	        <#list classification?keys as key>
				<li spid="${key?c}"><a href="#">${classification.get(key)}</a></li>
	        </#list>
      	</div>
        <div class="inner">
          <div class="sp">
            <ul>
			  <#list children as usage>
			    <li species="${usage.numSpecies?c}" children="${usage.numChildren?c}"><span spid="${usage.key?c}" taxonID="${usage.key?c}">${usage.canonicalName}</span><a href="<@s.url value='http://staging.gbif.org:8080/portal-web-dynamic/species/${usage.key?c}'/>">see details</a>
			  	</li>			  	
			  </#list>  
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
<article class="map placeholder_temp">
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

<#if (usage.images?size>0)>
<article id="images" class="photo_gallery">
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
        <h2>${common.limit(img1.title!img1.description!usage.canonicalName!"",38)}</h2>
        <a class="previous_slide" href="#" title="Previous image"></a>
        <a class="next_slide" href="#" title="Next image"></a>
      </div>

      <#if img1.description?has_content>
      <h3>Description</h3>
      <p>${common.limit(img1.description!img1.title!"",250)}</p>
      </#if>

      <#if img1.publisher?has_content>
      <h3>Image publisher</h3>
      <p>${img1.publisher!"???"}</p>
      </#if>

      <#if img1.checklistName?has_content>
      <h3>Dataset</h3>
      <p>${img1.checklistName!"???"}</p>
      </#if>

      <#if (img1.creator!img1.created)?has_content>
      <h3>Photographer</h3>
        <p>${img1.creator!"???"}<#if img1.created??>, ${img1.created?date?string.short}</#if></p>
      </#if>

      <#if img1.license?has_content>
      <h3>Copyright</h3>
      <p>${img1.license}</p>
      </#if>

      </#if>
    </div>
  </div>
  <footer></footer>
</article>
</#if>

<article id="appearsin">
  <header></header>
  <div class="content">
    <h2>Appears in</h2>

    <div class="left">
      <div class="col placeholder_temp">
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
        <#if usage.nubKey??>
          <ul class="notes">
            <#assign more=false/>
            <#list related as rel>
              <#if rel_index==6>
                <#assign more=true/>
                <#break />
              </#if>
              <li><a href="<@s.url value='/species/${rel.key?c}'/>">${checklists.get(rel.checklistKey).name}</a> <span class="note">${rel.scientificName}</span></li>
            </#list>
          </ul>
          <#if more>
            <p><a class="more_link" href="<@s.url value='/species/search?nubKey=${usage.nubKey?c}&checklistKey=all'/>">see all</a></p>
          </#if>
        </#if>
      </div>
    </div>

    <div class="right placeholder_temp">
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

<#if (usage.distributions?size>0)>
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
                  <a class="sourcePopup" id="source${d.key?c}" source="source${d.key?c} - ${d.source}" remarks="remark - ${d.remarks!}"></a>
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
</#if>

<#if usage.publishedIn?has_content || usage.accordingTo?has_content || (usage.references?size>0)>
<article id="references">
  <header></header>
  <div class="content">
    <h2>Academic references</h2>

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
</#if>

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
