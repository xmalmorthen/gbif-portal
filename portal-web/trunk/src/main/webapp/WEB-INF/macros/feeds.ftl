<#macro googleFeedJs url target>
  var tmplG = $("#rss-google").html();
  // we use google feed API to read external cross domain feeds
  $.getJSON( 'http://ajax.googleapis.com/ajax/services/feed/load?v=1.0&num=10&output=json&q=${url}&hl=en&callback=?', function( resp ) {
    $("${target}").html( _.template(tmplG, {feed:resp.responseData.feed}) );
    $("${target} .date").each(function(i) {
      var md = moment($(this).text());
      $(this).text(md.fromNow());
    });
  });
</#macro>

<#macro drupalFeedJs tagId target>
  var tmplD = $("#rss-google-search").html();
  $.getJSON( 'http://ajax.googleapis.com/ajax/services/feed/load?v=1.0&num=10&output=json&q=${cfg.drupal}/taxonomy/term/${tagId}/feed&hl=en&callback=?', function( resp ) {
    $("${target}").html( _.template(tmplD, {feed:resp.responseData.feed}) );
    $("${target} .date").each(function(i) {
      var md = moment($(this).text());
      $(this).text(md.fromNow());
    });
  });
</#macro>


<#macro mendeleyFeedJs isoCode target>
  var tmplM = $("#mendeley-publications").html();
  <#-- the drupal mendeley module does not offer JSONP yet -->
  $.getJSON("<@s.url value='/mendeley/country/${isoCode}/json'/>", function(data){
    console.log(data);
    $("${target}").html( _.template(tmplM, {feed:data}) );
  });
</#macro>
