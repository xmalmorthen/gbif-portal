<html>
<head>
  <title>Login Required</title>
</head>
<body class="infobandless">

  <article class="dataset">
    <header></header>
    <div class="content">

      <h1>Login Required</h1>
      <p>You need to be logged in to use this part of the portal.</p>
      <p>
        <a href="${cfg.drupal}/user/login?destination=${currentDestinationParam?url}" title='<@s.text name="menu.login"/>'><@s.text name="menu.login"/></a>
        with an existing account or
        <a href="${cfg.drupal}/user/register" title='<@s.text name="menu.register"/>'><@s.text name="menu.register"/></a> first.
      </p>

    </div>
    <footer></footer>
  </article>


</body>
</html>
