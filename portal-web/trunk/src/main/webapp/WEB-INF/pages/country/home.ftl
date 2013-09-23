<#import "/WEB-INF/macros/common.ftl" as common>
<html>
<head>
  <title>Countries, territories and islands</title>
    <style type="text/css">
        .countries .country {
            width: 196px;
            height: 35px;
            padding-right: 20px;
            float: left;
        }
        .countries .country .last{
            padding-right: 0px;
        }
        .countries .node a {
            text-decoration: underline;
        }
    </style>
</head>

<body class="infobandless">



<#macro continentArticle continent>
  <@common.article id=continent class="countries" title=continent?replace("_", " ")?capitalize>
    <div class="fullwidth">
      <ul>
      <#list continentMap.listCountries(continent) as c>
        <li class="country <#if activeNodes.contains(c)> node</#if> <#if c_index%4==3> last</#if>"><a href="<@s.url value='/country/${c.getIso2LetterCode()}'/>">${c.getTitle()}</a></li>
      </#list>
      </ul>
    </div>
  </@common.article>
</#macro>



<@common.article id="country_list" title="Countries, territories and islands" titleRight="Continents">
  <div class="left">
    <p>Index to all countries grouped by continents. Active GBIF Nodes are underlined.<br/>
        <a href="<@s.url value='/participation/list#other'/>">Other GBIF Participant organizations</a> are not listed here.
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
