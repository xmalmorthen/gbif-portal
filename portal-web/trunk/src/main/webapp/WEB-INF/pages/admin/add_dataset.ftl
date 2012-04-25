<#import "/WEB-INF/macros/common.ftl" as common>
<html>
<head>
  <title>Add Dataset - GBIF</title>
  <meta name="menu" content="datasets"/>
    <script type="text/javascript" src="<@s.url value='/js/vendor/jquery-1.7.1.min.js'/>"></script>
    <script type="text/javascript" src="<@s.url value='/js/custom/contact_form.js'/>"></script>
    <script type="text/javascript" src="<@s.url value='/js/custom/endpoint_form.js'/>"></script>
    <script type="text/javascript" src="<@s.url value='/js/custom/tag_form.js'/>"></script>          
    <script type="text/javascript" src="<@s.url value='/js/custom/identifier_form.js'/>"></script>          
</head>
<body class="dataset">

  <article id="edit" class="tunnel">
    <header></header>
    <div class="content">
      <ul class="breadcrumb">
        <li><h2>Administration</h2></li>
        <li class="active"><h2>Add Dataset</h2></li>
        <li class="last"><h2>Finish</h2></li>
      </ul>
      <center>
        <a href="../organization/add">Add new organization</a> | Add new dataset | <a href="../network/add">Add new network</a>
      </center>
      <hr/>      


      <p>Please fill in the necessary fields:</p>
      <#if fieldErrors.size() != 0>
        Errors have been detected!
        <@s.fielderror/>
      </#if>
      <div class="important">
        <div class="top"></div>
        <div class="inner">
        <@s.form action="dataset/add/step">
        <#include "dataset.ftl"> 
          <nav><@s.submit title="Add" class="candy_white_button next" value="Add"><span>Save Changes</span></@s.submit></nav>             
        </@s.form>             
       
          <div id="dialog-contact" title="Create new contact"></div>
          <div id="dialog-endpoint" title="Create new endpoint"></div>
          <div id="dialog-tag" title="Create new tag"></div>
          <div id="dialog-identifier" title="Create new identifier"></div>

          
        </div>
        <div class="bottom"></div>
      </div>


            <button id="create-contact">Create new contact</button>
            <button id="create-endpoint">Create new endpoint</button>
            <button id="create-tag">Create new tag</button>
            <button id="create-identifier">Create new identifier</button>


        <p>When you are sure about the changes, press 'Save Changes'</p>
    </div>
    <footer></footer>
  </article>
</body>
</html>
