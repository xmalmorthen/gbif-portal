(function(a){Drupal.hideEmailAdministratorCheckbox=function(){a("#edit-update-status-module-1").is(":checked")?a(".form-item-update-status-module-2").show():a(".form-item-update-status-module-2").hide(),a("#edit-update-status-module-1").change(function(){a(".form-item-update-status-module-2").toggle()})},Drupal.behaviors.cleanURLsSettingsCheck={attach:function(b,c){if(!a("#edit-clean-url").length||a("#edit-clean-url.install").once("clean-url").length)return;var d=c.basePath+"admin/config/search/clean-urls/check";a.ajax({url:location.protocol+"//"+location.host+d,dataType:"json",success:function(){location=c.basePath+"admin/config/search/clean-urls"}})}},Drupal.cleanURLsInstallCheck=function(){var b=location.protocol+"//"+location.host+Drupal.settings.basePath+"admin/config/search/clean-urls/check";a.ajax({async:!1,url:b,dataType:"json",success:function(){a("#edit-clean-url").attr("value",1)}})},Drupal.behaviors.copyFieldValue={attach:function(b,c){for(var d in c.copyFieldValue)a("#"+d,b).once("copy-field-values").bind("blur",function(){var b=c.copyFieldValue[d];for(var e in b){var f=a("#"+b[e]);f.val()==""&&f.val(this.value)}})}},Drupal.behaviors.dateTime={attach:function(b,c){for(var d in c.dateTime){var c=c.dateTime[d],e="#edit-"+d,f=e+"-suffix";a("input"+e,b).once("date-time").keyup(function(){var b=a(this),d=c.lookup+(c.lookup.match(/\?q=/)?"&format=":"?format=")+encodeURIComponent(b.val());a.getJSON(d,function(b){a(f).empty().append(" "+c.text+": <em>"+b+"</em>")})})}}},Drupal.behaviors.pageCache={attach:function(b,c){a("#edit-cache-0",b).change(function(){a("#page-compression-wrapper").hide(),a("#cache-error").hide()}),a("#edit-cache-1",b).change(function(){a("#page-compression-wrapper").show(),a("#cache-error").hide()}),a("#edit-cache-2",b).change(function(){a("#page-compression-wrapper").show(),a("#cache-error").show()})}}})(jQuery);