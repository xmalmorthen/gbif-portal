<#import "/WEB-INF/macros/common.ftl" as common>
<html>
<head>
  <title>Edit Organization - GBIF</title>
  <meta name="menu" content="datasets"/>
</head>
<body class="dataset">

  <article id="step-1" class="tunnel">
    <header></header>
    <div class="content">
      <ul class="breadcrumb">
        <li><h2>Administration</h2></li>
        <li class="active"><h2>Edit Organization</h2></li>
        <li class="last"><h2>Finish</h2></li>
      </ul>

      <p>Please edit the necessary fields:</p>

      <div class="important">
        <div class="top"></div>
        <div class="inner">
          <form>

			<div class="field">
              <p>TITLE</p>
                <input id="title" name="title" type="text" value="${member.title!}"/>
            </div>

            <div class="field">
              <p>DESCRIPTION</p>
              <textarea rows="2" cols="20">${member.description!}</textarea>
            </div>

			<div class="field">
              <p>ADDRESS</p>
                <input id="address" name="address" type="text" value="${member.address!}"/>
            </div>
            
			<div class="field">
              <p>CITY</p>
                <input id="city" name="city" type="text" value="${member.city!}"/>
            </div>         
            
			<div class="field">
              <p>ZIP</p>
                <input id="zip" name="zip" type="text" value="${member.zip!}"/>
            </div>        
            
			<div class="field">
              <p>COUNTRY (will be changed soon to a country drop down list with proper country names)</p>
                <input id="country" name="country" type="text" value="${member.isoCountryCode!}"/>
            </div>        
            
			<div class="field">
              <p>HOMEPAGE</p>
                <input id="homepage" name="homepage" type="text" value="${member.homepage!}"/>
            </div>                
            
			<div class="field">
              <p>LOGO URL</p>
                <input id="logoUrl" name="logoUrl" type="text" value="${member.logoURL!}"/>
            </div>                                  
	        
            <div class="field">
              <p>CONTACTS  [ <a href="#">add contacts</a> ] - popup to add a new contact
                <ul class="team">
                  <#list member.contacts as c>
                  <li>
                    <img src="<@s.url value='/img/minus.png'/>">
                      <@common.contact con=c />
                  </li>
                </#list>
              </ul>
            </div>

            <div class="field">
              <p>GBIF endorsing node</p>
              <select id="endorsing_node" class="endorsing_node" name="endorsing_node">
                <option value="">Select one of the list below...</option>
                <option value="endorsing_node-1">ACB</option>
                <option value="endorsing_node-2">Andorra</option>
                <option value="endorsing_node-3" selected>Austria</option>
                <option value="endorsing_node-4">Argentina</option>
              </select>
            </div>
            <p/>
            <div class="field">
              <p>Network links</p>
              <select multiple id="endorsing_node" class="endorsing_node" name="endorsing_node">
                <option value="">Select one of the list below...</option>
                <option value="network-1" selected>VertNET</option>
                <option value="network-2">IABIN</option>
                <option value="network-3" selected>African Territory</option>
                <option value="network-4">Natural History Institutions</option>
              </select>
            </div>  
            <p/>      
            <div class="field">
              <p>Technical Partners (not editable from here. The reasoning behind this, is that a Technical Partner
              is one who hosts datasets for this organization, hence the association should be changed at the dataset level)</p>
              <select multiple id="endorsing_node" class="endorsing_node" name="endorsing_node" DISABLED>
                <option value="">Select one of the list below...</option>
                <option value="network-1" selected>VertNET</option>
                <option value="network-2">IABIN</option>
                <option value="network-3" selected>African Territory</option>
                <option value="network-4">Natural History Institutions</option>
              </select>
            </div>                     
          </form>
        </div>
        <div class="bottom"></div>
      </div>

      <nav><a href="<@s.url value='#'/>" title="Edit" class="candy_white_button next"><span>Save Changes</span></a>

        <p>When you are sure about the changes, press 'Save Changes'</p></nav>
    </div>
    <footer></footer>
  </article>
</body>
</html>
