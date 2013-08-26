# /etc/varnish/maintenance.vcl 
backend default {
  .host = "130.226.238.148";    
  .port = "8080";   
}

sub vcl_recv { 
  if ( req.url ~ "^/portal/css/" || req.url ~ "^/portal/img/" ) {
    return (lookup);    
  }
  error 503; 
}   

sub vcl_error { 
  set obj.http.Content-Type = "text/html; charset=utf-8";
  synthetic {"
  <html class='no-js' lang='en' xmlns='http://www.w3.org/1999/xhtml'>
  <head>
    <meta charset='utf-8'>
    <title property='dc:title'>Maintenance</title>
    <link rel='stylesheet' href='/portal/css/style.css'/>
  </head>
  <body class='infobandless'>
    <header>
    <!-- top -->
    <div id='top'>
      <div class='content'>
        <div class='account'>
          <a title='Login'>Login</a> or
          <a title='Create a new account'>Create a new account</a>
        </div>

        <div id='logo'>
          <a class='logo'><img src='/portal/img/header/logo.png' alt='GBIF'/></a>
          <h1><a title='GBIF.ORG'>GBIF.ORG</a></h1>
          <span>Free and open access to biodiversity data</span>
        </div>

      <nav>
        <ul>
          <li>
            <a href='#' title='Data'>Data</a>
          </li>
          <li>
            <a href='#' title='About GBIF'>About GBIF</a>
          </li>
          <li>
            <a href='#' title='Community'>Community</a>
          </li>
          <li>
            <a href='#' title='About GBIF'>Newsroom</a>
          </li>

          <li class='search'>
          <form>
            <span class='input_text'>
              <input type='text' name='q' disabled='true'/>
            </span>
          </form>
          </li>
        </ul>
        </nav>
      </div>
    </div>
    </header>

    <div id='content'>
      <article class='dataset'>
      <header></header>
      <div class='content'>
        <h1>Down For Maintenance</h1>
        <p>We are deploying a new version of the GBIF data portal.<br/>
           We are sorry for the inconvenience, but thanks to your constructive feedbacks<br/>
           it will be much improved and back online shortly!
        </p>
      </div>
      <footer></footer>
    </article>
    </div>

    <footer>
      <div class='footer' style='height:70px'>
        </div>
    </footer>

    <div id='contact_footer'>
      <div class='footer'>
        <ul>
            <li><h3>2013 &copy; GBIF</h3></li>
            <li><div class='logo'></div></li>
        </ul>

        <ul>
            <li><h3>GBIF Secretariat</h3></li>
            <li>Universitetsparken 15</li>
            <li>DK-2100 Copenhagen</li>
            <li>DENMARK</li>
        </ul>

        <ul>
          <li><h3>Contact</h3></li>
          <li><strong>Email</strong> info@gbif.org</li>
          <li><strong>Tel</strong> +45 35 32 14 70</li>
          <li><strong>Fax</strong> +45 35 32 14 80</li>
        </ul>

        <ul class='last'>
            <li><h3>SOCIAL MEDIA</h3></li>
            <li class='twitter'><a href='https://twitter.com/GBIF'>Follow GBIF on Twitter</a></li>
            <li class='facebook'><a href='https://www.facebook.com/gbifnews'>Like GBIF on Facebook</a></li>
            <li class='linkedin'><a href='http://www.linkedin.com/groups/GBIF-55171'>Join GBIF on Linkedin</a></li>
            <li class='vimeo'><a href='http://vimeo.com/gbif'>View GBIF on Vimeo</a></li>
        </ul>

      </div>
    </div>
  </body>
  </html>
"}; 
  return (deliver); 
} 