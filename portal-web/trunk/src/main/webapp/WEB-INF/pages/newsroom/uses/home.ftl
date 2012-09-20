<#import "/WEB-INF/macros/common.ftl" as common>
<html>
<head>
  <title>Usage Home</title>

  <#-- PLEASE PUT ALL JAVASCRIPT INTO THIS BLOCK, IT WILL GET RENDERED AT THE BOTTOM OF THE PAGE WITH ALL THE OTHER JS -->
  <content tag="extra_scripts">

  </content>
</head>


<body class="newsroom">
    <#assign tab="uses"/>
    <#include "/WEB-INF/pages/newsroom/inc/infoband.ftl">

    <article class="detail">
      <header></header>
      <div class="content">
        <div class="header">
          <div class="left">
            <h1> How data accessed through GBIF are being used </h1>
          </div>
        </div>
        <div class="usesMap">
          <img src="/img/dummies/mapdummy.jpg"></img>
        </div>
      </div>
    </article>
    <article class="data-use-news">
      <header></header>
      <div class="content">
        <div class="inner clean">
          <ul>
            <li>
              <img src="/img/dummies/batdummy.jpg"></img>
              <a class="title" href="<@s.url value='/newsroom/uses/1'/>">Vampire bats and cattle risks</a>
              <p>
                Research using data downloaded via GBIF has forecast the potential spread of cattle rabies carried by vampire bats in the Americas, both under present conditions and under future climate change scen
              </p>
              <div class="ocurrences">
                984 occurrence records used
              </div>
            </li>
            <li>
              <img src="/img/dummies/deerdummy.jpg"></img>
              <a class="title" href="<@s.url value='/newsroom/uses/1'/>">Modelling patterns of deer density in Mexico</a>
              <p>
                Data published through GBIF have helped devise a tool for conservation and sustainable management of white-tailed deer, by estimating the density of populations based only on occurrence data.
              </p>
              <div class="ocurrences">
                51 occurrence records used
              </div>
            </li>
            <li class="last">
              <img src="/img/dummies/ecodummy.jpg"></img>
              <a class="title" href="<@s.url value='/newsroom/uses/1'/>">Ecological value of landscapes  beyond protected areas</a>
              <p>
                The Local Ecological Footprint Tool (LEFT) uses records served through GBIF to help advise companies on the most ecologically-sensitive sites for new installations, for any land area on the planet.
              </p>
              <div class="ocurrences">
                101 datasets used
              </div>
            </li>
          </ul>
          <ul>
            <li>
              <img src="/img/dummies/aphdummy.jpg"></img>
              <a class="title" href="<@s.url value='/newsroom/uses/1'/>">In search of the perfect aphrodisiac </a>
              <p>
                Researchers have compared the botanical ingredients of more than 150 mixtures used as aphrodisiac ‘bitter tonics’ in Afro-Caribbean and West African herbal medicine.
              </p>
              <div class="ocurrences">
                325 plant species researched
              </div>
            </li>
            <li>
              <img src="/img/dummies/frogdummy.png"></img>
              <a class="title" href="<@s.url value='/newsroom/uses/1'/>">Secrets of success for alien frogs and toads</a>
              <p>
                A study used records of 99 species of frogs and toads, downloaded via GBIF, to gain insights into why some alien species become established in their new environments, and others do not.
              </p>
              <div class="ocurrences">
                408 occurrence records used
              </div>
            </li>
            <li class="last">
              <img src="/img/dummies/bugdummy.png"></img>
              <a class="title" href="<@s.url value='/newsroom/uses/1'/>">Responses to climate change in cold-blooded animals</a>
              <p>
                Tolerance to temperature changes among ectotherms (cold-blooded animals) offers clues about how the distribution of marine and terrestrial species will shift with climate change.
              </p>
              <div class="ocurrences">
                142 species studied
              </div>
            </li>
          </ul>

          <div class="buttonContainer">
            <a class="candy_white_button more_news next lft" href="/newsroom/news">
              <span>More data use news</span>
            </a>
          </div>
        </div>
      </div>

    </article>
</body>
</html>
