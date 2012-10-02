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

<body class="newsroom">

  <article class="news">
  <header></header>
  <div class="content">

    <div class="content">
      <div class="left">
        <ul>
          <li>
          <h4 class="date">DEC 15TH 2011</h4>
          <a href="<@s.url value='/newsroom/news/1'/>" class="title">Conference targets priorities for biodiversity ‘intelligence’</a>
          <p>A landmark conference has agreed key priorities for harnessing the power of information technologies and social networks to understand better the workings of life on Earth. </p>
          <a href="<@s.url value='/newsroom/news/1'/>" class="read_more">Read more</a>
          </li>

          <li>
          <h4 class="date">DEC 15TH 2011</h4>
          <a href="<@s.url value='/newsroom/news/2'/>" class="title">Conference targets priorities for biodiversity ‘intelligence’</a>
          <p>A landmark conference has agreed key priorities for harnessing the power of information technologies and social networks to understand better the workings of life on Earth. </p>
          <a href="<@s.url value='/newsroom/news/2'/>" class="read_more">Read more</a>
          </li>

          <li>
          <h4 class="date">DEC 15TH 2011</h4>
          <a href="<@s.url value='/newsroom/news/3'/>" class="title">Conference targets priorities for biodiversity ‘intelligence’</a>
          <p>A landmark conference has agreed key priorities for harnessing the power of information technologies and social networks to understand better the workings of life on Earth. </p>
          <a href="<@s.url value='/newsroom/news/3'/>" class="read_more">Read more</a>
          </li>

        </ul>

        <a href="<@s.url value='/newsroom/news'/>" class="candy_white_button more_news next lft"><span>More GBIF news</span></a>
      </div>

      <div class="right">

        <div class="filters">
          <h3>Filter news by region</h3>
  
          <ul>
            <li class="selected"><a href="#">All news</a></li>
            <li><a href="#">Global</a></li>
            <li><a href="#">Africa</a></li>
            <li><a href="#">Asia</a></li>
            <li><a href="#">Europe</a></li>
            <li><a href="#">Latin America</a></li>
            <li><a href="#">North America</a></li>
            <li><a href="#">Oceania</a></li>
          </ul>
        </div>

      </div>
    </div>


  </div>
  <footer></footer>
  </article>


</body>
</html>
