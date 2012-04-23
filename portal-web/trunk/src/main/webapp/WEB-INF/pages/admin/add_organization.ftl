<#import "/WEB-INF/macros/common.ftl" as common>
<html>
<head>
  <title>Add Organization - GBIF</title>
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
        <li class="active"><h2>Add Organization</h2></li>
        <li class="last"><h2>Finish</h2></li>
      </ul>


      <p>Please fill in the necessary fields:</p>
      <#if fieldErrors.size() != 0>
        Errors have been detected!
        <@s.fielderror/>
      </#if>
      <div class="important">
        <div class="top"></div>
        <div class="inner">
          <@s.form action="organization/add/step">
            <#include "basic_organization.ftl">                           
	        
            <div class="field">
              <p>CONTACTS  [ <a href="#">add contacts</a> ] - popup to add a new contact
                <ul class="team">
                  <#list (organization!).contacts! as c>
                  <li>
                    <img src="<@s.url value='/img/minus.png'/>">
                      <@common.contact con=c />
                  </li>
                </#list>
              </ul>
            </div>
            
            <table>
            <div id="tempContacts">...</div>
            </table>
            
            <button id="create-contact">Create new contact</button>
            <button id="create-endpoint">Create new endpoint</button>
            <button id="create-tag">Create new tag</button>
            <button id="create-identifier">Create new identifier</button>

            
             
            <div class="field">
              <p>GBIF Endorsing Node</p>
              <!-- TODO: all nodes still need to be loaded up. Service class can't return full list of nodes.  -->
              <!-- Action class can page through results and consolidate a list of all nodes.  -->
              <@s.select name="organization.endorsingNodeKey" value="'${(organization!).endorsingNodeKey!}'" list="nodes" 
               listKey="key" listValue="title" headerKey="" headerValue="Choose a node"/>
               <@s.fielderror fieldName="organization.endorsingNodeKey"/>
            </div>          

            <nav><@s.submit title="Add" class="candy_white_button next" value="Add"><span>Save Changes</span></@s.submit>         
          </@s.form>
       
          <div id="dialog-contact" title="Create new contact"></div>
          <div id="dialog-endpoint" title="Create new endpoint"></div>
          <div id="dialog-tag" title="Create new tag"></div>
          <div id="dialog-identifier" title="Create new identifier"></div>

          
        </div>
        <div class="bottom"></div>
      </div>

        <p>When you are sure about the changes, press 'Save Changes'</p></nav>
    </div>
    <footer></footer>
  </article>
</body>
</html>
