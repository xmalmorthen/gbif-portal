<script type="text/javascript">
$(function() {
  $( "#deleteTag" ).click(function() {
    tag=$("#deleteTag").attr("name");
    loader = cfg.baseUrl + "/img/ajax-loader.gif";
    $("#currentTags").html( "<img src='" + loader + "'>" );
    actionUrl = cfg.baseUrl + "/admin/organization/delete/tag/" + tag;
    alert(actionUrl);
    value = $("input[name='currentTag']").val();  
    $.post( actionUrl, { 
      'tag.value': value },
        function( data ) {
          $( "#currentTags" ).empty().append( data );
          $("input[name='currentTag']").val('');
    });
  });
});
</script>
<!-- Modify this template with either a success page, or include some kind of redirect in struts.xml in case of sucess -->
<#list tags as tag>
  ${tag.value} <a href="#"><img src="<@s.url value='/img/minus.png'/>" id="deleteTag" name="${tag.value}"></a>
</#list>  