<html>
<head>
  <title>Dataset discussion - GBIF</title>

</head>
<body>

  <content tag="infoband">
    <ul class="breadcrumb">
      <li class="last"><a href="<@s.url value='/dataset'/>" title="Datasets">Datasets</a></li>
    </ul>

    <h1>Pontaurus collection</h1>

    <h3 class="separator">Provided by <a href="<@s.url value='/member/123'/>">Botanic Garden and Botanical Museum
      Berlin-Dahlem</a>
    </h3>
    <ul class="tags">
      <li><a href="#" title="Turkey">Turkey</a></li>
      <li><a href="#" title="coastal">coastal</a></li>
      <li class="last"><a href="#" title="herbal">herbal</a></li>
    </ul>

    <div class="box">
      <div class="content">
        <ul>
          <li><h4>123,356</h4>occurrences</li>
          <li><h4>349</h4>species</li>
          <li class="last"><h4>23</h4>taxa</li>
        </ul>
        <a href="#" title="Download occurrences"
           class="candy_blue_button download"><span>Download occurrences</span></a>
      </div>
    </div>
  </content>

  <content tag="tabs">
    <div id="tabs">
      <ul>
        <li><a href="<@s.url value='/dataset/${id}'/>"><span>Information</span></a></li>
        <!-- TODO: dynamically display occurrences entry only for occurrence datasets -->
        <li><a href="<@s.url value='/dataset/${id}/occurrence'/>"><span>Occurrences</span></a></li>
        <li><a href="<@s.url value='/dataset/${id}/activity'/>"><span>Activity <sup>(2)</sup></span></a></li>
        <li class="selected"><a href="<@s.url value='/dataset/${id}/discussion'/>"><span>Discussion <sup>(5)</sup></span></a></li>
      </ul>
    </div>
  </content>

  <article class="comments">
    <header></header>
    <div class="content">
      <div class="header">
        <div class="left"><h2>3 comments on this dataset</h2></div>
      </div>
      <div class="comment">
        <div class="left">
          <p>This dataset is pretty cool, it’s almost what I need for my PhD on seahorse behaviour. But I find some
            problems in the performed methodology, and I would like to contact the author to check if it’s possible to
            access a raw, unprocessed dataset</p>

          <p>I’ve been processing the data on an Excel file and the total amount of occurrences I find does not match
            with the amount given by the GBIF filtering.</p>
        </div>
        <div class="right">

          <div class="mini-profile">
            <a href="#" class="avatar"><img src="<@s.url value='/external/temp/avatar.jpg'/>" title="Leslie Jackson" width="48"
                                            height="48"/></a>
            <strong>Leslie Jackson</strong>
            <span class="date">3 days ago</span>
          </div>

        </div>
      </div>

      <!-- reply -->

      <div class="comment">
        <div class="left">
          <p>Hi Leslie. I’ve had the same problemas and (good news!) they can be fixed. What you have to do is this and
            <a href="#">that</a> and.</p>
        </div>
        <div class="right">

          <div class="mini-profile">
            <a href="#" class="avatar"><img src="<@s.url value='/external/temp/avatar.jpg'/>" title="Leslie Jackson" width="48"
                                            height="48"/></a>
            <strong>Pneumonoultramicros- copicsilicovolcano</strong>
            <span class="date">2 days ago</span>
          </div>

        </div>
      </div>

      <div class="comment">
        <div class="left">
          <p>Mmm I disagree. I think this dataset has a big problem with the recolection methodology used for capturing
            seahorses. The author is using lactose to bail them, a well-recognized toxic substance for this kind of
            creatures.</p>
        </div>
        <div class="right">

          <div class="mini-profile">
            <a href="#" class="avatar"><img src="<@s.url value='/external/temp/avatar_diego.jpg'/>" title="Juan Diego Cano" width="48"
                                            height="48"/></a>
            <strong>Juan Diego Cano</strong>
            <span class="date">5 days ago</span>
          </div>
        </div>
      </div>
    </div>
    <footer></footer>
  </article>

  <article class="reply">
    <header></header>
    <div class="content">
      <h2>Join the discussion</h2>

      <div class="left">
        <h3>PUT YOUR COMMENT</h3>

        <form>
          <textarea name="comment"></textarea>
          <button type="submit" class="candy_blue_button"><span>Post comment</span></button>
        </form>
      </div>
      <div class="right">
        <h4>LOGGED IN AS...</h4>

        <div class="mini-profile">
          <a href="#" class="avatar"><img src="<@s.url value='/external/temp/avatar.jpg'/>" title="Moises Raimon" width="48" height="48"/></a>
          <strong>Florian Maria Georg von Donnersmarck</strong>
          <a class="login" href="#">Login as different user</a>
        </div>

      </div>
    </div>
    <div class="triangle"></div>
    <div class="header"></div>
    <footer></footer>
  </article>
</body>
</html>
