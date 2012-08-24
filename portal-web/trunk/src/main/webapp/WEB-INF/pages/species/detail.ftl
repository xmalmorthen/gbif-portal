<#import "/WEB-INF/macros/common.ftl" as common>
<#import "/WEB-INF/macros/specimen/specimenRecord.ftl" as specimenRecord>
<html>
  <head>
    <title>${usage.scientificName} - Checklist View</title>

    <#if nub>
    <content tag="extra_scripts">
    <link rel="stylesheet" href="<@s.url value='/js/vendor/leaflet/leaflet.css'/>" />
    <!--[if lte IE 8]><link rel="stylesheet" href="<@s.url value='/js/vendor/leaflet/leaflet.ie.css'/>" /><![endif]-->
    <script type="text/javascript" src="<@s.url value='/js/vendor/leaflet/leaflet.js'/>"></script>
    <script type="text/javascript" src="<@s.url value='/js/map.js'/>"></script>
    </content>
    </#if>
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

        <#if (vernacularNames?size>0)>
        <h3>Common names</h3>
        <ul>
          <#assign more=false/>
          <#list vernacularNames?keys as vk>
          <#assign names=vernacularNames.get(vk)/>
          <#assign v=names[0]/>
          <li>${v.vernacularName} <span class="small">${(v.language.interpreted)!}</span>
          <@common.usageSources components=names showSource=!usage.isNub() showChecklistSource=usage.isNub() />
          </li>
          <#if !vk_has_next && vk_index==2>
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
          <#if !syn_has_next && syn_index==4>
            <li><a class="more_link" href="<@s.url value='/species/${id?c}/synonyms'/>">see all</a></li>
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
        ${(usage.taxonomicStatus.interpreted)!"Unknown"}
        <#if usage.synonym>
        of <a href="<@s.url value='/species/${usage.acceptedKey?c}'/>">${usage.accepted!"???"}</a>
        </#if>
        </p>

        <#if basionym?has_content>
        <h3>Original Name</h3>
        <p><a href="<@s.url value='/species/${basionym.key?c}'/>">${basionym.scientificName}</a></p>
        </#if>

        <#if (usage.nomenclaturalStatus.interpreted)?has_content>
        <h3>Nomenclatural Status</h3>
        <p>${usage.nomenclaturalStatus.interpreted}</p>
        </#if>

        <#if usage.isExtinct()??>
        <h3>Extinction Status</h3>
        <p>${usage.isExtinct()?string("Extinct","Living")}</p>
        </#if>

        <#if (usage.livingPeriods?size>0)>
        <h3>Living Period</h3>
        <p><#list usage.livingPeriods as p>${p}<#if p_has_next>; </#if></#list></p>
        </#if>

        <#if usage.isMarine()?? || usage.isTerrestrial()?? || (usage.habitats?size>0)>
        <h3>Habitat</h3>
        <p>
        <#if usage.isMarine()??><#if usage.isMarine()>Marine<#else>Non Marine</#if>;</#if>
        <#if usage.isTerrestrial()??><#if usage.isTerrestrial()>Terrestrial<#else>Non Terrestrial</#if>;</#if>
        <#list usage.habitats as h>${h}<#if t_has_next>; </#if></#list>
        </p>
        </#if>

        <#if (usage.threatStatus?size>0)>
        <h3>Threat Status</h3>
        <p><#list usage.threatStatus as t><@s.text name="enum.threatstatus.${t}"/><#if t_has_next>; </#if></#list></p>
        </#if>

      </div>
    </div>

    <div class="right">
      <#if usage.images?has_content>
      <#assign img=usage.images[0]>
      <a href="#" class="images"><span><img src="${img.thumbnail!img.image!"image missing url"}"/></span></a>
      </#if>


      <h3>External Links</h3>
      <ul>
        <#list usage.externalLinks as i>
        <li><a href="${i.identifierLink}" title="${i.title!i.type!}">
          <#if i.title?has_content>${i.title}
          <#else>
          ${common.limit( datasets.get(i.datasetKey).title ,30)}
          </#if>
        </a></li>
        </#list>
        <#-- TODO link to EOL once we have their archive
        <#if usage.nubKey??>
        <li><a href="http://eol.org/gbif/${usage.nubKey?c}" title="EOL">EOL</a></li>
        </#if>
        -->
        <li><a href="http://ecat-dev.gbif.org/usage/${usage.key?c}" title="ECAT Portal">ECAT Portal</a></li>

        <#if (usage.lsids?size>0)>
        <li><@common.popover linkTitle="LSID" popoverTitle="Life Science Identifier">
        <#list usage.lsids as i>
        <p><a href='${i.identifierLink}'>${i.identifier}</a></p><br/>
        </#list></@common.popover>
        </li>
        </#if>
      </ul>

    </div>
    </@common.article>

    <#assign title>
    Taxonomic classification <span class='subtitle'>According to <a href="<@s.url value='/dataset/${dataset.key}'/>">${dataset.title!}</a></span>
    </#assign>
    <@common.article id="taxonomy" title=title class="taxonomies">
    <div class="left">
      <div id="taxonomicChildren">
        <ul>
        </ul>
        <div class="loadingTaxa"><span></span></div>
      </div>
    </div>

    <div class="right">
      <h3>Taxonomic classification
        <div class="extended">[<a href="<@s.url value='/species/${id?c}/classification'/>">extended</a>]</div>
      </h3>

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
            <a href="<@s.url value='/species/search/?rank=${r.ordinal()}&highertaxon=${usage.key?c}'/>">${usage.getNumByRank(r)}</a>
          <#else>
            ---
          </#if>
        </dd>
        </#list>

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
              <span>${usage.numOccurrences!0}</span>
              <a href="<@s.url value='/occurrence/search?nubKey=${usage.key?c}'/>">occurrences</a>
            </div>

        <#--
         TODO: implement counts of selected areas when we can
        <div class="big_number placeholder_temp">
          <span class="big_number">8,453</span>
          <a href="<@s.url value='/occurrence/search?q=holotype'/>">in the selected area</a>
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
        <#list usage.distributions as d>
          <li>
            ${d.locationId!} ${(d.country.interpreted)!} ${d.locality!}
            <span class="note">
              ${(d.lifeStage.interpreted)!} ${d.temporal!} ${(d.status.interpreted)!"Present"}
              <#if (d.threatStatus.interpreted)??><@s.text name="enum.threatstatus.${d.threatStatus.interpreted}"/></#if>
              ${(d.establishmentMeans.interpreted)!} ${(d.appendixCites.interpreted)!}
            </span>
          </li>
          <#-- only show 5 distributions at max -->
          <#if !d_has_next && d_index==4>
           <li><a class="more_link" href="<@s.url value='/species/${id?c}/distributions'/>">see all</a></li>
          </#if>
        </#list>
        </ul>
      </#if>

    </div>
  </div>
  <footer></footer>
</article>
</#if>

<#if usage.descriptions?has_content>
  <@common.article id="description" title='Description' class="">
    <div class="left">
      <#assign d = usage.descriptions[0]>
      <h3>${d.type!"Description"} <@common.usageSource component=d showChecklistSource=nub /></h3>
      <p>${d.description!}</p>
    </div>

    <div class="right">
      <h3>Content</h3>
      <ul class="no_bottom">
        <#list usage.descriptions as d>
          <li><a href="#'/>">${d.type!"Description"}</a> <span class="language">${d.language!}</span></li>
          </#list>
        </ul>
      </div>
      </@common.article>
      </#if>

      <#if (usage.images?size>0)>
      <@common.article id="images" class="photo_gallery">
      <div class="slideshow" data-id="${id?c}">
        <ul class="photos">
          <!--<li class="one"></li><li class="two"></li><li class="three"></li><li class="four"></li>-->
        </ul>
      </div>

          <!--<#list usage.images as img>-->
          <!--<#if img.image??>-->
          <!--<#if !img1?exists><#assign img1=img/></#if>-->
          <!--<img src="${img.image!}"/>-->
          <!--</#if>-->
          <!--</#list>-->

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
        <p><a href="<@s.url value='/species/${img1.usageKey}'/>">${(datasets.get(img1.datasetKey).title)!"???"}</a></p>
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
      <div class="left">
        <div class="col">
          <h3>Occurrence datasets</h3>
          <ul class="notes">
            <#assign more=false/>
            <#list relatedDatasets as uuid>
            <li>
            <a href="<@s.url value='/occurrence/search?nubKey=${usage.nubKey?c}&datasetKey=${uuid}'/>">${(datasets.get(uuid).title)!uuid}</a>
            </li>
            <#if uuid_has_next && uuid_index==6>
              <li><a class="more_link" href="<@s.url value='/species/${usage.nubKey?c}/datasets?type=OCCURRENCE'/>">see all ${relatedDatasets?size}</a></li>
              <#break />
            </#if>
          </#list>
        </ul>
      </div>

        <div class="col">
          <h3>Checklists</h3>
          <ul class="notes">
            <#assign more=false/>
            <#list related as rel>
            <li><a href="<@s.url value='/species/${rel.key?c}'/>">${(datasets.get(rel.datasetKey).title)!"???"}</a>
            <span class="note">${rel.scientificName}</span>
            </li>
            <#if rel_has_next && rel_index==6>
              <li><a class="more_link" href="<@s.url value='/species/${usage.nubKey?c}/datasets?type=CHECKLIST'/>">see all ${related?size}</a></li>
              <#break />
            </#if>
          </#list>
        </ul>
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

      <#if usage.publishedIn?has_content || usage.accordingTo?has_content || (usage.references?size>0)>
      <@common.article id="references" title="Academic references">
      <div class="left">
        <#if (usage.references?size>0)>
        <h3>Bibliography</h3>
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
          <#if usage.canonical??>
          <li><a href="http://www.biodiversitylibrary.org/name/${usage.canonical?replace(' ','_')}">Biodiveristy Heritage Library</a></li>
          </#if>
        </ul>
      </div>

      </@common.article>
      </#if>

      <@common.article id="legal" title="Usage & legal issues" class="mono_line">
      <div class="left">
        <#assign rights = usage.rights!dataset.intellectualRights! />
        <#if rights?has_content>
        <h3>Usage rights</h3>
        <p>${rights}</p>
        </#if>

        <#if usage.citation?has_content || dataset.citation??>
        <h3>HOW TO CITE IT</h3>
        <p>
        <#if usage.citation?has_content>${usage.citation} <#else> <@common.citation dataset.citation /></#if>
        </p>
        </#if>
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
      at least one <a href="<@s.url value='/species/${usage.sourceId}'/>">source name usage</a> exists for that name.
      <#else>
      <@s.text name="enum.origin.${usage.origin}"/>.
      </#if>
      </p>
      </@common.notice>
      </#if>

    </body>
  </html>
