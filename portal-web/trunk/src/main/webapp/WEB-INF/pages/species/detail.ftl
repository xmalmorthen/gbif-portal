<#import "/WEB-INF/macros/common.ftl" as common>
<#import "/WEB-INF/macros/specimen/specimenRecord.ftl" as specimenRecord>
<html>
<head>
  <title>${usage.scientificName} - Checklist View</title>

  <content tag="extra_scripts">
  <#if nub>
    <link rel="stylesheet" href="<@s.url value='/js/vendor/leaflet/leaflet.css'/>" />
    <!--[if lte IE 8]><link rel="stylesheet" href="<@s.url value='/js/vendor/leaflet/leaflet.ie.css'/>" /><![endif]-->
    <script type="text/javascript" src="<@s.url value='/js/vendor/leaflet/leaflet.js'/>"></script>
    <script type="text/javascript" src="<@s.url value='/js/map.js'/>"></script>
  </#if>
    <script type="text/javascript">
      // taxonomic tree state
      var $taxoffset= 0, loadedAllChildren=false;

      function renderUsages($ps, data){
        // hide loading wheel
        $ps.find(".loadingTaxa").fadeOut("slow");
        $(data.results).each(function() {
          var speciesLink = "<@s.url value='/species/'/>" + this.key;
          $htmlContent = '<li spid="' + this.key + '">';
          $htmlContent += '<span class="sciname"><a href="'+speciesLink+'">' + canonicalOrScientificName(this) + "</a></span>";
          $htmlContent += '<span class="rank">' + $i18nresources.getString("enum.rank." + (this.rank || "unknown")) + "</span>";
          if (this.numDescendants>0) {
            $htmlContent += '<span class="count">' + addCommas(this.numDescendants) + " descendants</span>";
          }
          $htmlContent += '</span></li>';
          $ps.find(".sp ul").append($htmlContent);
        })
      };

      // Function for loading and rendering children
      function loadChildren() {
        $ps=$("#taxonomicChildren");
        var $wsUrl = cfg.wsClb + "name_usage/${id?c}/children?offset=" + $taxoffset + "&limit=25";
        // show loading wheel
        $ps.find(".loadingTaxa").show();
        //get the new list of children
        $.getJSON($wsUrl + '&callback=?', function(data) {
          renderUsages($ps, data);
          loadedAllChildren=data.endOfRecords;
        });
        $taxoffset += 25;
      }

      function loadDescription($descriptionKeys){
        var keys = $descriptionKeys.split(' ');
        // remove current description
        $("#description div.inner").empty();
        $.each(keys, function(index, k) {
          var key = $.trim(k);
          if (key) {
            var $wsUrl = cfg.wsClb + "description/" + key;
            $.getJSON($wsUrl + '?callback=?', function(data) {
              $htmlContent = '<p id="descriptionSrc'+index+'" class="note"><strong>Source</strong>: </p>';
              $htmlContent += "<h3>"+(data.type || "Description") +"</h3>";
              $htmlContent += "<p>"+data.description+"</p><br/><br/>";
              $("#description div.inner").append($htmlContent);
              if (data.source) {
                $("#descriptionSrc"+index).append(data.source);
              } else {
                <#if nub>
                  $.getJSON(cfg.wsReg + "dataset/" + data.datasetKey + "?callback=?", function(dataset) {
                    $("#descriptionSrc"+index).append(dataset.title);
                  });
                <#else>
                  $("#descriptionSrc"+index).hide();
                </#if>
              }
            });
          }
        })
      }

      $(function() {
        loadChildren();
        $("#taxonomicChildren .inner").scroll(function(){
          var triggerHeight = $("#taxonomicChildren .sp").height() - $(this).height() - 100;
          if (!loadedAllChildren && $("#taxonomicChildren .inner").scrollTop() > triggerHeight){
            loadChildren();
          }
        });

        var firstDescr = $("#description span.language:first");
        if (firstDescr.length > 0) {
          loadDescription(firstDescr.attr("descriptionKeys"));
        };
        $("#description span.language").click(function() {
          loadDescription( $(this).attr("descriptionKeys") );
        });
        // adjust description height to ToC
        var tocHeight = $("#description div.right").height() - 5;
        console.debug(tocHeight);
        if (tocHeight > 350) {
          $("#description div.inner").height(tocHeight);
        }

      });
    </script>
  </content>
<#-- RDFa -->
  <meta property="dwc:scientificName" content="${usage.scientificName!}"/>
  <meta property="dwc:kingdom" content="${usage.kingdom!}"/>
  <meta property="dwc:datasetID" content="${usage.datasetKey}"/>
  <meta property="dwc:datasetName" content="${(dataset.title)!"???"}"/>
  <meta rel="dc:isPartOf" href="<@s.url value='/dataset/${usage.datasetKey}'/>"/>
</head>
<body class="species densitymap">

<#assign tab="info"/>
<#include "/WEB-INF/pages/species/inc/infoband.ftl">

<#if !nub>
<#-- Warn that this is not a nub page -->
<@common.notice title="This is a particular view of ${usage.canonicalOrScientificName!}">
  <p>This is the <em>${usage.scientificName}</em> view,
    as seen by <a href="<@s.url value='/dataset/${usage.datasetKey}'/>">${(dataset.title)!"???"}</a> checklist.
    <#if usage.nubKey?exists>
      Remember that you can also check the
      <a href="<@s.url value='/species/${usage.nubKey?c}'/>">GBIF view on ${usage.canonicalOrScientificName!}</a>.
    </#if>
    <br/>
    <#if usage.origin! == "SOURCE">
      You can also see the <a href="<@s.url value='/species/${id?c}/verbatim'/>">verbatim version</a>
      submitted by the data publisher.
    <#else>
      This record has been created during indexing and did not explicitly exist in the source data as such.
      It was created as <@s.text name="enum.origin.${usage.origin}"/>.
    </#if>

  </p>
</@common.notice>
</#if>

<@common.article id="overview" title="Overview">
<div class="left">

  <div class="col">
    <h3>Full Name</h3>
    <p>${usage.scientificName}</p>

    <#if vernacularNames?has_content>
      <h3>Common names</h3>
      <ul>
        <#list vernacularNames?keys as vk>
          <#assign names=vernacularNames.get(vk)/>
          <#assign v=names[0]/>
          <li>${v.vernacularName} <span class="small">${v.language!}</span>
            <@common.usageSources components=names showSource=!usage.isNub() showChecklistSource=usage.isNub() />
          </li>
          <#if vk_has_next && vk_index==2>
            <li><a class="more_link" href="<@s.url value='/species/${id?c}/vernaculars'/>">see all</a></li>
            <#break />
          </#if>
        </#list>
      </ul>
    </#if>

    <#if (usage.synonyms?size>0)>
      <h3>Synonyms</h3>
      <ul class="no_bottom">
        <#list usage.synonyms as syn>
          <li><a href="<@s.url value='/species/${syn.key?c}'/>">${syn.scientificName}</a></li>
          <#-- only show 5 synonyms at max -->
          <#if syn_has_next && syn_index==4>
            <li><a class="more_link" href="<@s.url value='/species/${id?c}/synonyms'/>">see all</a></li>
            <#break />
          </#if>
        </#list>
      </ul>
    </#if>

  </div>

  <div class="col">
    <#if usage.publishedIn?has_content>
      <h3>Published In</h3>
      <p>${usage.publishedIn}</p>
    </#if>

    <h3>Taxonomic Status</h3>
    <p>
      <@s.text name="enum.taxstatus.${usage.taxonomicStatus!'UNKNOWN'}"/>
      <#if usage.synonym>
        of <a href="<@s.url value='/species/${usage.acceptedKey?c}'/>">${usage.accepted!"???"}</a>
      </#if>
    </p>

    <#if basionym?has_content>
      <h3>Original Name</h3>
      <p><a href="<@s.url value='/species/${basionym.key?c}'/>">${basionym.scientificName}</a></p>
    </#if>

    <#if usage.nomenclaturalStatus?has_content>
      <h3>Nomenclatural Status</h3>
      <p>${usage.nomenclaturalStatus}</p>
    </#if>

    <#if usage.isExtinct()??>
      <h3>Extinction Status</h3>
      <p>${usage.isExtinct()?string("Extinct","Living")}</p>
    </#if>

    <#if (usage.livingPeriods?size>0)>
      <h3>Living Period</h3>
      <p><#list usage.livingPeriods as p>${p}<#if p_has_next>; </#if></#list></p>
    </#if>

    <#if habitats?has_content>
      <h3>Habitat</h3>
      <p>
        <#list habitats as h>${h}<#if h_has_next>, </#if></#list>
      </p>
    </#if>

    <#if (usage.threatStatus?size>0)>
      <h3>Threat Status</h3>
      <p><#list usage.threatStatus as t><#if t?has_content><@s.text name="enum.threatstatus.${t}"/><#if t_has_next>; </#if></#if></#list></p>
    </#if>

  </div>
</div>

<div class="right">
  <#if usage.images?has_content>
    <#assign img=usage.images[0]>
    <div class="species_image">
      <a href="#images" class="images"><span><img src="${img.thumbnail!img.image!"image missing url"}"/></span></a>
    </div>
  </#if>


  <h3>External Links</h3>
  <ul>
  <#list usage.externalLinks as i>
    <#if i.title?has_content || (i.datasetKey?has_content && datasets.get(i.datasetKey)??)>
    <li>
      <#if i.identifierLink?has_content>
        <a href="${i.identifierLink}" title="${i.title!i.type!}">
      </#if>
        <#if i.title?has_content>
          ${i.title}
        <#else>
          ${common.limit( datasets.get(i.datasetKey).title ,30)}
        </#if>
      <#if i.identifierLink?has_content>
        </a>
      </#if>
    </li>
    </#if>
  </#list>
  <#if usage.nubKey??>
    <li><a target="_blank" href="http://eol.org/search/?q=${usage.canonicalOrScientificName}" title="Encyclopedia of Life">Encyclopedia of Life</a></li>
  </#if>

  <#if (usage.lsids?size>0)>
    <li><@common.popover linkTitle="Life Science Identifier" popoverTitle="Life Science Identifier">
      <#list usage.lsids as i>
        <p><a href='${i.identifierLink}'>${i.identifier}</a></p><br/>
      </#list></@common.popover>
    </li>
  </#if>
  </ul>

</div>
</@common.article>

<@common.article id="taxonomy" title="Subordinate Taxa" titleRight="Classification" class="taxonomies">
    <div class="left">
      <div id="taxonomicChildren">
        <div class="loadingTaxa"><img src="../img/taxbrowser-loader.gif"></div>
        <div class="inner">
          <div class="sp">
            <ul>
            </ul>
          </div>
        </div>
      </div>
    </div>

    <div class="right">
      <dl>
      <#list rankEnum as r>
        <dt><@s.text name="enum.rank.${r}"/></dt>
        <dd>
          <#if usage.getHigherRankKey(r)??>
            <#if usage.getHigherRankKey(r) == usage.key>
              ${usage.canonicalOrScientificName}
            <#else>
              <a href="<@s.url value='/species/${usage.getHigherRankKey(r)?c}'/>">${usage.getHigherRank(r)}</a>
            </#if>
          <#elseif (usage.getNumByRank(r)>0)>
            <a href="<@s.url value='/species/search?status=ACCEPTED&dataset_key=${usage.datasetKey}&rank=${r}&highertaxon_key=${usage.key?c}'/>">${usage.getNumByRank(r)}</a>
          <#else>
            ---
          </#if>
        </dd>
      </#list>
        <dt>&nbsp;</dt>
        <dd><a href="<@s.url value='/species/${id?c}/classification'/>">complete classification</a></dd>
      </dl>
      <br/>

      <#if usage.accordingTo?has_content>
        <h3>According to</h3>
        <p>${usage.accordingTo}</p>
      </#if>

    </div>
</@common.article>

<#-- Taxon maps are only calculated for the nub taxonomy -->
<#if nub>
<article class="map">
  <header></header>

  <div id="zoom_in" class="zoom_in"></div>
  <div id="zoom_out" class="zoom_out"></div>
  <div id="map" type="TAXON" key="${usage.key?c}"></div>

  <div class="content">

    <div class="header">
      <div class="right">
        <div class="big_number">
          <span>${numOccurrences}</span>
          <a href="<@s.url value='/occurrence/search?taxon_key=${usage.key?c}'/>">occurrences</a>
        </div>

        <#--
         TODO: implement counts of selected areas when we can
        <div class="big_number placeholder_temp">
          <span class="big_number">8,453</span>
          <a href="<@s.url value='/occurrence/search?q=holotype'/>">in the selected area</a>
        </div>
        -->
      </div>
    </div>

    <div class="right">
        <#--
         TODO: implement when we can and move distributions to somewhere else?
      <h3>Visualize</h3>
      <p class="maptype">
        <a href="#" title="occurrence" class="selected">occurrence</a>
        | <a class="placeholder_temp" href="#" title="diversity">diversity</a>
        | <a class="placeholder_temp" href="#" title="distribution">distribution</a>
      </p>
        -->

      <#if (usage.distributions?size>0)>
        <h3>Distributions</h3>
        <ul class="notes">
        <#assign skipped=0/>
        <#list usage.distributions as d>
          <#if d.locationId?? || d.country?? || d.locality?? >
            <li>
              <#if d.country??>${d.country.title}</#if>
              ${d.locationId!} ${d.locality!}
              <span class="note">
                ${d.lifeStage!} ${d.temporal!} <@s.text name='enum.occurrencestatus.${d.status!"PRESENT"}'/>
                <#if d.threatStatus??><@s.text name="enum.threatstatus.${d.threatStatus}"/></#if>
                <#if d.establishmentMeans??><@s.text name='enum.establishmentmeans.${d.establishmentMeans}'/></#if>
                <#if d.appendixCites??>Cites ${d.appendixCites}</#if>
              </span>
            </li>
          <#else>
            <#assign skipped=skipped+1/>
          </#if>
          <#-- only show 5 distributions at max -->
          <#if !d_has_next && d_index==4+skipped>
           <li><a class="more_link" href="<@s.url value='/species/${id?c}/distributions'/>">see all</a></li>
          </#if>
        </#list>
        </ul>
      </#if>

    </div>
  </div>
  <footer></footer>
</article>
<#else>

  <@common.article id="distribution" title="Distribution Range">
    <div class="fullwidth">
      <ul class="notes">
        <#assign skipped=0/>
        <#list usage.distributions as d>
          <#if d.locationId?? || d.country?? || d.locality?? >
            <li>
              <#if d.country??>${d.country.title}</#if>
              ${d.locationId!} ${d.locality!}
              <span class="note">
                ${d.lifeStage!} ${d.temporal!} <@s.text name='enum.occurrencestatus.${d.status!"PRESENT"}'/>
                <#if d.threatStatus??><@s.text name="enum.threatstatus.${d.threatStatus}"/></#if>
                <#if d.establishmentMeans??><@s.text name='enum.establishmentmeans.${d.establishmentMeans}'/></#if>
                <#if d.appendixCites??>Cites ${d.appendixCites}</#if>
              </span>
            </li>
          <#else>
            <#assign skipped=skipped+1/>
          </#if>
          <#-- only show 8 distributions at max -->
          <#if d_has_next && d_index==7+skipped>
           <li><a class="more_link" href="<@s.url value='/species/${id?c}/distributions'/>">see all</a></li>
            <#break />
          </#if>
        </#list>
      </ul>
    </div>
  </@common.article>
</#if>

<#if !descriptionToc.isEmpty()>
  <@common.article id="description" title='Description' class="">
    <div class="left">
      <div class="inner">
        <h3>Description</h3>
        <p>bla bla bla</p>
      </div>
    </div>

    <div class="right">
      <h3>Table of Content</h3>
      <br/>
      <ul class="no_bottom">
        <#list descriptionToc.listTopics() as topic>
          <li>${topic?capitalize}
            <#assign entries=descriptionToc.listTopicEntries(topic) />
            <#list entries?keys as lang>
              <span class="language" descriptionKeys="<#list entries.get(lang) as did>${did?c} </#list>">${lang.getIso3LetterCode()?upper_case}</span>
            </#list>
          </li>
        </#list>
      </ul>
    </div>
  </@common.article>
</#if>

<#if (usage.images?size>0)>
  <@common.article id="images" class="photo_gallery">
    <div class="slideshow" usageKey="${id?c}">
      <div class="photos">
        <#list usage.images as img>
          <#if img.image??>
            <#if !img1?exists><#assign img1=img/></#if>
            <!--<img src="${img.image!}"/>-->
          </#if>
        </#list>
      </div>
    </div>

    <div class="right">
      <#if img1?exists>
        <div class="controllers">
          <h2 class="title">${common.limit(img1.title!usage.canonicalOrScientificName!"",38)}</h2>
          <a class="controller previous_slide" href="#" title="Previous image"></a>
          <a class="controller next_slide" href="#" title="Next image"></a>
        </div>

        <#if img1.description?has_content>
          <h3>Description</h3>
          <p>${common.limit(img1.description!img1.title!"",100)}
            <#if (img1.description?length>100) ><@common.popup message=img1.description title=img1.title!"Description"/></#if>
          </p>
        </#if>

        <#if nub || img1.link?has_content>
        <h3>Source</h3>
        <#assign imgTitle=common.limit( (datasets.get(img1.datasetKey).title!"???"), 28) />
        <p>
          <#if img1.link?has_content>
            <a href="${img1.link}">${imgTitle}</a>
          <#else>
            ${imgTitle}
          </#if>
          <#if nub>
            <span class="note">view <a class="source" data-baseurl="<@s.url value='/species/'/>" href="<@s.url value='/species/${img1.usageKey?c}'/>">source usage</a></span>
          </#if>
        </p>
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
  </@common.article>
</#if>

<#if usage.nubKey??>
  <@common.article id="appearsin" title="Appears in">
    <div class="fullwidth">
      <div class="col">
        <h3>Occurrence datasets</h3>
        <ul class="notes">
          <#assign counter=0 />
          <#list occurrenceDatasetCounts?keys as uuid>
            <#if datasets.get(uuid)??>
              <#assign counter=counter+1 />
              <#assign title=datasets.get(uuid).title! />
              <li>
                <a title="${title}" href="<@s.url value='/occurrence/search?taxon_key=${usage.nubKey?c}&dataset_key=${uuid}'/>">${common.limit(title, 55)}</a>
                <span class="note"> in ${occurrenceDatasetCounts.get(uuid)!0} occurrences</span>
              </li>
            </#if>
            <#if uuid_has_next && counter==6>
              <li><a class="more_link" href="<@s.url value='/species/${usage.nubKey?c}/datasets?type=OCCURRENCE'/>">see all ${occurrenceDatasetCounts?size}</a></li>
              <#break />
            </#if>
          </#list>
        </ul>
      </div>

      <div class="col">
        <h3>Checklists</h3>
        <ul class="notes">
          <#assign counter=0 />
          <#list related as rel>
            <#if datasets.get(rel.datasetKey)??>
              <#assign counter=counter+1 />
              <#assign title=datasets.get(rel.datasetKey).title! />
              <li><a title="${title}" href="<@s.url value='/species/${rel.key?c}'/>">${common.limit(title, 55)}</a>
                <span class="note">as ${rel.scientificName}</span>
              </li>
            </#if>
            <#if rel_has_next && counter==6>
              <li><a class="more_link" href="<@s.url value='/species/${usage.nubKey?c}/datasets?type=CHECKLIST'/>">see all ${related?size}</a></li>
              <#break />
            </#if>
          </#list>
        </ul>
      </div>
    </div>
  </@common.article>
</#if>

<#if (usage.typeSpecimens?size>0)>
  <@common.article id="typespecimen" title="Type specimens">
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
  </@common.article>
</#if>

<#if (usage.references?size>0)>
  <@common.article id="references" title="Bibliography">
    <div class="left">
      <#if (usage.references?size>0)>
        <ul>
          <#list usage.references as ref>
            <li>
              <#if ref.link?has_content><a href="${ref.link}">${ref.citation}</a><#else>${ref.citation}</#if>
              <#if ref.doi?has_content><br/>DOI:<a href="http://dx.doi.org/${ref.doi}">${ref.doi}</a></#if>
            </li>
            <#-- only show 8 references at max. If we have 8 (index=7) we know there are more to show -->
            <#if ref_has_next && ref_index==7>
              <li><a class="more_link" href="<@s.url value='/species/${id?c}/references'/>">see all</a></li>
              <#break />
            </#if>
          </#list>
        </ul>
      </#if>
    </div>

    <div class="right">
      <h3>External Sources</h3>
      <ul>
        <#if usage.canonicalName??>
          <li><a target="_blank" href="http://www.biodiversitylibrary.org/name/${usage.canonicalName?replace(' ','_')}">Biodiveristy Heritage Library</a></li>
        </#if>
      </ul>
    </div>

  </@common.article>
</#if>

<@common.article id="legal" title="Usage & legal issues" class="mono_line">
    <div class="fullwidth">
      <#assign rights = usage.rights!dataset.intellectualRights! />
      <#if rights?has_content>
        <h3>Usage rights</h3>
        <p>${rights}</p>
      </#if>

        <h3>How to cite</h3>
        <p>
          <#if usage.citation?has_content>
            ${usage.citation}
          <#else>
            ${usage.scientificName} In:
            <#if dataset.citation??>
              <@common.citation dataset.citation />
            <#else>
              missing, see <a href="http://dev.gbif.org/issues/browse/REG-229">REG-229</a>
            </#if>
          </#if>
          <br/>
          Accessed via ${currentUrl} on ${.now?date?iso_utc}
        </p>
    </div>
</@common.article>

<#if !usage.isNub()>
  <@common.notice title="Further information">
  <p>There may be more details available about this name usage in the
    <a href="<@s.url value='/species/${id?c}/verbatim'/>">verbatim version</a> of the record
  </p>
  </@common.notice>
<#elseif usage.origin??>
  <@common.notice title="Source information">
  <p>This backbone name usage exists because
    <#if usage.origin == "SOURCE" && usage.sourceId??>
      at least one <a class="source" data-baseurl="<@s.url value='/species/'/>" href="<@s.url value='/species/${usage.sourceId}'/>">source name usage</a> exists for that name.
    <#else>
      <@s.text name="enum.origin.${usage.origin}"/>.
    </#if>
  </p>
  </@common.notice>
</#if>

</body>
</html>
