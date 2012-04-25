<#import "/WEB-INF/macros/common.ftl" as common>
<html>
<head>
  <title>Edit Dataset - GBIF</title>
  <meta name="menu" content="datasets"/>
    <script type="text/javascript" src="<@s.url value='/js/vendor/jquery-1.7.1.min.js'/>"></script>
    <script type="text/javascript" src="<@s.url value='/js/custom/modal_form.js'/>"></script>
 
</head>
<body class="dataset">

  <article id="edit" class="tunnel">
    <header></header>
    <div class="content">
      <ul class="breadcrumb">
        <li><h2>Administration</h2></li>
        <li class="active"><h2>Edit Dataset</h2></li>
        <li class="last"><h2>Finish</h2></li>
      </ul>


      <p>Please edit the necessary fields:</p>
      <#if fieldErrors.size() != 0>
        Errors have been detected!
        <@s.fielderror/>
      </#if>      
      <div class="important">
        <div class="top"></div>
        <div class="inner">
          <@s.form action="dataset/${id}/edit/step">
            <#include "dataset.ftl">                           
          <nav><@s.submit title="Edit" class="candy_white_button next" value="Edit"><span>Save Changes</span></@s.submit></nav>             
        </@s.form>  
          
        </div>
      </div>



        <p>When you are sure about the changes, press 'Save Changes'</p></nav>
    </div>
    <footer></footer>
  </article>
</body>
</html>
