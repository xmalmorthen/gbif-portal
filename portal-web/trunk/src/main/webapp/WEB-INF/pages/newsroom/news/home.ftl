<#import "/WEB-INF/macros/common.ftl" as common>
<html>
<head>
  <title>News Home</title>
  <#-- PLEASE PUT ALL JAVASCRIPT INTO THIS BLOCK, IT WILL GET RENDERED AT THE BOTTOM OF THE PAGE WITH ALL THE OTHER JS -->
  <content tag="extra_scripts">

  </content>
</head>

<#assign tab="news"/>
<#include "/WEB-INF/pages/newsroom/inc/infoband.ftl">

<body class="dataset">

  <article class="dataset">
    <header></header>
    <div class="content">
      <h1>News Home</h1>
      <ul>
        <li><a href="<@s.url value='/newsroom/news/1'/>">News 1</li>
        <li><a href="<@s.url value='/newsroom/news/2'/>">News 2</li>
        <li><a href="<@s.url value='/newsroom/news/3'/>">News 3</li>
      </ul>
    </div>
    <footer></footer>
  </article>
</body>
</html>
