<#import "/WEB-INF/macros/common.ftl" as common>
<html>
  <head>
    <title>Newsroom Home</title>

    <#-- PLEASE PUT ALL JAVASCRIPT INTO THIS BLOCK, IT WILL GET RENDERED AT THE BOTTOM OF THE PAGE WITH ALL THE OTHER JS -->
    <content tag="extra_scripts">

    </content>

  </head>

  <body class="newsroom">

    <#assign tab="home"/>
    <#include "/WEB-INF/pages/newsroom/inc/infoband.ftl">

    <article>
    <header></header>
    <div class="content">
      <h1>Newsroom Home</h1>
      <p>Bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla.</p>
    </div>
    <footer></footer>
    </article>

    <article class="data-use-news">
    <header></header>
    <div class="content">

      <div class="header">
        <div class="left">
          <h2>Data use news</h2>
          <p>How data accessed via GBIF are being used in science and policy. </p>
        </div>
      </div>

      <div class="content">
      
        <ul>
          <li>
          <img src="http://placehold.it/270x170" />
          <a href="#">Vampire bats and cattle risks</a>
          <p>Research using data downloaded via GBIF has forecast the potential spread of cattle rabies carried by vampire bats in the Americas, both under present conditions and under future climate change scenarios.</p>
          <div class="ocurrences">984 occurrence records used</div>
          </li>
          <li>
          <img src="http://placehold.it/270x170" />
          <a href="#">Vampire bats and cattle risks</a>
          <p>Research using data downloaded via GBIF has forecast the potential spread of cattle rabies carried by vampire bats in the Americas, both under present conditions and under future climate change scenarios.</p>
          <div class="ocurrences">984 occurrence records used</div>
          </li>
          <li class="last">
          <img src="http://placehold.it/270x170" />
          <a href="#">Vampire bats and cattle risks</a>
          <p>Research using data downloaded via GBIF has forecast the potential spread of cattle rabies carried by vampire bats in the Americas, both under present conditions and under future climate change scenarios.</p>
          <div class="ocurrences">984 occurrence records used</div>
          </li>
        </ul>

        <a href="#" class="candy_white_button more_news next lft"><span>More data use news</span></a>
        
      
      </div>


    </div>
    <footer></footer>
    </article>

  </body>
</html>
