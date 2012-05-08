<#import "/WEB-INF/macros/common.ftl" as common>
<html>
<head>
  <title>Organization Detail</title>
  <meta name="gmap" content="true"/>
  <script type="text/javascript" src="<@s.url value='/js/vendor/jquery-1.7.1.min.js'/>"></script>
  <script type="text/javascript">
    $(function() {
      $( "#add_tag_bt" ).click(function() {
        value = $("#add_tag_tf").val();
        actionUrl = "${baseUrl}/admin/organization/add/tag/step";
        entityKey = "${id}";
        loader = cfg.baseUrl + "/img/ajax-loader.gif";
        $("#detail_tags").html( "<img src='" + loader + "'>" );
        $.post( actionUrl, { 
          'tag': value,
          'id': entityKey },
            function( data ) {
              $("#detail_tags").empty().append(data);
              $("#add_tag_tf").val('');  
        });          
      }); 
    });        
    $(function() {      
      $( ".deleteTag" ).live("click", function(e) {
        e.preventDefault();
        componentIndex=$(this).attr("name");      
        actionUrl = "${baseUrl}/admin/organization/delete/tag/" + componentIndex;
        entityKey = "${id}";
        loader = cfg.baseUrl + "/img/ajax-loader.gif";
        $("#detail_tags").html( "<img src='" + loader + "'>" );
        $.post( actionUrl, { 
          'tag': componentIndex,
          'id': entityKey },
            function( data ) {
              $("#detail_tags").empty().append(data);
              $("#add_tag_tf").val('');  
        });          
      });      
    });  
  </script>  
</head>
<body class="species typesmap">



<#assign tab="info"/>
<#include "/WEB-INF/inc/member/infoband.ftl">

<#include "/WEB-INF/inc/member/admin.ftl">

<article>
  <header></header>
  <div class="content">

    <div class="header">
      <div class="left"><h2>Organization Information</h2></div>
    </div>

    <div class="left">
      <#include "/WEB-INF/inc/member/basics.ftl">
    </div>

    <div class="right">
      <#if member.logoURL?has_content>
        <div class="logo_holder">
          <img src="${member.logoURL}"/>
        </div>
      </#if>

      <h3>Endorsed by</h3>
      <p><#if member.endorsingNode??><a href="<@s.url value='/node/${member.endorsingNode.key}'/>">${member.endorsingNode.title}</a><#else>Not endorsed yet</#if></p>

      <#if admin>
        <h3>Add tags</h3>
        <div id="detail_tags">
          <#list member.tags as tag>
            <#if tag.namespace?has_content>${tag.namespace}:</#if><#if tag.predicate?has_content>${tag.predicate}</#if><#if tag.value?has_content>=${tag.value}</#if>
            <a href="#"><img src="<@s.url value='/img/minus.png'/>" class="deleteTag" name="${tag_index}" id="${tag_index}"></a>
          </#list>        
        </div>
        <@s.textfield id="add_tag_tf" size="20" maxlength="50" cssClass="admin-tag-input"/> 
        <span class="admin-tag-caption">separate tags by a comma (,)</span> <@s.submit type="button" id="add_tag_bt" name="add_tag_bt">Add</@s.submit>
      </#if>

    </div>
  </div>
  <footer></footer>
</article>

<#include "/WEB-INF/inc/member/contribution.ftl">

<#include "/WEB-INF/inc/member/occmap.ftl">
  

</body>
</html>
