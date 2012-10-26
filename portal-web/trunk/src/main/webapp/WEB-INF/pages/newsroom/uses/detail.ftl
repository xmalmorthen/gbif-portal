<#import "/WEB-INF/macros/common.ftl" as common>
<html>
  <head>
    <title>News Detail</title>
    <#-- PLEASE PUT ALL JAVASCRIPT INTO THIS BLOCK, IT WILL GET RENDERED AT THE BOTTOM OF THE PAGE WITH ALL THE OTHER JS -->
    <content tag="extra_scripts">

    </content>
  </head>

  <#assign tab="uses"/>
  <#include "/WEB-INF/pages/newsroom/inc/infoband.ftl">

  <body class="newsroom">

    <article class="detail">
    <header>
    </header>

    <div class="content">

      <div class="header">
        <div class="left">
          <h3>DATA USE NEWS</h3>
          <h1>Modelling geographic patterns of population density of the white-tailed deer in central Mexico by implementing ecological niche theory. </h1>

        </div>
      </div>

      <div class="left">
        <h4 class="subheader">A novel use of occurrence data could help to design better policies for conserving and sustainably managing wildlife species.</h4>
        <img class="mainImage" src="/img/dummies/bigdeerdummy.jpg"></img>

        <h5>SUMMARY</h5>

        <p>In this paper, a team from Mexico proposed and tested a new system of estimating the relative abundance of a species based only on data about where it occurs, combined with models of the ecological niche it occupies.</p>
        <p>Field research in two regions of Central Mexico on the white-tailed deer, a popular game species, were combined with occurrence records of the species obtained through GBIF and its Mexican partner Conabio.</p>
        <p>The researchers used these data to generate a model of the predicted range of the deer based on a set of nine environmental variables (an ecological niche model).</p>
        <p>For each pixel within the area of environmental suitability for the species, the “distance to the niche centroid” (DNC) was calculated - a multi-dimensional value representing how close any location is to the optimal set of conditions for the deer.</p>
        <p>This value was used to predict the density of deer across the two regions, and was found to correlate significantly with measures of actual density from the field studies.</p>
        <p>The authors suggest this could be a valuable tool for sustainable management and conservation of white-tailed deer and other species by estimating relative population density even when records of abundance are not available. </p>
      </div>

      <div class="right pushedDown">

        <ul>
          <li>
            <h5>PUBLICATION</h5>
            <span class="publisher"> Oikos </span>
          </li>
          <li class="location">
          <h5>PROJECT LOCATION</h5>
            <div class="minimap">
              <img src="/img/dummies/minimapdummy.png"></img>
            </div>
            <span class="description">
              <p>Instituto. de Ecología, Veracruz, México</p>
              <p>Depto de Zoología, Inst. de Biología, Univ. Nacional Autónoma de México</p>
            </span>
          </li>
          <li>
            <h5>DATE OF PUBLICATION</h5>
            <span class="date">15 August 2012 </span>
          </li>
          <li>
          <h5>AUTHOR</h5>
            <address>
              <strong>E. Martínez-Meyer</strong><br />
              <a href="#">emm@ibiologia.unam.mx</a>
            </address>
          </li>

        </ul>
      </div>

      <div class="left citation">
        <h3>CITATION INFORMATION</h3>
        <p>Yañez-Arenas, C. et al., 2012. <a href="#">Modelling geographic patterns of population density of the white-tailed deer in central Mexico by implementing ecological niche theory. </a> Oikos, online (March). [Accesed June 4, 2012]</p>
      </div>

      <div class="related footer">
        <h3>RELATED GBIF RESOURCES</h3>
        <ul>
          <li><a href="">652 published occurrences of white-tailed deer (Odocuileus virginianus)</a></li>
          <li><a href="">Biodivesity data published in Mexico</a></li>
        </ul>
      </div>
    </div>

    </article>


    <article class="next_news">
      <header></header>
      <div class="content">
        <h3>NEXT GBIF NEWS</h3>
        <a href=""><h1>A new vision for harnesing data about life on earth</h1></a>
      </div>
      <footer></footer>
    </article>
  </body>
</html>
