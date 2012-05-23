<html>
<head>
  <title>Occurrences - GBIF</title>
  <content tag="extra_scripts">
    <script type="text/javascript" src="http://maps.google.com/maps/api/js?sensor=false&libraries=drawing"></script>
    <script src="<@s.url value='/js/vendor/polygonEdit.js'/>" type="text/javascript"></script>
    <script type="text/javascript" src="<@s.url value='/js/custom/jquery.gbif.filters.js'/>"></script>
    <!-- https://github.com/allmarkedup/jQuery-URL-Parser -->
    <script src='<@s.url value='/js/vendor/jquery.url.js'/>' type='text/javascript'></script>  
    <script src="<@s.url value='/js/vendor/jquery.simplemodal.1.4.2.min.js'/>" type="text/javascript"></script>
    <link rel="stylesheet" href="<@s.url value='/css/simple-modal.css'/>"/>
	<style>
      div.general_options ul {position:relative; bottom:0px; left:0px; display:inline-block; width:auto; height:28px; padding:3px 0px 0px 3px; margin:0; background:#282F49; -webkit-border-top-left-radius: 5px; -moz-border-radius-topleft: 5px; border-top-left-radius: 5px; z-index:100;}
      div.map_options ul{display:inline-block; margin:0px; padding:0px; width:auto; height:28px; padding:3px 0px 0px 3px;}
      div.map_options ul li {display:inline-block; width:auto; height:25px; margin-right:1px; vertical-align:middle; overflow:hidden;}
      div.map_options ul li a {display:block; width:auto; height:11px; padding:6px 7px; text-decoration:none; -webkit-border-radius:5px;-moz-border-radius:5px;border-radius:5px;border:1px solid #161A29; font:bold 11px Arial; color:#333333; text-shadow:0 1px white;background:linear-gradient(-90deg,#ffffff,#CACBCE);background:-webkit-gradient(linear,50% 0%,50% 100%,from(#ffffff),to(#CACBCE));background:-moz-linear-gradient(-90deg,#ffffff,#CACBCE);background:-o-linear-gradient(#ffffff,#CACBCE);background:#ffffff\9;cursor:default;}
      div.map_options ul li a:hover {background:linear-gradient(-90deg,#CACBCE,#ffffff);background:-webkit-gradient(linear,50% 0%,50% 100%,from(#CACBCE),to(#ffffff));background:-moz-linear-gradient(-90deg,#CACBCE,#ffffff);background:-o-linear-gradient(#CACBCE,#ffffff);background:#CACBCE\9;cursor:pointer;}
      
.description {
  margin-top: 10px;
  padding: 10px;
  color: #666;
  background-color: #E5F5FA;
}      
      
p.query {
  color: #999;
  margin: 0px;
  padding: 0px;
  font-size: 11px;
  font-family: DINOT-Medium, sans-serif;
}
ul.query {
  list-style: none;
  padding: 0px 0px 10px 10px;
  margin: 0px;
  color: #666;
  font-weight: bold;
}
ul.query .boolean {
  color: #999;
  margin: 0px;
  padding: 0px;
  font-size: 11px;
  font-weight: normal;
  font-family: DINOT-Medium, sans-serif;
}

select,input {
  margin-right: 5px;
}
select.subject {
  width: 150px;
}
select.predicate {
  width: 120px;
}
select.value {
  width: 200px;
}      
      
	</style>  
    
  <script>
  
    var query = $('#query-container').Query();
    
    // subject container with event wiring to trigger changes on query
    $('#filter-container').Filter({
      json:"/conf/occurrence-download.json",
      addFilter: function(event, data) { 
        query.Query("add", data.filter);
      }
    });
    
    $('#submit-button').click(function() {
      // construct the query parameters again.  This will remove ALL
      // parameters and reconstruct the URL with the new filter
      // This might cause issues in the future, if other parameters are needed
      // https://github.com/allmarkedup/jQuery-URL-Parser
      var u = $.url();
      window.location = u.attr('protocol') + "://" + u.attr('host') + ":" + u.attr('port') + u.attr('path') + query.Query("serialize");
      return true;  // submit?
    });
    
  </script> 
     
  </content>
  <meta name="menu" content="occurrences"/>
</head>
<body class="dataset">

  <article class="results light_pane">
    <header></header>
    <div class="content">
		
      <div class="header">
        <div class="left">
          <h2>Add a filter</h2>
        </div>
        <div class="right">
          <h3>Your search</h3>
        </div>
      </div>
        <div class="left">
          <div id='filter-container'></div>
        </div>
        <div class="right">
          <div id='query-container'></div>
          <input type="submit" id="submit-button" value="Download"></input>
        </div>
    </div>
    <footer></footer>
  </article>

</body>
</html>
