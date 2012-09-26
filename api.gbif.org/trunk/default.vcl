#backend default {
#  .host = "127.0.0.1";
#  .port = "80";
#}

backend boma {    
	.host = "192.38.28.83";       
	.port = "8080";     
}      

#backend mogo {    
#    .host = "130.226.238.242";       
#    .port = "8080";     
#}       

backend balancer {    
	.host = "130.226.238.134";       
	.port = "http";     
}       

backend jawa {    
	.host = "130.226.238.239";       
	.port = "8080";     
}

backend staging {
    .host = "staging.gbif.org";
    .port = "http";
}

backend stagingtomcat {
  .host = "staging.gbif.org";
  .port = "8080";
}

acl purge {
		"localhost";
		"192.38.28.0"/25;
	"130.226.238.128"/25;
}


sub vcl_recv {

if ( req.url ~ "^/favicon.ico") {
   error 404 "Not found";
}

if ( req.url ~ "^/geocode-ws/") {
   set req.backend = boma;
}

if ( req.url ~ "^/drupal") {
   set req.backend = staging ;
	set	req.http.host = "staging.gbif.org" ;
}

if ( req.url ~ "^/ws-nub/") {
   set req.http.host="balancer.gbif.org";
   set req.backend = balancer;
}

#if ( req.url ~ "^/ws-nub/") {
#   set req.backend = mogo;
#}

# if ( req.url ~ "^/registry-ws/" || req.url ~ "^/checklistbank-ws/" || req.url ~ "^/occurrence-ws/" || req.url ~ "^/occurrence-download-ws/") {
if ( 
  req.url ~ "^/registry-ws/" 
  || req.url ~ "^/checklistbank-ws/" 
  || req.url ~ "^/occurrence-ws/" 
  || req.url ~ "^/occurrence-download-ws/"
  || req.url ~ "^/checklistbank-search-ws/"
  || req.url ~ "^/registry-search-ws/") {
   set req.backend = jawa;
   if (req.url ~ "/occurrence-download-ws") {
       return (pass);
   }
}

if (req.url ~ "^/tile-server/"  ) {
  set req.backend = stagingtomcat;
}


if (req.request == "PURGE") {
   if (!client.ip ~ purge) {
	  error 405 "Not allowed.";
   } else {
	  purge_url(req.url);
	  error 200 "Purged";
   }
}

unset req.http.Cookie;

}

sub vcl_deliver {
     if((req.request == "PUT" || req.request == "POST") && (req.url ~ "/registry-ws") && (resp.status <= 400)) {      
        purge_url("/registry-ws/*");                        
     }
     return (deliver);
 }