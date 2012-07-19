<html>
<head>
  <title>Your Account</title>
</head>
<body class="static">

  <content tag="infoband">
    <h1>${user.firstName!} ${user.lastName!}</h1>
    <h3>${user.email}</h3>
  </content>

  <article class="light_pane static">
    <header></header>
    <div class="content">

      <div class="left">
        <div class="header">
          <div class="left"><h2>Personal Information</h2></div>
        </div>

        <h3>Name</h3>
        <p>${user.firstName!} ${user.lastName!}&nbsp;</p>

        <h3>Email</h3>
        <p>${user.email!}</p>

        <h3>Country</h3>
        <p>${user.country!}&nbsp;</p>

        <h3>Degree</h3>
        <p>${user.degree!}&nbsp;</p>

        <h3>Study Field</h3>
        <p>${user.studyField!}&nbsp;</p>

        <h3>Data Usage Intend</h3>
        <p>${user.dataUsageIntend!}&nbsp;</p>

      </div>

      <div class="right">
        <h3>Affiliation</h3>
        <ul>
          <li><a href="#">${user.organisation!}</a></li>
          <li><a href="#">${user.organisationKey!}</a></li>
          <#list user.editingRights as uuid>
            <li><a href="<@s.url value='/member/${uuid}'/>">${uuid}</a></li>
          </#list>
        </ul>

        <h3>Name Lists</h3>
        <ul>
          <li><a href="#">Vertebrate genera</a></li>
          <li><a href="#">Research A</a></li>
          <li><a href="#">Backyard birdlist</a></li>
        </ul>
      </div>

    </div>
    <footer></footer>
  </article>

  <article class="light_pane static">
    <header></header>
    <div class="content">

      <div class="left">
        <div class="header">
          <div class="left"><h2>Settings</h2></div>
        </div>

        <h3>Password</h3>
        <p>${user.password!}&nbsp;</p>

        <h3>Default Language</h3>
        <p>${user.defaultLanguage!}&nbsp;</p>

        <h3>Default Taxonomy</h3>
        <p>${user.defaultTaxonomy!}&nbsp;</p>
      </div>

      <div class="right">
        <h3>Debugging</h3>
        <p>Admin: ${user.admin?string}</p>
        <p>Roles: <#list user.roles as r>${r} </#list></p>
      </div>

    </div>
    <footer></footer>
  </article>

</body>
</html>