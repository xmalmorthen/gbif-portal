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

    <article data-options="autoplay" class="slideshow">
    <header></header>
    <div class="content">
      <div class="header">
        <div class="left">
          <h4>FEATURED</h4>
          <ul class="bullets"></ul>
        </div>
      </div>

      <div class="left data"></div>

      <div class="right"> 
        <ul class="photos"></ul>
      </div>

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

      <div class="inner">

        <ul>
          <li>
          <a href="<@s.url value='/newsroom/uses/1'/>">
            <img src="<@s.url value='/img/dummies/batdummy.jpg'/>" />
          </a>
          <a href="<@s.url value='/newsroom/uses/1'/>" class="title">Vampire bats and cattle risks</a>
          <p>Research using data downloaded via GBIF has forecast the potential spread of cattle rabies carried by vampire bats in the Americas, both under present conditions and under future climate change scenarios.</p>
          <div class="ocurrences">984 occurrence records used</div>
          </li>

          <li>
          <a href="<@s.url value='/newsroom/uses/2'/>">
            <img src="<@s.url value='/img/dummies/aphdummy.jpg'/>" />
          </a>
          <a href="<@s.url value='/newsroom/uses/2'/>" class="title">Vampire bats and cattle risks</a>
          <p>Research using data downloaded via GBIF has forecast the potential spread of cattle rabies carried by vampire bats in the Americas, both under present conditions and under future climate change scenarios.</p>
          <div class="ocurrences">984 occurrence records used</div>
          </li>

          <li class="last">
          <a href="<@s.url value='/newsroom/uses/3'/>">
            <img src="<@s.url value='/img/dummies/ecodummy.jpg'/>" />
          </a>
          <a href="<@s.url value='/newsroom/uses/3'/>" class="title">Vampire bats and cattle risks</a>
          <p>Research using data downloaded via GBIF has forecast the potential spread of cattle rabies carried by vampire bats in the Americas, both under present conditions and under future climate change scenarios.</p>
          <div class="ocurrences">984 occurrence records used</div>
          </li>
        </ul>

        <a href="<@s.url value='/newsroom/uses'/>" class="candy_white_button more_news next lft"><span>More data use news</span></a>


      </div>


    </div>
    <footer></footer>
    </article>

    <article class="news">
    <header></header>
    <div class="content">

      <div class="header">
        <div class="left">
          <h2>GBIF news</h2>
          <p>Latest stories from around our community</p>
        </div>
      </div>

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
          <div class="subscribe">
            <h3>GBITS NEWSLETTER</h3>
            <p>Keep up to date with the latest GBIF news by signing up to GBits</p>

            <form action="">
              <div class="input_text">
                <input type="text" name="q" placeholder="Enter your email" />
              </div>
            </form>

            <a href="" class="candy_blue_button"><span>Sign up</span></a>

          </div>

        </div>
      </div>


    </div>
    <footer></footer>
    </article>

    <script type="text/javascript">
      $(function() {

        var slides = [
          { 
            title: "GBIF Finland pioneers digitization ‘assembly line’",
            description: "Digitarium, the digitization centre for the Finnish Museum of Natural History and University of Eastern Finland is building an assembly line for mass digitization.  The idea is to accelerate the process of turning plant and insect specimens into digital data, unlocking centuries of knowledge for universal access.",
            src: "<@s.url value='/img/tmp/slide01.jpg'/>",
            url: "http://www.url.com/1"
          }, { 
            title: "Title", 
            description: "Description",
            src: "<@s.url value='/img/tmp/slide02.jpg'/>",
            url: "http://www.url.com/2"
          }, { 
            title: "Title2", 
            description: "Description",
            src: "<@s.url value='/img/tmp/slide03.jpg'/>",
            url: "http://www.url.com/3"
          }, { 
            title: "Title3", 
            description: "Description",
            src: "<@s.url value='/img/tmp/slide04.jpg'/>",
            url: "http://www.url.com/4"
          }, { 
            title: "Title4", 
            description: "Description",
            src: "<@s.url value='/img/tmp/slide05.jpg'/>",
            url: "http://www.url.com/5"
          }

        ];

        $(".slideshow").bindArticleSlideshow(slides);

      });

    </script>

  </body>
</html>
