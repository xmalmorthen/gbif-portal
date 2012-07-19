<#macro manageTags type>  


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




  <script type="text/javascript" src="<@s.url value='/js/vendor/jquery-1.7.1.min.js'/>"></script> 
  <script type="text/javascript">
    $(function() {
      $( "#add_tag_bt" ).click(function() {
        value = $("#add_tag_tf").val();
        actionUrl = "${baseUrl}/admin/" + '${type}' + "/add/tag/step";
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
        actionUrl = "${baseUrl}/admin/" + '${type}' + "/delete/tag/" + componentIndex;
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

</#macro>