<#import "/WEB-INF/macros/common.ftl" as common>
<html>
  <head>
    <title>Maps API</title>

    <content tag="extra_scripts">
      <link rel="stylesheet" href="<@s.url value='/js/vendor/leaflet/leaflet.css'/>" />
      <!--[if lte IE 8]><link rel="stylesheet" href="<@s.url value='/js/vendor/leaflet/leaflet.ie.css'/>" /><![endif]-->
      <script type="text/javascript" src="<@s.url value='/js/vendor/leaflet/leaflet.js'/>"></script>

      <script>
        var baseUrl = cfg.tileServerBaseUrl + '/density/tile?x={x}&y={y}&z={z}';

        // Based on the preview content, build the tile template url
        function getGBIFUrl() {
          var layers="";
          $.each($('.layer'), function(i,d) {
            if (d.checked) {
              layers =layers + "&layer=" + d.id;
            }
          });

          var palette = "";
          $.each($('.color'), function(i,d) {
            if (d.checked) {
              if (d.id == "custom") {
                palette="&colors=" + encodeURIComponent($('#colorset').val());
              } else {
                palette ="&palette=" + d.id;
              }
            }
          });

          var url = baseUrl
            + "&type=" + $("#type").val()
            + "&key=" + $("#key").val()
            + layers
            + palette;
          // console.log("GBIF layer template url: " +  url);
          $("#urlTemplate").html("<a href='" + url + "'>" + url + "</a>");
          return url;
        }

		var gbifAttrib='GBIF contributors';
		var gbif = new L.TileLayer(getGBIFUrl(), {minZoom: 0, maxZoom: 14, attribution: gbifAttrib});
	    var cmAttr = 'Nokia',
			cmUrl = 'http://2.maps.nlp.nokia.com/maptile/2.1/maptile/newest/normal.day.grey/{z}/{x}/{y}/256/png8?app_id=_peU-uCkp-j8ovkzFGNU&app_code=gBoUkAMoxoqIWfxWA5DuMQ';
	    var minimal   = L.tileLayer(cmUrl, {styleId: 22677, attribution: cmAttr});

		var map = L.map('map', {
			center: [0, 0],
			zoom: 1,
			maxZoom: 14,
			layers: [minimal, gbif]
		});


        $('.refresh,.layer,.color').click(function(event) {
          gbif.setUrl(getGBIFUrl());
        });

		// prototype util function
        if (typeof String.prototype.startsWith != 'function') {
            String.prototype.startsWith = function (str){
            return this.indexOf(str) == 0;
          };
        }

        $('.toggle').click(function(e) {
          e.preventDefault();
          $.each($('.layer'), function(i,d) {
            if (d.id.startsWith(e.target.id)) {
              d.checked = !d.checked;
            }
          });
          gbif.setUrl(getGBIFUrl());
        });

      </script>
    </content>
  </head>

  <#assign tab="maps"/>
  <#include "/WEB-INF/pages/developer/inc/tabs.ftl" />

  <body class="api">

  <@common.article title='Mapping API' titleRight='Quick Links'>
        <div class="left">
          <p>
            The mapping api is a <a href="http://www.opengeospatial.org/standards/wmts">web map tile service</a>
            making it trivial to visualize GBIF content on interactive maps, and overlay content from other sources.
          </p>
          <p>
            <code>Developers familiar with tile mapping services should jump straight to the <a href="#preview">preview functionality</a></code>
          </p>
          <p>
            The following features are supported:
            <ul>
              <li>Map layers available for a <strong>country</strong>, <strong>dataset</strong>, <strong>taxon</strong> (species, subspecies or higher taxon), <strong>publisher</strong></li>
              <li>User defined styling by selecting a predefined color palette, or by providing styling rules</li>
              <li>Density of content is clustered to a user defined cluster size (regardless of zoom level)</li>
              <li>The ability to customise content shown by the <a href="http://rs.tdwg.org/dwc/terms/#basisOfRecord">basis of record</a> (E.g. Specimens, Observations, Fossils etc)</li>
              <li>For certain basis of record types, the time period may be customised by decade; e.g. map the observations of a species since 1970</li>
            </ul>
          </p>
          <p>
            This service is intended for use with commonly used clients such as the <a href="https://developers.google.com/maps/">google
            maps api</a>, <a href="http://leaflet.cloudmade.com">leaflet JS library</a> or the <a href="http://modestmaps.com">modest maps JS library</a>.
            These libraries allow the GBIF layers to be visualized with other content, such as those coming from
            <a href="http://www.opengeospatial.org/standards/wms">web map service (WMS)</a> providers.  It should be noted that the mapping api is not
            a WMS service, nor does it support WFS capabilities.  The examples on this page use the leaflet library.
          </p>
        </div>
        <div class="right">
          <ul>
            <li><a href="#spec">The tile URL format</a></li>
            <li><a href="#layers">Customizing layer content</a></li>
            <li><a href="#colors">Styling a layer</a></li>
            <li><a href="#preview">Preview</a></li>
          </ul>
        </div>
  </@common.article>

    <a name="spec"></a>
    <article>
      <header></header>
      <div class="content">
        <div class="header">
          <div class="left">
            <h4>The tile URL format</h4>
          </div>
        </div>

        <div class="left">
          <p>
            The format of the url is as follows:
          </p>
          <p>
            <code>${cfg.tileServerBaseUrl}/density/tile?x={x}&y={y}&z={z}</code>
          </p>
          <p>
            With the following parameters:
            <table class="params">
              <tr>
                <td>type</td>
                <td><strong>required</strong></td>
                <td>A value of TAXON, DATASET, COUNTRY or PUBLISHER</td>
              </tr>
              <tr>
                <td>key</td>
                <td><strong>required</strong></td>
                <td>The appropriate key for the chosen type (a taxon key, dataset/publisher uuid or 2 letter ISO country code)</td>
              </tr>
              <tr>
                <td>resolution</td>
                <td>optional (default 1)</td>
                <td>The number of pixels to which density is aggregated. Valid values are 1, 2, 4, 8, and 16.</td>
              </tr>
              <tr>
                <td>layer</td>
                <td>optional (multivalued)</td>
                <td>Declares the layers to be combined by the server for this tile.  See <a href="#layers">Customizing layer content</a></td>
              </tr>
              <tr>
                <td>palette</td>
                <td>optional</td>
                <td>Selects a predefined color palette.  See <a href="#colors">styling a layer</a></td>
              </tr>
              <tr>
                <td>colors</td>
                <td>optional</td>
                <td>Provides a user defined set of rules for coloring the layer.  See <a href="#colors">styling a layer</a></td>
              </tr>
              <tr>
                <td>saturation & hue</td>
                <td>optional</td>
                <td>Allows selection of a hue value between 0.0 and 1.0 when saturation is set to true. See <a
                        href="#colors">styling a layer</a></td>
              </tr>
            </table>
          </p>

        </div>
      </div>
      <footer></footer>
    </article>

    <a name="layers"></a>
    <article>
      <header></header>
      <div class="content">
        <div class="header">
          <div class="left">
            <h4>Customizing layer content</h4>
          </div>
        </div>

        <div class="left">
          <p>
            The following layers may be used to instruct the server to combine the content into a single density layer.  All layers declared will be combined by the server on rendering.
            Thus, for a given taxon, country, dataset or provider, it is possible to retrieve e.g:
            <ul>
              <li>A map of specimens only</li>
              <li>A map of specimens and observations</li>
              <li>A map of specimens only, and collected after 1970</li>
              <li>A map of everything observed or collected after 2000</li>
              <li>A map of everything where the year is known</li>
              <li>A map of everything omitting those data known to be living specimens</li>
              <li>..etc</li>
            </ul>
          </p>
          <p>
            The quickest way to experiment with this is to use the <a href="#preview">preview functionality</a>.  The specification for the layers are provided below.
            <ul>
              <li>This is a <strong>multivalue field</strong> so it is expected that several layers are requested in any single URL</li>
              <li>
                Should <strong>no layers be specified, a sensible default is provided</strong>.  This is to preserve backwards compatibility since layering was an additional feature, and considered
                acceptable since a map with no layers makes little sense.  At present the default returns all layers, but could be subject to future change (e.g. should a layer of records
                with known issues be added, it might not be included in the default)
              </li>
            </ul>

          </p>
          <p>
            <table class="params">
              <tr>
                <td>Observations</td>
                <td>Observation layers can take no year (&layer=OBS_NO_YEAR), before the 1900s (&layer=OBS_PRE_1900) or any decade after 1900.  The full list is given:
                <br/><br/>
                <code>OBS_NO_YEAR, OBS_PRE_1900, OBS_1900_1910, OBS_1910_1920, OBS_1920_1930, OBS_1930_1940, OBS_1940_1950, OBS_1950_1960, OBS_1960_1970, OBS_1970_1980, OBS_1980_1990, OBS_1990_2000, OBS_2000_2010, OBS_2010_2020</code></td>
              </tr>
              <tr>
                <td>Specimens</td>
                <td>Specimen layers can take no year (&layer=SP_NO_YEAR), before the 1900s (&layer=SP_PRE_1900) or any decade after 1900.  The full list is given:
                <br/><br/>
                <code>SP_NO_YEAR, SP_PRE_1900, SP_1900_1910, SP_1910_1920, SP_1920_1930, SP_1930_1940, SP_1940_1950, SP_1950_1960, SP_1960_1970, SP_1970_1980, SP_1980_1990, SP_1990_2000, SP_2000_2010, SP_2010_2020</code></td>
              </tr>
              <tr>
                <td>Living</td>
                <td>If provided, the records with a declared basis of record of living will be included.
                <code>LIVING</code></td>
              </tr>
              <tr>
                <td>Fossil</td>
                <td>If provided, the records with a declared basis of record of fossil will be included.
                <code>FOSSIL</code></td>
              </tr>
              <tr>
                <td>Other</td>
                <td>Records where the basis of record is unknown, or something other than those above can take no year (&layer=OTH_NO_YEAR), before the 1900s (&layer=OTH_PRE_1900) or any decade after 1900.  The full list is given:
                <br/><br/>
                <code>OTH_NO_YEAR, OTH_PRE_1900, OTH_1900_1910, OTH_1910_1920, OTH_1920_1930, OTH_1930_1940, OTH_1940_1950, OTH_1950_1960, OTH_1960_1970, OTH_1970_1980,OTH_1980_1990, OTH_1990_2000, OTH_2000_2010, OTH_2010_2020</code></td>
              </tr>
            </table>
          </p>

        </div>
      </div>
      <footer></footer>
    </article>

    <a name="colors"></a>
    <article>
      <header></header>
      <div class="content">
        <div class="header">
          <div class="left">
            <h4>Styling a layer</h4>
          </div>
        </div>

        <div class="left">
          <p>
            Styling the configured layer is controlled through either the <strong>&colors</strong> parameter, the <strong>&palette</strong> parameter, or a combination of the <strong>&saturation</strong> and <strong>&hue</strong> parameters.  If none
            are provided, a sensible default will be used, which may be subject to change without notice.  The quickest way to experiment with this is to use the <a href="#preview">preview functionality</a>.
          </p>
          <p><strong>Palette and Colors</strong></p>
          <p>
            The possible options for the <strong>palette</strong> are given:
          </p>
          <p>

            <table width="100%" class="params">
              <tr>
                <td/>
                <td colspan="6" class="header">Record count</td>
              </tr>
              <tr>
                <td/>
                <td width="14%">0-10</td>
                <td width="14%">10-100</td>
                <td width="14%">100-1000</td>
                <td width="14%">1000-10000</td>
                <td width="14%">10000-100000</td>
                <td width="14%">100000+</td>
              </tr>
              <tr>
                <td>yellows_reds</td>
                <td style="background-color:#FFFF00"></td>
                <td style="background-color:#FFCC00"></td>
                <td style="background-color:#FF9900"></td>
                <td style="background-color:#FF6600"></td>
                <td style="background-color:#FF3300"></td>
                <td style="background-color:#CC0000"></td>
              </tr>
              <tr>
                <td>blues</td>
                <td style="background-color:#EFF3FF"></td>
                <td style="background-color:#C6DBEF"></td>
                <td style="background-color:#9ECAE1"></td>
                <td style="background-color:#6BAED6"></td>
                <td style="background-color:#3182BD"></td>
                <td style="background-color:#08519C"></td>
              </tr>
              <tr>
                <td>greens</td>
                <td style="background-color:#EDF8E9"></td>
                <td style="background-color:#C7E9C0"></td>
                <td style="background-color:#A1D99B"></td>
                <td style="background-color:#74C476"></td>
                <td style="background-color:#31A354"></td>
                <td style="background-color:#006D2C"></td>
              </tr>
              <tr>
                <td>greys</td>
                <td style="background-color:#F7F7F7"></td>
                <td style="background-color:#D9D9D9"></td>
                <td style="background-color:#BDBDBD"></td>
                <td style="background-color:#969696"></td>
                <td style="background-color:#636363"></td>
                <td style="background-color:#252525"></td>
              </tr>
              <tr>
                <td>oranges</td>
                <td style="background-color:#FEEDDE"></td>
                <td style="background-color:#FDD0A2"></td>
                <td style="background-color:#FDAE6B"></td>
                <td style="background-color:#FD8D3C"></td>
                <td style="background-color:#E6550D"></td>
                <td style="background-color:#A63603"></td>
              </tr>
              <tr>
                <td>purples</td>
                <td style="background-color:#F2F0F7"></td>
                <td style="background-color:#DADAEB"></td>
                <td style="background-color:#BCBDDC"></td>
                <td style="background-color:#9E9AC8"></td>
                <td style="background-color:#756BB1"></td>
                <td style="background-color:#54278F"></td>
              </tr>
              <tr>
                <td>reds</td>
                <td style="background-color:#FEE5D9"></td>
                <td style="background-color:#FCBBA1"></td>
                <td style="background-color:#FC9272"></td>
                <td style="background-color:#FB6A4A"></td>
                <td style="background-color:#DE2D26"></td>
                <td style="background-color:#A50F15"></td>
              </tr>
            </table>
          </p>
          <p>
            Should you wish to style a map further, you may provide a color ruleset using the <strong>&colors</strong> parameter.
            A ruleset is a pipe(|) separated series of rules, where each rule is comma (,) separated containing the min (optional and inclusive), max(optional and exclusive)
            and color to apply for the range.  Colors are in #RGBA format (red, green, blue, alpha with a preceding hash).  The ruleset must be
            URL encoded (in javascript, the encodeURIComponent() provides this).  Thus, the format of the ruleset is given as:
          </p>
          <p>
            <code>
              <strong>ruleset_expr:</strong></br/>
              &nbsp;&nbsp;<strong>rule_expr</strong>[|rule_expr ...]<br/><br/>
              <strong>rule_expr</strong></br/>
              &nbsp;&nbsp;min,max,color
            </code>
          </p>
          <p>
            For example, suppose one wishes to define the following rules:
          </p>
          <p>
            <ul>
              <li>Where less than 100 records exist, use a transparent red (#FF000033)</li>
              <li>Where 100-10000 records exist, use a transparent green (#00FF0033)</li>
              <li>Where 10000 or more records exist, use a transparent blue (#0000FF33)</li>
            </ul>
          </p>
          <p>The resultant ruleset (before encoding would be):</p>
          <p>
            <code>
              ,100,#FF000033|100,10000,#00FF0033|10000,,#0000FF33
            </code>
          </p>
          <p>
            The <a href="#preview">preview functionality</a> allows you to test styles.
            A very useful resource providing color advice for cartographers is <a href="http://colorbrewer2.org">colorbrewer2.org</a>.
          </p>

          <p><strong>Saturation and Hue</strong></p>
          <p>If you set <strong>&saturation</strong> to true then you can specify a <strong>&hue</strong> between 0.0 and 1.0 and achieve a very different effect when visualizing the GBIF data. These settings are what allow maps as seen on the <a href="/occurrence">occurrence homepage</a>. It is a very different way of describing colour from what is described above - Wikipedia has <a href="http://en.wikipedia.org/wiki/HSV_color_space" target="_blank">a
              good introduction to Hue, Saturation, and Brightness</a>.</p>
        </div>
      </div>
      <footer></footer>
    </article>

	<a name="preview"></a>
    <article class="results">
      <header></header>
      <div class="content">
        <div class="header">
          <div class="left">
            <h4>Preview</h4>
          </div>
          <div class="right">
            <h4>Customise</h4>
          </div>
        </div>

        <div class="left">
          <div id="map" style="width: 100%; height: 500px;"></div>
          <p>
            Type
            <select id="type">
              <option value="TAXON">Taxon</option>
              <option value="COUNTRY">Country</option>
              <option value="PUBLISHING_COUNTRY">Publishing Country</option>
              <option value="DATASET">Dataset</option>
              <option value="PUBLISHER">Publisher</option>
            </select>
          </p>
          <p>
             Key (or ISO country code) <input size="10" id="key" value="1"/> <input type="submit" class="refresh" value="Refresh"/>
          </p>
          <p>
            Configured URL template (replace the {x},{y} and {z} accordingly):
          </p>
          <span id="urlTemplate"/>
        </div>
        <div class="right">
          <div class="refine">
            <div class="facet">
              <ul>
                <li>
                  <h4>Customize the layer</h4>
                  <table class="bor_time">
                    <tr>
                      <td/>
                      <td><h4><a href="#" id="OBS" class="toggle">Obs.</a></h4></td>
                      <td><h4><a href="#" id="SP" class="toggle">Spe.</a></h4></td>
                      <td><h4><a href="#" id="OTH" class="toggle">Oth.</a></h4></td>
                    </tr>

                    <#-- Render a single row -->
                    <#macro row label postfix>
                      <tr>
                        <td><h4>${label}</h4></td>
                        <td><input type="checkbox" class="layer" id="OBS_${postfix}" checked/></td>
                        <td><input type="checkbox" class="layer" id="SP_${postfix}" checked/></td>
                        <td><input type="checkbox" class="layer" id="OTH_${postfix}" checked/></td>
                      </tr>
                    </#macro>
                    <@row label='No year' postfix='NO_YEAR'/>
                    <#-- Loop for the years -->
                    <#list 190..200 as i>
                      <#assign year=i*10>
                      <@row label='${year?c}-${(year+10)?c}' postfix='${year?c}_${(year+10)?c}'/>
                    </#list>
                    <@row label='2010+' postfix='2010_2020'/>
                    <tr class="separator">
                      <td><h4>Living</h4></td>
                      <td><input type="checkbox" class="layer" id="LIVING" checked/></td>
                      <td colspan="2"/>
	                </tr>
                    <tr>
                      <td><h4>Fossil</h4></td>
                      <td><input type="checkbox" class="layer" id="FOSSIL" checked/></td>
                      <td colspan="2"/>
	                </tr>
                  </table>
                </li>
              </ul>
            </div>
          </div>
          <div class="refine">
            <div class="facet">
              <ul>
                <li>
                  <h4>Customize the color</h4>
                  <table class="color">
                    <tr>
                      <td>&nbsp;<input type="radio" name='palette' class="color" id="yellows_reds" checked/></td>
                      <td style="background-color:#FFFF00"></td>
                      <td style="background-color:#FFCC00"></td>
                      <td style="background-color:#FF9900"></td>
                      <td style="background-color:#FF6600"></td>
                      <td style="background-color:#FF3300"></td>
                      <td style="background-color:#CC0000"></td>
                    </tr>
                    <tr>
                      <td>&nbsp;<input type="radio" name='palette' class="color" id="blues"/></td>
                      <td style="background-color:#EFF3FF"></td>
                      <td style="background-color:#C6DBEF"></td>
                      <td style="background-color:#9ECAE1"></td>
                      <td style="background-color:#6BAED6"></td>
                      <td style="background-color:#3182BD"></td>
                      <td style="background-color:#08519C"></td>
                    </tr>
                    <tr>
                      <td>&nbsp;<input type="radio" name='palette' class="color" id="greens"/></td>
                      <td style="background-color:#EDF8E9"></td>
                      <td style="background-color:#C7E9C0"></td>
                      <td style="background-color:#A1D99B"></td>
                      <td style="background-color:#74C476"></td>
                      <td style="background-color:#31A354"></td>
                      <td style="background-color:#006D2C"></td>
                    </tr>
                    <tr>
                      <td>&nbsp;<input type="radio" name='palette' class="color" id="greys"/></td>
                      <td style="background-color:#F7F7F7"></td>
                      <td style="background-color:#D9D9D9"></td>
                      <td style="background-color:#BDBDBD"></td>
                      <td style="background-color:#969696"></td>
                      <td style="background-color:#636363"></td>
                      <td style="background-color:#252525"></td>
                    </tr>
                    <tr>
                      <td>&nbsp;<input type="radio" name='palette' class="color" id="oranges"/></td>
                      <td style="background-color:#FEEDDE"></td>
                      <td style="background-color:#FDD0A2"></td>
                      <td style="background-color:#FDAE6B"></td>
                      <td style="background-color:#FD8D3C"></td>
                      <td style="background-color:#E6550D"></td>
                      <td style="background-color:#A63603"></td>
                    </tr>
                    <tr>
                      <td>&nbsp;<input type="radio" name='palette' class="color" id="purples"/></td>
                      <td style="background-color:#F2F0F7"></td>
                      <td style="background-color:#DADAEB"></td>
                      <td style="background-color:#BCBDDC"></td>
                      <td style="background-color:#9E9AC8"></td>
                      <td style="background-color:#756BB1"></td>
                      <td style="background-color:#54278F"></td>
                    </tr>
                    <tr>
                      <td>&nbsp;<input type="radio" name='palette' class="color" id="reds"/></td>
                      <td style="background-color:#FEE5D9"></td>
                      <td style="background-color:#FCBBA1"></td>
                      <td style="background-color:#FC9272"></td>
                      <td style="background-color:#FB6A4A"></td>
                      <td style="background-color:#DE2D26"></td>
                      <td style="background-color:#A50F15"></td>
                    </tr>
                    <tr>
                      <td colspan="7">&nbsp;</td>
                    </tr>
                    <tr>
                      <td>&nbsp;<input type="radio" name='palette' class="color" id="custom"/></td>
                      <td colspan="6">
                        <textarea rows="6" id="colorset">,100,#FF000033|100,10000,#00FF0033|10000,,#0000FF33</textarea><br/>
	                    <input type="button" class="refresh" value="Refresh"/>
	                  </td>
                    </tr>
                  </table>
                </li>
              </ul>
            </div>
          </div>
        </div>
      </div>
      <footer></footer>
    </article>

  </body>
</html>
