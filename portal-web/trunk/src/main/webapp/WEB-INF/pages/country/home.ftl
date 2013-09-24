<#import "/WEB-INF/macros/common.ftl" as common>
<html>
<head>
  <title>Countries, territories and islands</title>
    <style type="text/css">
        .column {
          width: 196px;
          padding-right: 20px;
          float: left;
        }
        
        ul.countries {
          list-style-type: none !important;
          list-style: none !important;
        }
        
        ul.countries li {
          list-style-type: none !important;
          list-style: none !important;
        }
        ul.countries li.node:after {
          content : "*";
          margin-left:5px;
        }
    </style>
</head>

<body class="infobandless">



<#macro continentArticle continent>
  <@common.article id=continent class="countries" title=continent?replace("_", " ")?capitalize>
    <div class="fullwidth">
      <#assign column=0>
      <#assign ulOpen=false>
      <#assign rowsPerColumn= (continentMap.listCountries(continent).size()/4)?ceiling>

      <#list continentMap.listCountries(continent) as c>
        <#-- manage the columns -->
        <#if c_index%rowsPerColumn == 0>
          <#-- close previous list -->
          <#if ulOpen>
            </ul>
            </div>
          </#if>
          <div class="column">
          <ul class="countries">
          <#assign ulOpen=true>
        </#if>

        <li class="country<#if activeNodes.contains(c)> node</#if>"><a href="<@s.url value='/country/${c.getIso2LetterCode()}'/>">${c.getTitle()}</a></li>
      </#list>

      <#-- close last-->
      <#if ulOpen>
        </ul>
        </div>
      </#if>
      
    </div>
  </@common.article>
</#macro>



<@common.article id="country_list" title="Countries, territories and islands" titleRight="Continents">
  <div class="left">
    <p>Index to all countries grouped by continents. Countries that are active GBIF Nodes are marked with a *.  <a href="<@s.url value='/participation/list#other'/>">Other GBIF Participant organizations</a> are not listed here.
    </p>
    <p>Names of countries, territories and islands are based on the
        <a href="http://www.iso.org/iso/country_codes/iso_3166_code_lists/country_names_and_code_elements.htm">ISO 3166-1</a> standard.
    </p>
  </div>

  <div class="right">
    <ul>
    <#list continents as cont>
      <li><a href="#${cont}">${cont?replace("_", " ")?capitalize}</a></li>
    </#list>
    </ul>
  </div>
</@common.article>

<#list continents as cont>
  <@continentArticle continent=cont />
</#list>



</body>
</html>
