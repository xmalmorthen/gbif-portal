<#import "/WEB-INF/macros/common.ftl" as common>
<html>
<head>
  <title>Usage Home</title>

  <#-- PLEASE PUT ALL JAVASCRIPT INTO THIS BLOCK, IT WILL GET RENDERED AT THE BOTTOM OF THE PAGE WITH ALL THE OTHER JS -->
  <content tag="extra_scripts">

  </content>
</head>

<#assign tab="uses"/>
<#include "/WEB-INF/pages/newsroom/inc/infoband.ftl">

<body class="dataset">

  <article class="dataset">
    <header></header>
    <div class="content">
      <h1>Uses of data Home</h1>
      <ul>
        <li><a href="<@s.url value='/newsroom/uses/1'/>">Data Use 1</li>
        <li><a href="<@s.url value='/newsroom/uses/2'/>">Data Use 2</li>
        <li><a href="<@s.url value='/newsroom/uses/3'/>">Data Use 3</li>
      </ul>
    </div>
    <footer></footer>
  </article>
</body>
</html>
